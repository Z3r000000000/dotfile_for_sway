#!/usr/bin/env bash

detect_hw() {
    log "INFO" "Анализ оборудования..."
    # Процессор
    grep -q "Intel" /proc/cpuinfo && UCODE="intel-ucode" || UCODE="amd-ucode"
    
    # Видеокарта
    if lspci | grep -iq "intel"; then
        GPU_DRV="mesa vulkan-intel intel-media-driver libva-intel-driver"
        log "INFO" "Оптимизация под Intel (iHD) включена."
    fi
}

setup_zram() {
    log "INFO" "Настройка ZRAM..."
    sudo pacman -S --noconfirm zram-generator >> /dev/null 2>&1
    sudo bash -c 'cat <<EOF > /etc/systemd/zram-generator.conf
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
EOF'
    sudo systemctl daemon-reload && sudo systemctl start /dev/zram0
}