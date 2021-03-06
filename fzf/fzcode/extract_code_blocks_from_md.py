#!/usr/bin/env python3

from argparse import ArgumentParser

from exdown import extract

parser = ArgumentParser()
parser.add_argument('input_md', help='input markdown file')
args = parser.parse_args()

if __name__ == '__main__':
	code_blocks = extract(args.input_md)
	for line, num in code_blocks:
		print(line.strip())
