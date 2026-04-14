#!/usr/bin/env bash

CORE_PKGS=("sway" "waybar" "foot" "wofi" "mako" "swaylock" "wlogout" "brightnessctl" "pamixer" "starship" "fish")

check_system() {
    echo -e "\n${BOLD}🔎 Проверка компонентов:${RC}"
    MISSING_PKGS=()
    for pkg in "${CORE_PKGS[@]}"; do
        if command -v "$pkg" &> /dev/null; then
            echo -e "  $CHECK_MARK $pkg"
        else
            echo -e "  $ERROR_MARK $pkg ${RED}(отсутствует)${RC}"
            MISSING_PKGS+=("$pkg")
        fi
    done

    if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
        echo -e "\n${YELLOW}Нажмите [F] для исправления или любую клавишу для меню${RC}"
        read -n 1 -s key
        [[ $key == "f" || $key == "F" ]] && repair_system
    fi
}

repair_system() {
    log "INFO" "Установка недостающих: ${MISSING_PKGS[*]}"
    sudo pacman -S --needed --noconfirm "${MISSING_PKGS[@]}"
    log "SUCCESS" "Система восстановлена."
    sleep 1
}