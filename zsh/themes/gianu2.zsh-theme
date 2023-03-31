function user_name {
    [ -f ~/.zsh_un ] && cat ~/.zsh_un || echo "%n"
}

function host_name {
    [ -f ~/.zsh_hn ] && cat ~/.zsh_hn || echo ${SHORT_HOST:-$HOST}
}

PROMPT='[%{$fg_bold[white]%}$(user_name)%{$reset_color%}@%{$fg_bold[green]%}$(host_name)%{$reset_color%}:%{$fg_bold[blue]%}%c%{$reset_color%} $(git_prompt_info)%{$reset_color%}] %B%{$FG[214]%}%D{%y-%m-%d} %D{%k:%M}%{$reset_color%}%b '

if [ "$(ps -ocommand= $PPID | awk '{print $1}')" = 'script' ]; then
    PROMPT+="%F{red}$%F{reset} "
else
    PROMPT+="$ "
fi

ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%} %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}"
