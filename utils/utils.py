# Copyright 2019 Yandex LLC. All rights reserved.

import contextlib
import shutil
import tempfile


@contextlib.contextmanager
def scoped_output_dir():
    try:
        temp_dir = tempfile.mkdtemp()
        yield temp_dir
    finally:
        shutil.rmtree(temp_dir)
