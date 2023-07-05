function virtualenv_prompt_info {
    [[ -n ${VIRTUAL_ENV} ]] || return
    echo "${ZSH_THEME_VIRTUALENV_PREFIX:=[}${VIRTUAL_ENV:t}${ZSH_THEME_VIRTUALENV_SUFFIX:=]}"
}

PROMPT="[%D{%d}|%D{%k:%M}]"

if lsof -tac script "$(tty)" > /dev/null; then
    PROMPT+="${FG[160]}*%{$reset_color%}"
fi

PROMPT+=' %(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) $(virtualenv_prompt_info)%{$fg[cyan]%}%(4~|%-1~/…/%2~|%3~)%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

ZSH_THEME_VIRTUALENV_PREFIX="${FG[118]}("
ZSH_THEME_VIRTUALENV_SUFFIX=") "
