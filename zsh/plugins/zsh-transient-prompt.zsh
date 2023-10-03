# https://github.com/romkatv/powerlevel10k/issues/888#issuecomment-657969840
# https://vincent.bernat.ch/en/blog/2021-zsh-transient-prompt

zle-line-init() {
	emulate -L zsh

	[[ $CONTEXT == start ]] || return 0

	while true; do
		zle .recursive-edit
		local -i ret=$?
		[[ $ret == 0 && $KEYS == $'\4' ]] || break
		[[ -o ignore_eof ]] || exit 0
	done

	local saved_prompt=$PROMPT
	local saved_rprompt=$RPROMPT

	PROMPT="${FG[249]}[%D{%d}|%D{%k:%M}] ${FG[044]}❯%f "
	RPROMPT=''

	zle .reset-prompt
	PROMPT=$saved_prompt
	RPROMPT=$saved_rprompt

	if (( ret )); then
		zle .send-break
	else
		zle .accept-line
	fi

	return ret
}
zle -N zle-line-init
