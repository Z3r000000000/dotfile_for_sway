#!/usr/bin/env bash
set -e

export REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LIB_DIR="$REPO_DIR/lib"
export LOG_FILE="$REPO_DIR/install.log"

for module in "$LIB_DIR/"*.sh; do source "$module"; done

# Функция подменю для выборочного обновления
config_submenu() {
    while true; do
        print_banner
        echo -e "${BOLD}ВЫБОРОЧНОЕ ОБНОВЛЕНИЕ КОНФИГУРАЦИЙ:${RC}"
        echo -e "  ${CL_CYAN}1)${RC} Обновить Sway (WM + Скрипты)"
        echo -e "  ${CL_CYAN}2)${RC} Обновить Waybar (Панель + Стили)"
        echo -e "  ${CL_CYAN}3)${RC} Обновить Foot (Терминал + Шрифты)"
        echo -e "  ${CL_CYAN}4)${RC} Обновить Wofi & Wlogout (Меню)"
        echo -e "  ${CL_CYAN}5)${RC} Обновить Fish (Shell)"
        echo -e "  ${CL_MAGENTA}6)${RC} Обновить ВСЕ конфиги сразу"
        echo -e "  ${CL_RED}7)${RC} Назад"
        read -p ">> " subchoice

        case $subchoice in
            1) deploy_specific "sway" "Sway WM" ;;
            2) deploy_specific "waybar" "Waybar" ;;
            3) deploy_specific "foot" "Foot Terminal" ;;
            4) deploy_specific "wofi" "Wofi"; deploy_specific "wlogout" "Wlogout" ;;
            5) deploy_specific "fish" "Fish Shell" ;;
            6) deploy_configs ;;
            7) break ;;
            *) log "warn" "Неверный выбор" ; sleep 1 ;;
        esac
        echo -e "\nНажмите Enter..." ; read
    done
}

# Главный цикл
while true; do
    print_banner
    echo -e "${BOLD}ГЛАВНОЕ МЕНЮ:${RC}"
    echo -e "  ${CL_GREEN}1)${RC} ${BOLD}ПОЛНАЯ УСТАНОВКА${RC} (System + Configs + Media)"
    echo -e "  ${CL_BLUE}2)${RC} [System] Пакеты и драйверы"
    echo -e "  ${CL_MAGENTA}3)${RC} [Configs] МЕНЮ ОБНОВЛЕНИЯ КОНФИГОВ"
    echo -e "  ${CL_CYAN}4)${RC} [Assets] Загрузка обоев"
    echo -e "  ${CL_YELLOW}5)${RC} [Check] Проверка системы"
    echo -e "  ${CL_RED}6)${RC} Выход"
    read -p ">> " choice

    case $choice in
        1) detect_hardware && install_packages && deploy_configs && sync_assets && verify_system ;;
        2) detect_hardware && install_packages ;;
        3) config_submenu ;;
        4) sync_assets ;;
        5) verify_system ;;
        6) exit 0 ;;
        *) log "warn" "Неверный выбор" ; sleep 1 ;;
    esac
done