function prompt_char {
    command git branch &>/dev/null && echo '⠠⠵' || echo "%F{red}$%F{reset}"
}

function user_name {
    [ -f ~/.zsh_un ] && cat ~/.zsh_un || echo "%n"
}

function host_name {
    [ -f ~/.zsh_hn ] && cat ~/.zsh_hn || echo ${SHORT_HOST:-$HOST}
}

function virtualenv_prompt_info {
    [[ -n ${VIRTUAL_ENV} ]] || return
    echo "${ZSH_THEME_VIRTUALENV_PREFIX:=[}${VIRTUAL_ENV:t}${ZSH_THEME_VIRTUALENV_SUFFIX:=]}"
}

function proxychains_prompt_info() {
    [[ "$PROXYCHAINS_PROFILE" != "default" ]] || return
    echo "${ZSH_THEME_PROXYCHAINS_PREFIX:=[}${PROXYCHAINS_PROFILE:t}${ZSH_THEME_PROXYCHAINS_SUFFIX:=]}"
}

local prompt_char='$(prompt_char)'
#local git_info='${git_info_msg_0_}'
local git_info='$(git_prompt_info)'
local virtualenv_info='$(virtualenv_prompt_info)'
local ruby_info='$(ruby_prompt_info)'
local proxychains_info='$(proxychains_prompt_info)'

PROMPT="${FG[044]}$(user_name) ${FG[244]}on ${FG[147]}$(host_name) ${FG[244]}in %B${FG[227]}%~%b${git_info}${virtualenv_info}${ruby_info}${proxychains_info} ${FG[244]}at ${FG[252]}[%D{%d/%m} %D{%k:%M}]"
RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'

if [ "$(ps -ocommand= $PPID | awk '{print $1}')" = 'script' ]; then
    PROMPT+="${FG[160]}*"
fi

PROMPT+="%{$reset_color%}"$'\n'"${prompt_char} "

ZSH_THEME_GIT_PROMPT_PREFIX=" ${FG[244]}via%{$reset_color%} ${FG[196]}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="${FG[178]}✘"
ZSH_THEME_GIT_PROMPT_CLEAN="${FG[040]}✔"

ZSH_THEME_VIRTUALENV_PREFIX=" ${FG[244]}venv${FG[118]} "
ZSH_THEME_VIRTUALENV_SUFFIX="%{$reset_color%}🐍"

ZSH_THEME_RUBY_PROMPT_PREFIX=" ${FG[244]}ruby${FG[160]} "
ZSH_THEME_RUBY_PROMPT_SUFFIX="%{$reset_color%}💎"

ZSH_THEME_PROXYCHAINS_PREFIX=" ${FG[244]}proxy${FG[111]} "
ZSH_THEME_PROXYCHAINS_SUFFIX="%{$reset_color%}📡"
