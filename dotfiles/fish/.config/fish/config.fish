# Personal Fish configuration.
#
# Keeps the useful, distribution-independent parts of CachyOS's Fish setup
# without sourcing /usr/share/cachyos-fish-config.

# CachyOS showed a system summary whenever a new interactive shell opened.
function fish_greeting
    if type -q fastfetch
        fastfetch
    end
end

# Make man pages easier to read when bat is available.
if type -q bat
    set -gx MANROFFOPT "-c"
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
end

# Default terminal editor. Keeping this in the tracked config replaces the
# manual "set -Ux EDITOR/VISUAL micro" commands.
set -gx EDITOR micro
set -gx VISUAL micro

# Common user executable locations.
fish_add_path ~/.local/bin ~/.cargo/bin

# Show timestamps when explicitly viewing Fish command history.
function history
    builtin history --show-time='%F %T ' $argv
end

# Quick one-file backup: backup notes.md -> notes.md.bak
function backup --argument filename
    cp $filename $filename.bak
end

# eza replaces ls in the current CachyOS setup.
if type -q eza
    alias ls='eza -al --color=always --group-directories-first --icons=always'
    alias la='eza -a --color=always --group-directories-first --icons=always'
    alias ll='eza -l --color=always --group-directories-first --icons=always'
    alias lt='eza -aT --color=always --group-directories-first --icons=always'
    alias l.="eza -a | grep -e '^\.'"
end

# Navigation shortcuts inherited from the current shell configuration.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Useful diagnostics / maintenance.
alias hw='hwinfo --short'
alias jctl='journalctl -p 3 -xb'
alias update='sudo pacman -Syu'
alias orphans='pacman -Qdt'

# Resume partially-downloaded files by default.
alias wget='wget -c '

# tealdeer (optional extras) provides: tldr <command>
