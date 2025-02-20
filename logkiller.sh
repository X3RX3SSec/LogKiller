#!/bin/bash

# Define color codes
MAGENTA="\e[35m"
FLUO_GREEN="\e[92m"
RED="\e[31m"
RESET="\e[0m"

# Log Killer Banner
echo -e "${MAGENTA}"
cat << "EOF"
 ______               ______ _________________
 ___  / _____________ ___  //_/__(_)__  /__  /____________
 __  /  _  __ \_  __ `/_  ,<  __  /__  /__  /_  _ \_  ___/
 _  /___/ /_/ /  /_/ /_  /| | _  / _  / _  / /  __/  /
 /_____/\____/_\__, / /_/ |_| /_/  /_/  /_/  \___//_/
              /____/
        Log Killer V1.8 Multi-Level
==========================================================
EOF
echo -e "${FLUO_GREEN}Instagram @mindfuckerrrr${RESET}"
echo -e "${FLUO_GREEN}https://github.com/X3RX3SSec${RESET}"
echo ""
echo -e "${MAGENTA}Tip: Run './logkiller.sh --help' to see all available options.${RESET}"
echo ""

# Check user privilege level
if [[ $EUID -ne 0 ]]; then
    echo -e "Running as a regular user. Some logs require root access to delete."
    echo "For full system cleanup, rerun with: sudo $0"
    USER_LEVEL="basic"
else
    echo -e "${RED}Running as root. Full system cleanup enabled.${RESET}"
    USER_LEVEL="full"
fi

# Display Help Menu
if [[ "$1" == "--help" ]]; then
    echo -e "${MAGENTA}Log Killer Help Menu:${RESET}"
    echo "Usage: ./logkiller.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --silent          Auto-run mode (clears all logs without prompts)"
    echo "  --dry-run         Show logs that would be deleted, but don't delete them"
    echo "  --self-destruct   Deletes the script after execution"
    echo "  --log             Save deleted log paths to /tmp/logkiller_report.txt"
    echo "  --backup          Backup logs to /tmp/logkiller_backup before deletion"
    echo "  --help            Show this help menu"
    echo ""
    echo "Examples:"
    echo "  sudo ./logkiller.sh --silent --log"
    echo "  ./logkiller.sh --dry-run"
    echo "  sudo ./logkiller.sh --silent --backup --self-destruct"
    exit 0
fi

# Check for mode flags
SELF_DESTRUCT="false"
LOGGING="false"
BACKUP="false"

for arg in "$@"; do
    case $arg in
        --silent) 
            echo -e "${MAGENTA}Auto-run mode enabled: Full log cleanup using secure delete.${RESET}"
            CLEAR_ALL="y"
            DELETE_METHOD="s"
            ;;
        --dry-run)
            echo -e "${MAGENTA}Dry-run mode enabled: Showing logs that would be deleted.${RESET}"
            DRY_RUN="true"
            ;;
        --self-destruct)
            echo -e "${RED}Self-destruct mode enabled: This script will delete itself after execution.${RESET}"
            SELF_DESTRUCT="true"
            ;;
        --log)
            echo -e "${FLUO_GREEN}Logging enabled: Deleted logs will be recorded in /tmp/logkiller_report.txt${RESET}"
            LOGGING="true"
            LOG_FILE="/tmp/logkiller_report.txt"
            > "$LOG_FILE"
            ;;
        --backup)
            echo -e "${FLUO_GREEN}Backup enabled: Logs will be saved in /tmp/logkiller_backup before deletion.${RESET}"
            BACKUP="true"
            BACKUP_DIR="/tmp/logkiller_backup"
            mkdir -p "$BACKUP_DIR"
            ;;
    esac
done

# Ask user if no flags were passed
if [[ -z "$CLEAR_ALL" ]]; then
    echo ""
    echo "Log cleanup options:"
    read -p "Clear all logs? (y/n): " CLEAR_ALL
    echo ""
    read -p "Truncate (clear logs) or Shred (secure delete)? (t/s): " DELETE_METHOD

    echo ""
    read -p "FINAL WARNING! Do you want to proceed? (y/n): " FINAL_CONFIRM
    [[ ! "$FINAL_CONFIRM" =~ ^[Yy]$ ]] && echo "Aborted." && exit 0
fi

echo ""
echo "Processing selections..."
sleep 2

# Define clear or shred command
if [[ "$DELETE_METHOD" =~ ^[Ss]$ ]]; then
    DELETE_CMD="shred -u"
    echo "Secure delete enabled: Logs will be permanently shredded."
else
    DELETE_CMD="truncate -s 0"
    echo "Truncate enabled: Logs will be cleared but recoverable."
fi

# Function to process logs
process_logs() {
    local path=$1
    if [[ "$DRY_RUN" == "true" ]]; then
        echo "[DRY-RUN] Would delete: $path"
    else
        [[ "$BACKUP" == "true" ]] && cp --parents "$path" "$BACKUP_DIR" 2>/dev/null
        eval "$DELETE_CMD \"$path\" 2>/dev/null"
        [[ "$LOGGING" == "true" ]] && echo "Deleted: $path" >> "$LOG_FILE"
    fi
}

# Targeted log directories
LOG_FILES=(
    ~/.bash_history /home/*/.bash_history
    /var/log/* /tmp/* /var/tmp/*
    /var/log/dpkg.log /var/log/apt/* /var/log/yum.log /var/log/dnf.log /var/log/pacman.log
    /var/log/wtmp /var/log/btmp /var/log/lastlog /var/log/secure
    /var/lib/systemd/coredump/*
    /var/log/docker.log /var/lib/docker/containers/*/*.log
    /var/log/snapd.log /var/lib/snapd/snaps/*.log
    /var/log/flatpak.log /var/lib/flatpak/app/*/*.log
    /var/log/auth.log /var/log/cron.log
    /var/log/maillog /var/log/mail.err /var/log/mail.warn
    /var/log/samba/* /var/log/sshd.log
)

# Process logs
for log in "${LOG_FILES[@]}"; do
    process_logs "$log"
done

# Completion message
echo -e "${MAGENTA}Log cleanup complete.${RESET}"

# Self-destruct mode
if [[ "$SELF_DESTRUCT" == "true" ]]; then
    echo -e "${RED}Self-destructing script...${RESET}"
    rm -- "$0"
fi
