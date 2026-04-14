#!/usr/bin/env bash
export CL_BLUE='\033[0;34m'; export CL_CYAN='\033[0;36m'; export CL_GREEN='\033[0;32m'
export CL_RED='\033[0;31m'; export CL_MAGENTA='\033[0;35m'; export BOLD='\033[1m'; export RC='\033[0m'

log() {
    local level="$1"; local msg="$2"
    case "$level" in
        "info")    echo -e "[${CL_BLUE}ℹ${RC}] ${CL_CYAN}$msg${RC}" ;;
        "success") echo -e "[${CL_GREEN}✔${RC}] ${CL_GREEN}$msg${RC}" ;;
        "error")   echo -e "[${CL_RED}✘${RC}] ${CL_RED}$msg${RC}"; exit 1 ;;
        "warn")    echo -e "[${CL_YELLOW}⚠${RC}] ${CL_YELLOW}$msg${RC}" ;;
    esac
}

print_banner() {
    clear
    echo -e "${CL_MAGENTA}${BOLD}🌌 TOKYO NIGHT SWAY INSTALLER${RC}"
    echo -e "${CL_BLUE}---------------------------------------${RC}"
}