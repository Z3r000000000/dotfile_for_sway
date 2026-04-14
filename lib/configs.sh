#!/usr/bin/env bash

deploy_specific() {
    local target=$1 # Имя папки в configs/
    local name=$2   # Красивое имя для лога
    local backup_dir="$HOME/.config_backups/partial_$(date +%Y%m%d_%H%M%S)"

    log "info" "Обновление: $name"

    # Бэкап
    if [ -e "$HOME/.config/$target" ]; then
        mkdir -p "$backup_dir"
        mv "$HOME/.config/$target" "$backup_dir/"
    fi

    # Копирование
    mkdir -p "$HOME/.config/$target"
    if [ -d "$REPO_DIR/configs/$target" ]; then
        cp -r "$REPO_DIR/configs/$target/." "$HOME/.config/$target/"
    elif [ -f "$REPO_DIR/configs/$target" ]; then
        cp "$REPO_DIR/configs/$target" "$HOME/.config/$target"
    fi

    # Если обновляем sway, копируем и скрипты
    if [ "$target" == "sway" ]; then
        mkdir -p "$HOME/.config/sway/scripts"
        cp -r "$REPO_DIR/scripts/"* "$HOME/.config/sway/scripts/"
        chmod +x "$HOME/.config/sway/scripts/"*
    fi

    log "success" "$name обновлен."
}

deploy_configs() {
    log "info" "Полный деплой всех конфигураций..."
    local folders=("sway" "waybar" "foot" "mako" "wofi" "wlogout" "fish")
    for f in "${folders[@]}"; do
        deploy_specific "$f" "$f"
    done
    deploy_specific "starship.toml" "Starship"
}