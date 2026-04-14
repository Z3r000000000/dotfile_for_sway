#!/usr/bin/env bash

WALL_DIR="$HOME/Pictures/Wallpapers"

# Проверка: если папка пуста или не существует
if [ ! -d "$WALL_DIR" ] || [ -z "$(ls -A "$WALL_DIR")" ]; then
    swaybg -c "#1a1b26" & # Просто заливка если обоев нет
    exit 0
fi

# Выбираем случайный файл (jpg, png, webp)
RANDOM_WALL=$(find "$WALL_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \) | shuf -n 1)

# Убиваем старый процесс и ставим новые обои
killall swaybg 2>/dev/null
swaybg -i "$RANDOM_WALL" -m fill &