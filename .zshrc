# -*- mode: zsh -*-
# vim: et sw=4 ts=4 ft=zsh

export LC_CTYPE=en_US.UTF-8
if [[ -o interactive ]] && [[ -o zle ]]; then
    for func in ~/.dotfiles/.functions/*.zsh; do source ${func}; done; unset func
    case "${(L)$(uname -s)}" in linux) cpu=$(awk '/^processor/ {++n} END {print n+1}' /proc/cpuinfo) ;; esac
    case "${(L)$(uname -s)}" in darwin) cpu=$(sysctl -n hw.ncpu) ;; esac
    export ZPLUG_HOME=${HOME}/.zplug
    export ZPLUG_BIN=${HOME}/bin
    export ZPLUG_LOADFILE=${HOME}/.dotfiles/.zplug.pkg
    export ZPLUG_THREADS=${cpu}
    [[ -d ${ZPLUG_HOME} ]] || git clone https://github.com/zplug/zplug ${ZPLUG_HOME}
    [[ -f "$ZPLUG_HOME/init.zsh" ]] && source $ZPLUG_HOME/init.zsh
    # zplug check returns true if all packages are installed
    # Therefore, when it returns false, run zplug install
    zplug check || zplug install
    # source plugins and add commands to the PATH
    (( $debug )) && zplug load --verbose || zplug load
    [[ -f "${HOME}/.dotfiles/.zplugrc" ]] && source "${HOME}/.dotfiles/.zplugrc"
    [[ -f "${HOME}/.dotfiles/.aliases" ]] && source "${HOME}/.dotfiles/.aliases"
    local -a compaudits
    compaudits=($(compaudit 2>/dev/null))
    [[ -z "${compaudits}" ]] || chmod g-w ${compaudits}
fi
