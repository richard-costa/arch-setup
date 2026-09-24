# Personal Fish configuration.
#
# The old setup sourced the CachyOS Fish config directly. This version stays
# distribution-independent so it works on vanilla Arch.

# Keep the startup quiet.
function fish_greeting
end

# Familiar modern command aliases for interactive use.
if type -q eza
    alias ls='eza'
    alias ll='eza -lah --group-directories-first'
    alias la='eza -a'
end

if type -q bat
    alias cat='bat --paging=never'
end

# Package maintenance shortcuts.
alias update='sudo pacman -Syu'
alias orphans='pacman -Qdt'

# The optional tealdeer package provides the tldr command.
