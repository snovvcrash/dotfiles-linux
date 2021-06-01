#!/usr/bin/env bash

# Usage: ./fzcode.sh

rm -rf /tmp/{fzcode,PPN} ~/.fzcode
mkdir /tmp/fzcode ~/.fzcode

parse_ghpages_posts() {
	files=`curl -s "https://api.github.com/repos/$1/$1.github.io/git/trees/master?recursive=1" | jq '.tree[] .path' | grep '_posts/' | awk -F/ '{ print $2 }' | tr -d '"'`
	for f in $files; do
		curl -sL "https://github.com/$1/$1.github.io/raw/master/_posts/$f" > /tmp/fzcode/$f
		dos2unix /tmp/fzcode/$f
		./extract_code_blocks_from_md.py /tmp/fzcode/$f >> ~/.fzcode/posts
	done
}

parse_ppn() {
	git clone https://github.com/snovvcrash/PPN /tmp/PPN
	for f in /tmp/PPN/**/*.md; do
		dos2unix $f
		./extract_code_blocks_from_md.py $f >> ~/.fzcode/ppn
	done
}

#parse_ghpages_posts snovvcrash
parse_ppn
