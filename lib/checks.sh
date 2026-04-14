#!/usr/bin/env bash

# --- Атомарные функции проверки ---

# 1. Проверка пакета
_check_pkg() {
    if pacman -Qi "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# 2. Проверка конфига
_check_file() {
    if [ -e "$HOME/.config/$1" ]; then
        return 0
    else
        return 1
    fi
}

# 3. Проверка активного шелла
_check_shell() {
    if [[ "$SHELL" == "/usr/bin/fish" ]]; then
        return 0
    else
        return 1
    fi
}

# 4. Проверка ZRAM
_check_zram() {
    if zramctl | grep -q "zram0"; then
        return 0
    else
        return 1
    fi
}

# --- Основные функции вызова ---

# Функция для индивидуальных проверок (можно вызвать из любого места)
# Пример использования: run_check "Пакет Sway" _check_pkg "sway"
run_check() {
    local label="$1"
    local func="$2"
    local arg="$3"

    echo -ne "  %-30s " "${CL_CYAN}$label...${RC}"
    
    if $func "$arg"; then
        echo -e "${CL_GREEN}[УСТАНОВЛЕНО]${RC}"
        return 0
    else
        echo -e "${CL_RED}[ОТСУТСТВУЕТ]${RC}"
        return 1
    fi
}

# Глобальная функция проверки всей системы
verify_system() {
    print_banner
    log "info" "Начинаю полную проверку окружения..."
    echo "--------------------------------------------------"
    
    local errors=0

    # Проверка ключевых пакетов
    echo -e "${BOLD}Компоненты системы:${RC}"
    run_check "Sway WM" _check_pkg "sway" || ((errors++))
    run_check "Waybar" _check_pkg "waybar" || ((errors++))
    run_check "Терминал Foot" _check_pkg "foot" || ((errors++))
    run_check "Шелл Fish" _check_pkg "fish" || ((errors++))
    
    echo -e "\n${BOLD}Конфигурация:${RC}"
    run_check "Конфиг Sway" _check_file "sway/config" || ((errors++))
    run_check "Конфиг Waybar" _check_file "waybar/config" || ((errors++))
    run_check "Тема Starship" _check_file "starship.toml" || ((errors++))
    
    echo -e "\n${BOLD}Окружение:${RC}"
    run_check "Дефолтный шелл Fish" _check_shell || ((errors++))
    run_check "Модуль ZRAM" _check_zram || ((errors++))

    echo "--------------------------------------------------"
    if [ $errors -eq 0 ]; then
        log "success" "Все компоненты настроены верно! Система готова к работе."
    else
        log "warn" "Найдено проблем: $errors. Рекомендуется запустить полную установку (пункт 1)."
    fi
    
    echo -ne "\nНажмите любую клавишу, чтобы вернуться в меню..."
    read -n 1
}