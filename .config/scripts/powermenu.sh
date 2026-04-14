#!/usr/bin/env bash

op=$(echo -e " Завершение\n Перезагрузка\n Сон\n󰍃 Выход\n Блокировка" | wofi -d -p "System" --location 0 --width 300 --height 280)

case $op in
    *Завершение) systemctl poweroff ;;
    *Перезагрузка) systemctl reboot ;;
    *Сон) systemctl suspend ;;
    *Выход) swaymsg exit ;;
    *Блокировка) swaylock ;;
esac