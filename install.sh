#!/usr/bin/env bash

# Остановка при критических ошибках
set -e

# Определение путей
export REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LIB_DIR="$REPO_DIR/lib"
export LOG_FILE="$REPO_DIR/install.log"

# Подгрузка модулей
for module in "$LIB_DIR/"*.sh; do source "$module"; done

# Инициализация лога
echo "--- ЗАПУСК УСТАНОВКИ: $(date) ---" > "$LOG_FILE"

print_banner

# Проверка на root
if [ "$EUID" -eq 0 ]; then
    log "error" "Не запускайте скрипт через sudo. Он сам запросит пароль."
fi

echo -e "${BOLD}Выберите режим:${RC}"
echo -e "  ${CL_GREEN}1)${RC} Полноценная установка (Система + Пакеты + Конфиги)"
echo -e "  ${CL_CYAN}2)${RC} Обновить только конфигурации и обои"
echo -e "  ${CL_YELLOW}3)${RC} Проверить состояние системы (Health Check)"
echo -e "  ${CL_RED}4)${RC} Выход"
read -p ">> " choice

case $choice in
    1)
        log "info" "Начинаю полную установку..."
        detect_hardware
        install_packages
        setup_zram
        setup_terminal
        sync_assets
        deploy_configs
        verify_system
        log "success" "Установка завершена! Перезагрузите систему."
        ;;
    2)
        deploy_configs
        sync_assets
        log "success" "Конфигурации обновлены."
        ;;
    3)
        verify_system
        ;;
    4)
        exit 0
        ;;
    *)
        log "warn" "Неверный выбор."
        ;;
esac