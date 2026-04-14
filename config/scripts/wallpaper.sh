#!/usr/bin/env bash

WALL_DIR="$HOME/Pictures/Wallpapers"
# Цвета Tokyo Night для градиента/фона
COLORS=("#1a1b26" "#24283b" "#7aa2f7" "#bb9af7")
RANDOM_COLOR=${COLORS[$RANDOM % ${#COLORS[@]}]}

killall swaybg > /dev/null 2>&1

if [ -d "$WALL_DIR" ] && [ "$(ls -A "$WALL_DIR")" ]; then
    # Если папка есть и не пуста — берем рандомное фото
    WALLPAPER=$(find "$WALL_DIR" -type f | shuf -n 1)
    swaybg -i "$WALLPAPER" -m fill &
else
    # Если папки нет — ставим глубокий цвет темы
    # (swaybg не умеет в градиент, поэтому ставим солидный фон)
    swaybg -c "$RANDOM_COLOR" &
fi