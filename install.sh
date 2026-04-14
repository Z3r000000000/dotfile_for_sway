#!/usr/bin/env bash

# --- КОНФИГУРАЦИЯ И ЛОГИ ---
LOG_FILE="install_$(date +%F_%T).log"
REPO_DIR=$(pwd)
USER_HOME=$(eval echo "~$USER")

# Цвета для терминала
RC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'

# Функция логирования
log() {
    local level="$1"
    local msg="$2"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "${timestamp} [${level}] : ${msg}" >> "$LOG_FILE"
    
    case "$level" in
        "INFO")    echo -e "${BLUE}[INFO]${RC} $msg" ;;
        "SUCCESS") echo -e "${GREEN}[OK]${RC} $msg" ;;
        "WARN")    echo -e "${YELLOW}[WARN]${RC} $msg" ;;
        "ERROR")   echo -e "${RED}[ERROR]${RC} $msg" ;;
    esac
}

# --- ПРОВЕРКИ ---
check_requirements() {
    log "INFO" "Запуск предварительных проверок..."
    
    # Проверка интернета
    if ! ping -c 1 google.com &>/dev/null; then
        log "ERROR" "Нет подключения к интернету!"
        exit 1
    fi
    
    # Проверка прав (не запускать от root напрямую)
    if [[ $EUID -eq 0 ]]; then
        log "ERROR" "Не запускайте скрипт от имени root. Используйте обычного пользователя с sudo."
        exit 1
    fi
    
    # Проверка свободного места (нужно хотя бы 5ГБ)
    local free_space=$(df -m / | awk 'NR==2 {print $4}')
    if [[ $free_space -lt 5000 ]]; then
        log "WARN" "Мало места на диске ($free_space MB). Установка может быть прервана."
    fi
}

# --- ДЕТЕКЦИЯ ЖЕЛЕЗА ---
detect_hardware() {
    log "INFO" "Анализ оборудования..."
    
    # Процессор
    if grep -q "Intel" /proc/cpuinfo; then
        UCODE="intel-ucode"
        log "INFO" "Процессор Intel определен."
    elif grep -q "AMD" /proc/cpuinfo; then
        UCODE="amd-ucode"
        log "INFO" "Процессор AMD определен."
    fi

    # Видеокарта
    if lspci | grep -iq "intel"; then
        # Для GeminiLake (UHD 600) нужны эти драйверы
        GPU_DRIVERS="mesa vulkan-intel intel-media-driver libva-intel-driver"
        log "INFO" "GPU Intel (GeminiLake) определен. Выбраны медиа-драйверы для ускорения."
    fi
}

# --- УСТАНОВКА ПАКЕТОВ ---
install_packages() {
    log "INFO" "Обновление баз данных pacman..."
    sudo pacman -S --noconfirm reflector >> "$LOG_FILE" 2>&1
    sudo reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist >> "$LOG_FILE" 2>&1
    sudo pacman -Syu --noconfirm >> "$LOG_FILE" 2>&1

    log "INFO" "Установка основных пакетов..."
    local pkgs=(
        # База Sway
        sway swaybg swayidle waybar wofi mako foot
        # Утилиты
        brightnessctl pamixer playerctl grim slurp wl-clipboard
        pavucontrol network-manager-applet thunar gvfs polkit-gnome
        # Визуал
        wlogout ttf-jetbrains-mono-nerd ttf-font-awesome papirus-icon-theme
        # Система
        zram-generator git base-devel
    )
    
    sudo pacman -S --needed --noconfirm "$UCODE" $GPU_DRIVERS "${pkgs[@]}" >> "$LOG_FILE" 2>&1
    
    # Установка AUR хелпера (yay)
    if ! command -v yay &> /dev/null; then
        log "INFO" "Установка yay (AUR хелпер)..."
        git clone https://aur.archlinux.org/yay-git.git /tmp/yay >> "$LOG_FILE" 2>&1
        cd /tmp/yay && makepkg -si --noconfirm >> "$REPO_DIR/$LOG_FILE" 2>&1
        cd "$REPO_DIR"
    fi

    log "INFO" "Установка swaylock-effects из AUR..."
    yay -S --noconfirm swaylock-effects-git >> "$LOG_FILE" 2>&1
}

# --- КОНФИГУРАЦИЯ ---
setup_system() {
    log "INFO" "Настройка системных параметров..."

    # ZRAM для 6GB RAM
    sudo bash -c 'cat <<EOF > /etc/systemd/zram-generator.conf
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
EOF'
    sudo systemctl daemon-reload
    sudo systemctl start /dev/zram0
    log "SUCCESS" "ZRAM настроен и запущен."

    # Группы пользователя для управления яркостью и видео
    sudo usermod -aG video,input,audio "$USER"
    log "INFO" "Пользователь добавлен в группы video/input/audio."

    # Переменные окружения для Wayland
    sudo bash -c 'cat <<EOF > /etc/environment
QT_QPA_PLATFORM=wayland
_JAVA_AWT_WM_NONREPARENTING=1
XDG_CURRENT_DESKTOP=sway
XDG_SESSION_TYPE=wayland
EOF'
}

deploy_configs() {
    log "INFO" "Развертывание конфигурационных файлов..."
    mkdir -p "$USER_HOME/.config"
    
    if [ -d "$REPO_DIR/configs" ]; then
        cp -r "$REPO_DIR/configs/"* "$USER_HOME/.config/"
        log "SUCCESS" "Файлы конфигурации скопированы."
    else
        log "WARN" "Папка configs не найдена в репозитории!"
    fi

    # Скрипты
    if [ -d "$REPO_DIR/scripts" ]; then
        mkdir -p "$USER_HOME/.config/sway/scripts"
        cp -r "$REPO_DIR/scripts/"* "$USER_HOME/.config/sway/scripts/"
        chmod +x "$USER_HOME/.config/sway/scripts/"*
        log "SUCCESS" "Скрипты установлены и сделаны исполняемыми."
    fi
}

# --- ГЛАВНЫЙ ЦИКЛ ---
main() {
    clear
    echo -e "${CYAN}=== Sway Dotfiles Installer for GeminiLake ===${RC}"
    
    check_requirements
    detect_hardware
    install_packages
    setup_system
    deploy_configs
    
    echo -e "\n${GREEN}Установка успешно завершена!${RC}"
    echo -e "Лог установки: ${YELLOW}$LOG_FILE${RC}"
    echo -e "Теперь перезагрузите компьютер и введите 'sway'."
    
    read -p "Перезагрузить сейчас? (y/n) " resp
    if [[ "$resp" == "y" ]]; then
        sudo reboot
    fi
}

main