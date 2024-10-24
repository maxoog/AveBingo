import argparse
import collections
import os
import subprocess

import utils

SYMBOL_COMMAND = 'xcrun nm -P -n \'{}\' | tee \'{}\' | xcrun swift-demangle --simplified | c++filt > \'{}\''


def extract_symbol(symbol_line):
    parts = symbol_line.strip().split(' ')
    if len(parts) < 4:
        raise Exception('Unexpected symbol_line: {}'.format(symbol_line))
    return ' '.join(parts[0:-3]).strip()


def generate_symbol_map(symbols):
    with utils.scoped_output_dir() as output_dir:
        symbol_file = os.path.join(output_dir, 'symbols')
        demangled_file = os.path.join(output_dir, 'demangled')
        subprocess.check_output(SYMBOL_COMMAND.format(symbols, symbol_file, demangled_file), shell=True)

        with open(symbol_file, 'r') as f:
            symbols = [extract_symbol(x) for x in f.readlines()]
        with open(demangled_file, 'r') as f:
            demangled = [extract_symbol(x) for x in f.readlines()]

        assert len(symbols) == len(demangled)
        demangled_to_symbol = collections.defaultdict(set)
        for i in range(len(symbols)):
            for symbol in [symbols[i], demangled[i]]:
                demangled_to_symbol[symbol].add(symbols[i])
                for strip in range(120, 129):
                    if len(symbol) > strip:
                        demangled_to_symbol[symbol[0:strip]].add(symbols[i])

        return demangled_to_symbol


def extrace_functions(demangled_to_symbol, entry):
    funcs = demangled_to_symbol[entry]
    if len(funcs) == 0:
        funcs = demangled_to_symbol['_' + entry]
    return funcs


def main():
    parser = argparse.ArgumentParser(description='Creates an orderfile from log.')
    parser.add_argument('--log', type=str, required=True, help='Path to the log')
    parser.add_argument('--symbols', type=str, required=True,
                        help='Path to executable with symbols')
    args = parser.parse_args()

    with open(args.log, 'r') as f:
        log = [x.strip() for x in f.readlines()]

    demangled_to_symbol = generate_symbol_map(args.symbols)
    for entry in log:
        funcs = extrace_functions(demangled_to_symbol, entry)
        if len(funcs) == 0:
            raise Exception('Unexpected entry: {}'.format(entry))
        for out in sorted(funcs):
            print(out)


if __name__ == '__main__':
    main()
