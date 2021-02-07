PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) "
PROMPT+='%{$fg[cyan]%}%(4~|%-1~/…/%2~|%3~)%{$reset_color%} $(git_prompt_info)'

if lsof -tac script "$(tty)" > /dev/null; then
    PROMPT="[%D{%d}|%D{%k:%M}]* $PROMPT"
else
    PROMPT="[%D{%d}|%D{%k:%M}] $PROMPT"
fi

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
