#!/usr/bin/env bash

# Путь к репозиторию и логам
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$REPO_DIR/install.log"

# Подгружаем модули
for module in "$REPO_DIR/lib/"*.sh; do
    source "$module"
done

# Функция полной установки
full_install() {
    detect_hw
    log "INFO" "Обновление системы..."
    sudo pacman -Syu --noconfirm
    
    # Список всех пакетов
    local all_pkgs=("${CORE_PKGS[@]}" "$UCODE" $GPU_DRV "ttf-jetbrains-mono-nerd" "papirus-icon-theme" "polkit-gnome")
    sudo pacman -S --needed --noconfirm "${all_pkgs[@]}"
    
    setup_zram
    setup_term
    deploy
    log "SUCCESS" "УСТАНОВКА ЗАВЕРШЕНА!"
}

# Главное меню
show_menu() {
    clear
    echo -e "${CYAN}${BOLD}🌌 TOKYO NIGHT SWAY MANAGER${RC}"
    check_system # Самодиагностика при старте

    echo -e "\n${BOLD}МЕНЮ:${RC}"
    echo -e "  ${GREEN}1)${RC} Полная установка"
    echo -e "  ${CYAN}2)${RC} Тюнинг терминала"
    echo -e "  ${YELLOW}3)${RC} Восстановить конфиги (Бэкап + Деплой)"
    echo -e "  ${RED}4)${RC} Выход"
    
    read -p "  >> " choice
    case $choice in
        1) full_install ;;
        2) setup_term ;;
        3) create_backup && deploy ;;
        4) exit 0 ;;
        *) show_menu ;;
    esac
}

show_menu