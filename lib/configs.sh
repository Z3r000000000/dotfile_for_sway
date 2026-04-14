#!/usr/bin/env bash
deploy_configs() {
    local backup_dir="$HOME/.config_backups/$(date +%Y%m%d_%H%M%S)"
    log "info" "Бэкап старых конфигов в $backup_dir"
    mkdir -p "$backup_dir" "$HOME/.config"

    # Копируем всё из папки configs репозитория в ~/.config
    cp -r "$REPO_DIR/configs/"* "$HOME/.config/"
    
    # Отдельная обработка Starship (он обычно лежит в корне .config)
    if [ -f "$REPO_DIR/configs/starship.toml" ]; then
        mv "$HOME/.config/starship.toml" "$HOME/.config/starship.toml.bak" 2>/dev/null
        cp "$REPO_DIR/configs/starship.toml" "$HOME/.config/starship.toml"
    fi

    # Скрипты
    mkdir -p "$HOME/.config/sway/scripts"
    cp -r "$REPO_DIR/scripts/"* "$HOME/.config/sway/scripts/"
    chmod +x "$HOME/.config/sway/scripts/"*
    
    log "success" "Конфигурации развернуты!"
}