#!/usr/bin/env bash

sync_assets() {
    local wall_repo="https://github.com/dhrruvsharma/wallpapers.git"
    local wall_dir="$HOME/Pictures/Wallpapers"

    log "INFO" "Синхронизация обоев с GitHub..."
    if [ -d "$wall_dir/.git" ]; then
        cd "$wall_dir" && git pull && cd "$REPO_DIR"
    else
        mkdir -p "$wall_dir"
        git clone --depth 1 "$wall_repo" "$wall_dir"
    fi
    log "SUCCESS" "Обои обновлены в $wall_dir"
}

deploy_configs() {
    log "INFO" "Деплой конфигураций..."
    mkdir -p ~/.config
    cp -r "$REPO_DIR/configs/"* ~/.config/
    [ -d "$REPO_DIR/scripts" ] && {
        mkdir -p ~/.config/sway/scripts
        cp -r "$REPO_DIR/scripts/"* ~/.config/sway/scripts/
        chmod +x ~/.config/sway/scripts/*.sh
    }
    log "SUCCESS" "Конфигурация развернута."
}