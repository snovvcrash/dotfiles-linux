#!/usr/bin/env bash

# Usage: ./fzcode.sh

mkdir -p /tmp/fzcode ~/.fzcode

parse_ghpages_posts() {
	files=`curl -s "https://api.github.com/repos/$1/$1.github.io/git/trees/master?recursive=1" | jq '.tree[] .path' | grep '_posts/' | awk -F/ '{ print $2 }' | tr -d '"'`
	for f in $files; do
		curl -sL "https://github.com/$1/$1.github.io/raw/master/_posts/$f" > /tmp/fzcode/$f
		dos2unix /tmp/fzcode/$f
		./extract_code_blocks_from_md.py /tmp/fzcode/$f >> ~/.fzcode/posts
	done
}

parse_ppn() {
	curl -sL "https://github.com/snovvcrash/PPN/raw/master/README.md" > /tmp/fzcode/ppn
	dos2unix /tmp/fzcode/ppn
	./extract_code_blocks_from_md.py /tmp/fzcode/ppn > ~/.fzcode/ppn
}

parse_ghpages_posts snovvcrash
parse_ppn

rm -rf /tmp/fzcode
