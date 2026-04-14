#!/usr/bin/env bash
detect_and_install() {
    log "info" "Обновление системы..."
    sudo pacman -Syu --noconfirm

    local pkgs=(sway waybar foot wofi mako swaylock wlogout git base-devel 
                fish starship brightnessctl pamixer libnotify wl-clipboard
                ttf-jetbrains-mono-nerd ttf-font-awesome adobe-source-code-pro-fonts)

    # Оптимизация под Intel (твоя модель J4105)
    if grep -q "Intel" /proc/cpuinfo; then
        log "info" "Настройка драйверов Intel..."
        pkgs+=("intel-ucode" "mesa" "vulkan-intel" "intel-media-driver" "libva-intel-driver")
    fi

    sudo pacman -S --needed --noconfirm "${pkgs[@]}"
    
    # Настройка ZRAM
    log "info" "Включение ZRAM..."
    sudo pacman -S --needed --noconfirm zram-generator
    sudo bash -c 'echo -e "[zram0]\nzram-size = ram / 2\ncompression-algorithm = zstd" > /etc/systemd/zram-generator.conf'
    sudo systemctl daemon-reload && sudo systemctl start /dev/zram0
}