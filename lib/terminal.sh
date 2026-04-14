#!/usr/bin/env bash

setup_term() {
    log "INFO" "Тюнинг терминала..."
    sudo pacman -S --needed --noconfirm fish starship
    
    # Настройка промпта
    mkdir -p ~/.config
    echo 'eval "$(starship init fish)"' > ~/.config/fish/config.fish
    echo 'set -g fish_greeting ""' >> ~/.config/fish/config.fish
    
    # Минималистичный конфиг Starship
    cat <<EOF > ~/.config/starship.toml
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"
EOF
    log "SUCCESS" "Fish и Starship настроены."
}