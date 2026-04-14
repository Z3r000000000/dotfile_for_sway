#!/usr/bin/env bash
set -e # Остановить при ошибке

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Подгружаем модули
source "$REPO_DIR/lib/ui.sh"
source "$REPO_DIR/lib/system.sh"
source "$REPO_DIR/lib/configs.sh"
source "$REPO_DIR/lib/terminal.sh"
source "$REPO_DIR/lib/assets.sh"

print_banner

if [ "$EUID" -eq 0 ]; then
    log "error" "Не запускайте скрипт через SUDO (запускайте просто ./install.sh)"
fi

echo -e "1) Полная установка\n2) Только обновить конфиги\n3) Выход"
read -p ">> " choice

case $choice in
    1)
        detect_and_install
        setup_terminal
        sync_assets # Твоя функция скачивания обоев
        deploy_configs
        log "success" "Готово! Перезагрузите ПК."
        ;;
    2)
        deploy_configs
        log "success" "Конфиги обновлены."
        ;;
    *)
        exit 0
        ;;
esac