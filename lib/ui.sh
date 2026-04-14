#!/usr/bin/env bash

# Цвета Tokyo Night
export CL_BLUE='\033[0;34m'; export CL_CYAN='\033[0;36m'; export CL_GREEN='\033[0;32m'
export CL_RED='\033[0;31m'; export CL_MAGENTA='\033[0;35m'; export CL_YELLOW='\033[1;33m'
export BOLD='\033[1m'; export RC='\033[0m'

log() {
    local level="$1"
    local msg="$2"
    case "$level" in
        "info")    echo -e "[${CL_BLUE}ℹ${RC}] $msg" ;;
        "success") echo -e "[${CL_GREEN}✔${RC}] $msg" ;;
        "error")   echo -e "[${CL_RED}✘${RC}] $msg" ; echo "[ERROR] $msg" >> "$LOG_FILE" ; exit 1 ;;
        "warn")    echo -e "[${CL_YELLOW}⚠${RC}] $msg" ;;
    esac
    echo "[$(date +'%H:%M:%S')] [$level] $msg" >> "$LOG_FILE"
}

# Функция для запуска команд с перенаправлением вывода в лог
run_cmd() {
    local msg="$1"
    local cmd="$2"
    log "info" "$msg..."
    if eval "$cmd" >> "$LOG_FILE" 2>&1; then
        return 0
    else
        log "warn" "Ошибка при: $msg. Проверьте install.log"
        return 1
    fi
}

print_banner() {
    clear
    echo -e "${CL_MAGENTA}${BOLD}🌌 TOKYO NIGHT SWAY : ARCH INSTALLER${RC}"
    echo -e "${CL_BLUE}---------------------------------------${RC}\n"
}