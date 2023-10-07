# -*- sh -*-

# https://vincent.bernat.ch/en/blog/2019-zsh-async-vcs-info
# https://github.com/vincentbernat/zshrc/blob/d66fd6b6ea5b3c899efb7f36141e3c8eb7ce348b/rc/vcs.zsh
# https://medium.com/@henrebotha/how-to-write-an-asynchronous-zsh-prompt-b53e81720d32

_git_async_start() {
    async_start_worker git_prompt_info
    async_register_callback git_prompt_info _git_prompt_info_done
}

_git_prompt_info() {
    cd -q $1
    git_prompt_info
}

_git_prompt_info_done() {
    local job=$1
    local return_code=$2
    local stdout=$3
    local more=$6
    if [[ $job == '[async]' ]]; then
        if [[ $return_code -eq 2 ]]; then
            # Need to restart the worker. Stolen from
            # https://github.com/mengelbrecht/slimline/blob/master/lib/async.zsh
            _git_async_start
            return
        fi
    fi
    git_info_msg_0_=$stdout
    [[ $more == 1 ]] || zle reset-prompt
}

source "${ZSH}/custom/plugins/async/async.plugin.zsh"
async_init

_git_async_start

add-zsh-hook precmd() {
    async_job git_prompt_info _git_prompt_info $PWD
}

add-zsh-hook chpwd() {
    git_info_msg_0_=
}
