# -*- mode: zsh -*-
# vim: et sw=4 ts=4 ft=zsh

export LC_CTYPE='en_US.UTF-8'
export LANG='en_US.UTF-8'
[[ -d ~/bin ]] && path+=(~/bin)
if [[ -o interactive ]] && [[ -o zle ]]; then
    case "${(L)$(uname -s)}" in linux) cpu=$(awk '/^processor/ {++n} END {print n+1}' /proc/cpuinfo) ;; esac
    case "${(L)$(uname -s)}" in darwin) cpu=$(sysctl -n hw.ncpu) ;; esac
    declare -A ZINIT
    ZINIT[HOME_DIR]="${HOME}/.zinit"
    ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/bin"
    ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1
    if ! test -d "${ZINIT[HOME_DIR]}"; then
        mkdir "${ZINIT[HOME_DIR]}" && chmod go-rwX "${ZINIT[HOME_DIR]}"
        if command -v git >/dev/null 2>&1; then
            [[ -d "${ZINIT[BIN_DIR]}" ]] || git clone https://github.com/zdharma/zinit.git "${ZINIT[BIN_DIR]}"
        fi
    fi
    [[ -s "${ZINIT[BIN_DIR]}/zinit.zsh" ]] && source "${ZINIT[BIN_DIR]}/zinit.zsh"
    autoload -Uz _zinit
    (( ${+_comps} )) && _comps[zinit]=_zinit
    [[ -s "${HOME}/.dotfiles/.zinitrc" ]] && source "${HOME}/.dotfiles/.zinitrc"
    local -a compaudits
    compaudits=($(compaudit 2>/dev/null))
    [[ -z "${compaudits}" ]] || chmod g-w ${compaudits}
fi
(( $+commands[brew] )) && [[ -d $(brew --prefix)/opt/python@3/bin ]] && path=($(brew --prefix)/opt/python@3/bin "$path[@]")
