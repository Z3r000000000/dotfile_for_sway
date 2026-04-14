#!/usr/bin/env bash

# =============================================================================
# TOKYO NIGHT SWAY: Ультимативный установщик и менеджер системы
# Оптимизировано для Intel Gemini Lake & Wayland
# =============================================================================

# --- КОНФИГУРАЦИЯ ---
LOG_FILE="manage_$(date +%F_%T).log"
BACKUP_BASE="$HOME/backups/dotfiles"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
CURRENT_BACKUP="$BACKUP_BASE/$TIMESTAMP"
REPO_DIR=$(pwd)

# Цвета для вывода
RC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'

# --- СЛУЖЕБНЫЕ ФУНКЦИИ ---

log() {
    local level="$1"
    local msg="$2"
    echo -e "$(date +'%H:%M:%S') [$level] : $msg" >> "$LOG_FILE"
    case "$level" in
        "INFO")    echo -e "${BLUE}[INFO]${RC} $msg" ;;
        "SUCCESS") echo -e "${GREEN}[OK]${RC} $msg" ;;
        "WARN")    echo -e "${YELLOW}[WARN]${RC} $msg" ;;
        "ERROR")   echo -e "${RED}[ERROR]${RC} $msg" ;;
    esac
}

check_requirements() {
    log "INFO" "Проверка системных требований..."
    if ! ping -c 1 google.com &>/dev/null; then
        log "ERROR" "Нет интернет-соединения. Проверьте сеть."
        exit 1
    fi
    if [[ $EUID -eq 0 ]]; then
        log "ERROR" "Не запускайте скрипт от root. Используйте sudo."
        exit 1
    fi
}

# --- ЖЕЛЕЗО И ПАКЕТЫ ---

detect_hardware() {
    log "INFO" "Детекция оборудования..."
    # Процессор
    if grep -q "Intel" /proc/cpuinfo; then
        UCODE="intel-ucode"
        log "INFO" "Выбран микрокод: Intel"
    elif grep -q "AMD" /proc/cpuinfo; then
        UCODE="amd-ucode"
        log "INFO" "Выбран микрокод: AMD"
    fi

    # Видеокарта (UHD 600 / Intel GPU)
    if lspci | grep -iq "intel"; then
        GPU_DRIVERS="mesa vulkan-intel intel-media-driver libva-intel-driver"
        log "INFO" "Выбраны драйверы Intel (iHD) с аппаратным ускорением."
    elif lspci | grep -iq "amd"; then
        GPU_DRIVERS="mesa vulkan-radeon libva-mesa-driver"
        log "INFO" "Выбраны драйверы AMD."
    fi
}

install_aur_helper() {
    if ! command -v yay &> /dev/null; then
        log "INFO" "Установка yay (AUR хелпер)..."
        sudo pacman -S --needed --noconfirm git base-devel >> "$LOG_FILE" 2>&1
        git clone https://aur.archlinux.org/yay-git.git /tmp/yay >> "$LOG_FILE" 2>&1
        (cd /tmp/yay && makepkg -si --noconfirm) >> "$LOG_FILE" 2>&1
        rm -rf /tmp/yay
    else
        log "SUCCESS" "yay уже установлен."
    fi
}

# --- GIT И ОБНОВЛЕНИЯ ---

check_for_updates() {
    log "INFO" "Синхронизация с GitHub..."
    git fetch origin >> "$LOG_FILE" 2>&1
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})

    if [ "$LOCAL" != "$REMOTE" ]; then
        echo -e "${YELLOW}[!] Обнаружена новая версия на GitHub!${RC}"
        read -p "Обновить локальный репозиторий перед работой? (y/n): " up_choice
        if [[ "$up_choice" == "y" ]]; then
            git pull origin $(git branch --show-current) >> "$LOG_FILE" 2>&1
            log "SUCCESS" "Репозиторий обновлен. Перезапустите скрипт."
            exit 0
        fi
    else
        log "SUCCESS" "Локальная версия актуальна."
    fi
}

# --- БЭКАПЫ ---

create_backup() {
    log "INFO" "Архивация текущей конфигурации в $CURRENT_BACKUP..."
    mkdir -p "$CURRENT_BACKUP"
    local configs=("sway" "waybar" "wofi" "mako" "foot" "wlogout")
    
    for c in "${configs[@]}"; do
        if [ -d "$HOME/.config/$c" ]; then
            cp -r "$HOME/.config/$c" "$CURRENT_BACKUP/"
            log "INFO" "Бэкап $c готов."
        fi
    done
    log "SUCCESS" "Все старые конфиги сохранены."
}

# --- ОСНОВНЫЕ ОПЕРАЦИИ ---

deploy_configs() {
    log "INFO" "Развертывание новых конфигураций..."
    mkdir -p "$HOME/.config"
    
    # Копируем папки конфигов
    if [ -d "$REPO_DIR/configs" ]; then
        cp -r "$REPO_DIR/configs/"* "$HOME/.config/"
    fi

    # Настройка скриптов
    mkdir -p "$HOME/.config/sway/scripts"
    if [ -d "$REPO_DIR/scripts" ]; then
        cp -r "$REPO_DIR/scripts/"* "$HOME/.config/sway/scripts/"
        chmod +x "$HOME/.config/sway/scripts/"*
    fi
    log "SUCCESS" "Конфигурация успешно развернута."
}

setup_system() {
    log "INFO" "Оптимизация системы..."
    # ZRAM
    sudo pacman -S --noconfirm zram-generator >> "$LOG_FILE" 2>&1
    sudo bash -c 'cat <<EOF > /etc/systemd/zram-generator.conf
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
EOF'
    sudo systemctl daemon-reload
    sudo systemctl start /dev/zram0

    # Глобальные переменные Wayland
    sudo bash -c 'cat <<EOF > /etc/environment
QT_QPA_PLATFORM=wayland
XDG_CURRENT_DESKTOP=sway
XDG_SESSION_TYPE=wayland
MOZ_ENABLE_WAYLAND=1
LIBVA_DRIVER_NAME=iHD
EOF'
    log "SUCCESS" "ZRAM и переменные окружения настроены."
}

# --- РЕЖИМЫ РАБОТЫ ---

full_install() {
    log "INFO" "Начало полной установки среды..."
    check_requirements
    detect_hardware
    
    log "INFO" "Обновление системы..."
    sudo pacman -Syu --noconfirm >> "$LOG_FILE" 2>&1
    
    local pkgs=(
        sway swaybg swayidle waybar wofi mako foot wlogout
        brightnessctl pamixer playerctl grim slurp wl-clipboard
        pavucontrol network-manager-applet thunar gvfs polkit-gnome
        ttf-jetbrains-mono-nerd ttf-font-awesome adobe-source-code-pro-fonts
        papirus-icon-theme reflector
    )
    
    sudo pacman -S --needed --noconfirm "$UCODE" $GPU_DRIVERS "${pkgs[@]}" >> "$LOG_FILE" 2>&1
    
    install_aur_helper
    log "INFO" "Установка swaylock-effects из AUR..."
    yay -S --noconfirm swaylock-effects-git >> "$LOG_FILE" 2>&1
    
    setup_system
    deploy_configs
    log "SUCCESS" "ПОЛНАЯ УСТАНОВКА ЗАВЕРШЕНА!"
}

reset_stable() {
    echo -e "${RED}[!] ПРЕДУПРЕЖДЕНИЕ: Все локальные изменения в репозитории будут стерты!${RC}"
    read -p "Сбросить проект к стабильной версии GitHub? (y/n): " confirm
    if [[ "$confirm" == "y" ]]; then
        create_backup
        log "WARN" "Сброс репозитория к origin/master..."
        git reset --hard origin/$(git branch --show-current) >> "$LOG_FILE" 2>&1
        git clean -fd >> "$LOG_FILE" 2>&1
        deploy_configs
        log "SUCCESS" "Система возвращена к стабильному состоянию."
    fi
}

# --- ИНТЕРФЕЙС ---

show_menu() {
    clear
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RC}"
    echo -e "  ${BLUE}TOKYO NIGHT SWAY${RC} : Система управления дотфайлами"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RC}"
    
    check_for_updates

    echo -e "\nВыберите действие:"
    echo -e "${GREEN}1)${RC} Полноценная установка (База + Драйверы + Конфиги)"
    echo -e "${YELLOW}2)${RC} Возврат к стабильной версии (Сброс + Бэкап)"
    echo -e "${BLUE}3)${RC} Обновить только конфиги (Deploy)"
    echo -e "${RED}4)${RC} Выход"
    echo -e ""
    read -p "Введите номер [1-4]: " choice

    case $choice in
        1) full_install ;;
        2) reset_stable ;;
        3) create_backup && deploy_configs ;;
        4) exit 0 ;;
        *) log "ERROR" "Неверный ввод."; sleep 2; show_menu ;;
    esac
}

# Старт
show_menu