if status is-interactive
    starship init fish | source
end

set -g fish_greeting ""
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'