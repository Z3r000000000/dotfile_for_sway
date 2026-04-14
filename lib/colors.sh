#!/usr/bin/env bash

RC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'

CHECK_MARK="${GREEN}✔${RC}"
ERROR_MARK="${RED}✘${RC}"

log() {
    local level="$1"
    local msg="$2"
    echo -e "$(date +'%H:%M:%S') [$level] : $msg" >> "$LOG_FILE"
    case "$level" in
        "INFO")    echo -e "${BLUE}[INFO]${RC} $msg" ;;
        "SUCCESS") echo -e "${GREEN}[OK]${RC} $msg" ;;
        "WARN")    echo -e "${YELLOW}[WARN]${RC} $msg" ;;
        "ERROR")   echo -e "${RED}[ERROR]${RC} $msg" ;;
    esac
}