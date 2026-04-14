#!/usr/bin/env bash

create_backup() {
    local bdir="$HOME/backups/$(date +%Y-%m-%d_%H-%M-%S)"
    log "INFO" "Бэкап в $bdir"
    mkdir -p "$bdir"
    for f in sway waybar wofi mako foot wlogout fish starship.toml; do
        [ -e "$HOME/.config/$f" ] && cp -r "$HOME/.config/$f" "$bdir/"
    done
}

deploy() {
    log "INFO" "Деплой конфигураций..."
    mkdir -p "$HOME/.config"
    cp -r "$REPO_DIR/configs/"* "$HOME/.config/"
    [ -d "$REPO_DIR/scripts" ] && {
        mkdir -p "$HOME/.config/sway/scripts"
        cp -r "$REPO_DIR/scripts/"* "$HOME/.config/sway/scripts/"
        chmod +x "$HOME/.config/sway/scripts/"*
    }
    pgrep -x sway > /dev/null && swaymsg reload
    log "SUCCESS" "Конфиги обновлены."
}