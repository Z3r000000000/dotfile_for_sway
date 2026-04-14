#!/usr/bin/env bash
setup_terminal() {
    log "info" "Настройка Fish..."
    # Установка Fish как дефолтного шелла
    [ "$SHELL" != "/usr/bin/fish" ] && chsh -s /usr/bin/fish
}