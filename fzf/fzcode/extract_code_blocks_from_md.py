#!/usr/bin/env python3

import sys

from exdown import extract

if __name__ == '__main__':
	code_blocks = extract(sys.argv[1])
	for block in code_blocks:
		for line in block.code.splitlines():
			print(line.strip())
