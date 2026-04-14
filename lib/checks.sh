#!/usr/bin/env bash

_check_pkg() { pacman -Qi "$1" &> /dev/null; }
_check_file() { [ -e "$HOME/.config/$1" ]; }

run_check() {
    local label="$1"; local func="$2"; local arg="$3"
    printf "  %-30s " "${CL_CYAN}$label...${RC}"
    if $func "$arg"; then
        echo -e "${CL_GREEN}[OK]${RC}"
    else
        echo -e "${CL_RED}[MISSING]${RC}"
    fi
}

verify_system() {
    echo -e "\n${BOLD}🔍 ДИАГНОСТИКА СИСТЕМЫ:${RC}"
    run_check "Sway" _check_pkg "sway"
    run_check "Waybar" _check_pkg "waybar"
    run_check "wlogout (AUR)" _check_pkg "wlogout"
    run_check "Fish Shell" _check_pkg "fish"
    run_check "Конфиг Sway" _check_file "sway/config"
    run_check "Конфиг Starship" _check_file "starship.toml"
    echo -e "---------------------------------------\n"
}