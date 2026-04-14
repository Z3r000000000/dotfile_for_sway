if status is-interactive
    starship init fish | source
end

set -g fish_greeting ""
set -g fish_color_valid_path --underline=none
set -g fish_color_uri --underline=none
set -g fish_pager_color_prefix --underline=none
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'