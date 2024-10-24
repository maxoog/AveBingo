import argparse
import re
import signal
import string
import subprocess

LLDB_PID_RE = re.compile(r'Process (?P<pid>\d+) stopped')
DTRACE_PROGRAM = """pid${pid}:${product}::entry { printf("%s\\n", probefunc); }"""

class LldbWorker(object):
    def __init__(self, product):
        self.product = product
        self.p = subprocess.Popen('lldb', stdout=subprocess.PIPE, stdin=subprocess.PIPE, bufsize=-1)

    def shutdown(self):
        self.p.stdout.close()
        self.p.stdin.close()
        self.p.wait()

    def get_pid(self):
        self.p.stdin.write('process attach --name {} --waitfor\n'.format(self.product).encode('utf-8'))
        self.p.stdin.flush()

        self.p.stdout.readline()
        pid_line = self.p.stdout.readline().decode('utf-8').strip()
        pid = LLDB_PID_RE.match(pid_line).group('pid')
        return pid

    def detach(self):
        self.p.stdin.write('process detach\n'.encode('utf-8'))
        self.p.stdin.flush()
        self.p.stdin.write('exit\n'.encode('utf-8'))
        self.p.stdin.flush()

    def send_interrupted(self):
        self.p.send_signal(signal.SIGINT)


def main():
    parser = argparse.ArgumentParser(description='Record startup log with dtrace.')
    parser.add_argument('--product', type=str, required=True, help='Product name')
    args = parser.parse_args()

    lldb_worker = LldbWorker(args.product)
    try:
        p = None
        pid = lldb_worker.get_pid()

        program = string.Template(DTRACE_PROGRAM).substitute(pid=pid, product=args.product)
        p = subprocess.Popen(
            ['dtrace', '-xmangled', '-q', '-n', program], stdout=subprocess.PIPE, bufsize=-1
        )
        lldb_worker.detach()
        used = set()
        for line in p.stdout:
            line = line.decode('utf-8').strip()
            if line in used:
                continue
            used.add(line)
            print(line)
    except KeyboardInterrupt:
        lldb_worker.send_interrupted()
        if p:
            p.send_signal(signal.SIGINT)
    finally:
        if p:
            p.stdout.close()
            p.wait()
        lldb_worker.shutdown()


if __name__ == '__main__':
    main()
