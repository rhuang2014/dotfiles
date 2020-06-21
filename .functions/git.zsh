# vim: et sw=4 ts=4 ft=zsh

git-clean-ws() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
    git checkout master
    git remote prune origin
    local -a merged remote_merged remote_no_merged
    merged=($(git branch --merged | egrep -v 'master$'))
    (( ${#merged} > 0 )) && git branch -d ${merged}
    remote_merged=($(git branch -r --merged | egrep -v 'HEAD|master'))
    remote_no_merged=($(git branch -r --no-merged | egrep -v 'HEAD|master'))
    (( $((${#remote_merged} + ${#remote_no_merged})) > 0 )) && echo "########################################################"
    (( ${#remote_merged} > 0 )) && echo "# Remote merged branches"
    for branch (${remote_merged}); do
        echo -e `git show --format="%ci %cr %an" ${branch} | head -n 1` \\t${branch}
    done | sort -r
    (( ${#remote_no_merged} > 0 )) && echo "# Remote pending merged branches"
    for branch (${remote_no_merged}); do
        echo -e `git show --format="%ci %cr %an" ${branch} | head -n 1` \\t${branch}
    done | sort -r
}

# fshow - git commit browser
git-browser() {
    (( $+commands[fzf] )) || { echo "missing fzf"; return; }
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
    git log --graph --color=always \
        --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' "$@"|
        fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# git-crypt
git-crypt-keys() {
    (( $+commands[git-crypt] )) || { echo "missing git-crypt"; return; }
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
    [[ -d .git-crypt/keys ]] || return
    for key (.git-crypt/keys/default/0/*); do
        gpg -k ${key:t:r} 2>/dev/null
        [[ $? -ne 0 ]] && echo "error reading key: No public key for ${key:t:r}"
    done
}

# prl github PR list/browser
# https://hub.github.com/hub-pr.1.html
prl() {
    (( $+commands[fzf] )) && (( $+commands[hub] )) || { echo "missing fzf"; return; }
    local cols sep
    cols=$(( COLUMNS / 3 ))
    sep='{{::}}'
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
    hub pr list -L 25 -b master --format='%t (%au) [%H] {{::}} %U%n'|
        awk -F $sep '{printf "\x1b[36m%-'$cols's  %s\x1b[m\n", $1, $2}'|
        fzf --ansi --multi | sed 's#.*\(https*://\)#\1#'|xargs open
}

gc() {
    local -a links domain
    local link
    for link ($@); do
        if [[ ${link} =~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}:' ]]; then
            [[ -n ${(M)link:#*:/*} ]] && links=(${(s_@_)${link:s|:/|/|}}) || links=(${(s_@_)${link:s|:|/|}})
        else
            links=(${(s_:_)${link:s/@/./}})
        fi
        if [[ $links[1] =~ '(http|git)' ]]; then
            links=(${(s_/_)${(s_//_)links[2]}})
            links=($links[1] ${(j_/_)links[-2,-1]})
        fi
        domain=(${(s_._)links[1]})
        loc=${(j_/_)${(s_/_)links[2]:r}[-2,-1]}
        cop=~/dev/${domain[-2]}/${loc}
        echo "$link, $links, ${domain[-2]}, ${loc}, ${cop}"
        [[ -d ${cop} ]] || mkdir -p ${cop}
        git clone ${link} ${cop} && cd ${cop} || cd ${cop}
    done
}
