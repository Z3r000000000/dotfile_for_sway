#!/usr/bin/env bash

# Путь к папке с обоями (поменяй под себя)
WALL_DIR="$HOME/Pictures/Wallpapers"

# Проверяем, существует ли папка
if [ ! -d "$WALL_DIR" ]; then
    mkdir -p "$WALL_DIR"
    # Если папки нет, скачиваем одну дефолтную картинку (опционально)
    wget https://raw.githubusercontent.com/archcraft-os/archcraft-wallpaper/main/files/wallpaper_1.jpg -O "$WALL_DIR/default.jpg"
fi

# Выбираем случайный файл
WALLPAPER=$(find "$WALL_DIR" -type f | shuf -n 1)

# Убиваем старый процесс swaybg и запускаем новый
killall swaybg > /dev/null 2>&1
swaybg -i "$WALLPAPER" -m fill &