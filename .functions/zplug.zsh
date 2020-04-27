# vim: et sw=4 ts=4 ft=zsh

function zplug-refresh () {
    zplug clean --force
    zplug clear
    zplug update
}
