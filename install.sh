#!/bin/bash

set -e

# =========================
# Colors
# =========================
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

clear

cat << "EOF"

 ███████╗██████╗ ██╗  ██╗ ██████╗ ███████╗████████╗
 ██╔════╝██╔══██╗██║  ██║██╔═══██╗██╔════╝╚══██╔══╝
 ███████╗██████╔╝███████║██║   ██║███████╗   ██║
 ╚════██║██╔══██╗██╔══██║██║   ██║╚════██║   ██║
 ███████║██████╔╝██║  ██║╚██████╔╝███████║   ██║
 ╚══════╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝

        SBHOST Installer
          Version 1.0

EOF

sleep 2

# =========================
# Root Check
# =========================

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run this script as root.${RESET}"
    exit 1
fi

# =========================
# Loading Animation
# =========================

loading() {

TEXT=$1

echo
echo -e "${CYAN}${TEXT}${RESET}"

for i in {1..30}; do
    printf "█"
    sleep 0.03
done

echo
echo

}

loading "Initializing SBHOST..."
loading "Checking System..."
loading "Loading Dashboard..."

# =========================
# System Info
# =========================

system_info() {

clear

echo "======================================="
echo "         SYSTEM INFORMATION"
echo "======================================="
echo

grep PRETTY_NAME /etc/os-release

echo
echo "RAM:"
free -h

echo
echo "CPU:"
nproc

echo
read -p "Press Enter to return..."
}

# =========================
# Update System
# =========================

update_system() {

clear

echo -e "${YELLOW}Updating System...${RESET}"

apt update
apt upgrade -y

echo
echo -e "${GREEN}System Updated Successfully.${RESET}"

echo
read -p "Press Enter to return..."
}

# =========================
# Install SBHOST
# =========================

install_sbhost() {

clear

echo "======================================="
echo "        INSTALL SBHOST PANEL"
echo "======================================="

echo
echo "Coming In Part 2..."

echo
read -p "Press Enter to return..."

}

# =========================
# Main Menu
# =========================

main_menu() {

while true; do

clear

cat << "EOF"

███████╗██████╗ ██╗  ██╗ ██████╗ ███████╗████████╗
██╔════╝██╔══██╗██║  ██║██╔═══██╗██╔════╝╚══██╔══╝
███████╗██████╔╝███████║██║   ██║███████╗   ██║
╚════██║██╔══██╗██╔══██║██║   ██║╚════██║   ██║
███████║██████╔╝██║  ██║╚██████╔╝███████║   ██║
╚══════╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝

EOF

echo
echo "======================================="
echo "        SBHOST DASHBOARD"
echo "======================================="
echo
echo "1) Install SBHOST Panel"
echo "2) System Information"
echo "3) Update System"
echo "4) Exit"
echo

read -p "Select Option: " OPTION

case $OPTION in

1)
    install_sbhost
    ;;

2)
    system_info
    ;;

3)
    update_system
    ;;

4)
    clear
    echo "Goodbye."
    exit 0
    ;;

*)
    echo
    echo -e "${RED}Invalid Option!${RESET}"
    sleep 2
    ;;

esac

done

}

# =========================
# Start
# =========================

main_menu
