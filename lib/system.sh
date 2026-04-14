#!/usr/bin/env bash

REPO_PKGS=(sway waybar foot wofi mako swaylock git base-devel fish starship brightnessctl pamixer libnotify wl-clipboard ttf-jetbrains-mono-nerd ttf-font-awesome)
AUR_PKGS=(wlogout)

detect_hardware() {
    log "info" "Определение оборудования..."
    if grep -q "Intel" /proc/cpuinfo; then
        UCODE="intel-ucode"
        GPU_DRV="mesa vulkan-intel intel-media-driver libva-intel-driver"
        log "info" "Оптимизация под Intel включена."
    else
        UCODE="amd-ucode"
        GPU_DRV="mesa lib32-mesa xf86-video-amdgpu"
    fi
}

install_packages() {
    log "info" "Обновление баз данных..."
    sudo pacman -Sy --noconfirm

    log "info" "Установка официальных пакетов..."
    sudo pacman -S --needed --noconfirm "${REPO_PKGS[@]}" $UCODE $GPU_DRV

    install_aur_helper
    for pkg in "${AUR_PKGS[@]}"; do
        run_cmd "Установка AUR пакета $pkg" "yay -S --noconfirm $pkg"
    done
}

install_aur_helper() {
    if ! command -v yay &> /dev/null; then
        log "info" "Установка yay (AUR помощник)..."
        run_cmd "Клонирование yay" "git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin"
        run_cmd "Сборка yay" "cd /tmp/yay-bin && makepkg -si --noconfirm"
    fi
}

setup_zram() {
    run_cmd "Настройка ZRAM" "sudo pacman -S --needed --noconfirm zram-generator && \
    sudo bash -c 'echo -e \"[zram0]\nzram-size = ram / 2\ncompression-algorithm = zstd\" > /etc/systemd/zram-generator.conf' && \
    sudo systemctl daemon-reload && sudo systemctl start /dev/zram0"
}