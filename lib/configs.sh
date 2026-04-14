#!/usr/bin/env bash

deploy_configs() {
    local backup_dir="$HOME/.config_backups/$(date +%Y%m%d_%H%M%S)"
    log "info" "Бэкап в $backup_dir"
    mkdir -p "$backup_dir"

    # Бэкапим только то, что собираемся заменить
    for item in "$REPO_DIR/configs/"*; do
        local name=$(basename "$item")
        [ -e "$HOME/.config/$name" ] && mv "$HOME/.config/$name" "$backup_dir/"
    done

    log "info" "Развертывание новых конфигураций..."
    mkdir -p "$HOME/.config"
    cp -r "$REPO_DIR/configs/"* "$HOME/.config/"
    
    # Скрипты
    if [ -d "$REPO_DIR/scripts" ]; then
        mkdir -p "$HOME/.config/sway/scripts"
        cp -r "$REPO_DIR/scripts/"* "$HOME/.config/sway/scripts/"
        chmod +x "$HOME/.config/sway/scripts/"*
    fi
}