function virtualenv_prompt_info {
	[[ -n ${VIRTUAL_ENV} ]] || return
	echo "${ZSH_THEME_VIRTUALENV_PREFIX:=[}${VIRTUAL_ENV:t}${ZSH_THEME_VIRTUALENV_SUFFIX:=]}"
}

function prompt_char {
  command git branch &>/dev/null && echo '⠠⠵' || echo '○'
}

function user_name {
	[ -f ~/.zsh_un ] && cat ~/.zsh_un || echo "%n"
}

function host_name {
	[ -f ~/.zsh_hn ] && cat ~/.zsh_hn || echo ${SHORT_HOST:-$HOST}
}

local ruby_env='$(ruby_prompt_info)'
local git_info='$(git_prompt_info)'
local virtualenv_info='$(virtualenv_prompt_info)'
local prompt_char='$(prompt_char)'

PROMPT="╭─${FG[208]}$(user_name) ${FG[244]}on ${FG[033]}$(host_name) ${FG[244]}in %B${FG[226]}%~%b${git_info}${ruby_env}${virtualenv_info} ${FG[244]}at ${FG[137]}[%D{%d/%m} %D{%k:%M}]"

if lsof -tac script "$(tty)" > /dev/null; then
	PROMPT+="${FG[160]}*"
fi

PROMPT+="%{$reset_color%}"$'\n'"╰─${prompt_char} "

ZSH_THEME_GIT_PROMPT_PREFIX=" ${FG[244]}via%{$reset_color%} ${FG[196]}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="${FG[178]}✘"
ZSH_THEME_GIT_PROMPT_CLEAN="${FG[040]}✔"

ZSH_THEME_RUBY_PROMPT_PREFIX=" ${FG[244]}using${FG[118]} "
ZSH_THEME_RUBY_PROMPT_SUFFIX="%{$reset_color%}💎"

export VIRTUAL_ENV_DISABLE_PROMPT=1
ZSH_THEME_VIRTUALENV_PREFIX=" ${FG[244]}using${FG[118]} "
ZSH_THEME_VIRTUALENV_SUFFIX="%{$reset_color%}🐍"
