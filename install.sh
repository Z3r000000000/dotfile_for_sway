#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Подгружаем модули (не забудь добавить checks.sh!)
source "$REPO_DIR/lib/ui.sh"
source "$REPO_DIR/lib/system.sh"
source "$REPO_DIR/lib/configs.sh"
source "$REPO_DIR/lib/terminal.sh"
source "$REPO_DIR/lib/assets.sh"
source "$REPO_DIR/lib/checks.sh" # <--- Добавили новый модуль

print_banner

# ... (проверка на root) ...

echo -e "1) ${CL_GREEN}Полная установка${RC}"
echo -e "2) ${CL_CYAN}Обновить только конфиги${RC}"
echo -e "3) ${CL_YELLOW}Проверить статус системы (Health Check)${RC}"
echo -e "4) ${CL_RED}Выход${RC}"
read -p ">> " choice

case $choice in
    1)
        detect_and_install
        setup_terminal
        sync_assets
        deploy_configs
        verify_system # Запуск проверки сразу после установки
        ;;
    2)
        deploy_configs
        log "success" "Конфиги обновлены."
        ;;
    3)
        verify_system # Просто проверка
        exec "$0" # Перезапуск скрипта, чтобы вернуться в меню после проверки
        ;;
    *)
        exit 0
        ;;
esac