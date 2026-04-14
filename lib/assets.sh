#!/usr/bin/env bash
sync_assets() {
    local wall_dir="$HOME/Pictures/Wallpapers"
    if [ -d "$wall_dir/.git" ]; then
        run_cmd "Обновление обоев" "cd $wall_dir && git pull"
    else
        run_cmd "Загрузка обоев" "git clone --depth 1 https://github.com/dhrruvsharma/wallpapers.git $wall_dir"
    fi
}