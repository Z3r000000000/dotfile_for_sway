sync_assets() {
    # Обои
    fetch_resource "https://github.com/dhrruvsharma/wallpapers.git" "$HOME/Pictures/Wallpapers" "Обои"
    
    # SDDM Тема (Tokyo Night)
    sudo mkdir -p /usr/share/sddm/themes
    fetch_resource "https://github.com/sukkisukki/sddm-tokyo-night.git" "/tmp/sddm-theme" "Тема входа"
    sudo cp -r /tmp/sddm-theme /usr/share/sddm/themes/tokyo-night
    
    # Установка темы как дефолтной
    sudo bash -c 'cat <<EOF > /etc/sddm.conf
[Theme]
Current=tokyo-night
EOF'
}