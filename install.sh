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
# ==================================================
# SBHOST - Install Docker + Docker Compose + Node.js
# + Nginx
# ==================================================

install_requirements() {

clear

echo "========================================"
echo " Installing Required Packages"
echo "========================================"
echo

apt update -y

apt install -y \
curl \
wget \
git \
unzip \
tar \
software-properties-common \
ca-certificates \
apt-transport-https \
gnupg \
lsb-release

echo
echo "Base Packages Installed."
sleep 2

#########################################
# Docker
#########################################

if ! command -v docker >/dev/null 2>&1; then

echo
echo "Installing Docker..."

curl -fsSL https://get.docker.com | bash

systemctl enable docker
systemctl start docker

else

echo
echo "Docker Already Installed."

fi

#########################################
# Docker Compose
#########################################

if ! docker compose version >/dev/null 2>&1; then

echo
echo "Installing Docker Compose..."

mkdir -p ~/.docker/cli-plugins

curl -SL \
https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
-o ~/.docker/cli-plugins/docker-compose

chmod +x ~/.docker/cli-plugins/docker-compose

else

echo
echo "Docker Compose Already Installed."

fi

#########################################
# Node.js 22
#########################################

if ! command -v node >/dev/null 2>&1; then

echo
echo "Installing Node.js..."

curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

apt install -y nodejs

else

echo
echo "Node.js Already Installed."

fi

#########################################
# Nginx
#########################################

if ! command -v nginx >/dev/null 2>&1; then

echo
echo "Installing Nginx..."

apt install -y nginx

systemctl enable nginx
systemctl start nginx

else

echo
echo "Nginx Already Installed."

fi

echo
echo "========================================"
echo " All Requirements Installed Successfully"
echo "========================================"

echo
echo "Docker Version:"
docker --version

echo
echo "Docker Compose:"
docker compose version

echo
echo "Node Version:"
node -v

echo
echo "NPM Version:"
npm -v

echo
echo "Nginx Version:"
nginx -v

echo
read -p "Press Enter To Continue..."

}
main_menu
#!/bin/bash

# ==================================================
# SBHOST Part 3A
# PHP 8.3 + MariaDB + Redis + Composer
# ==================================================

set -e

echo "Updating packages..."
apt update -y

echo "Installing PHP..."
apt install -y software-properties-common ca-certificates lsb-release apt-transport-https
add-apt-repository -y ppa:ondrej/php || true
apt update -y

apt install -y \
php8.3 php8.3-cli php8.3-fpm php8.3-common \
php8.3-mysql php8.3-gd php8.3-mbstring php8.3-bcmath \
php8.3-xml php8.3-curl php8.3-zip php8.3-intl

echo "Installing MariaDB..."
apt install -y mariadb-server
systemctl enable mariadb || true
systemctl start mariadb || true

echo "Installing Redis..."
apt install -y redis-server
systemctl enable redis-server || true
systemctl start redis-server || true

echo "Installing Composer..."
EXPECTED_SIGNATURE=$(curl -s https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer','composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('sha384','composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then
    echo "Composer installer signature mismatch."
    rm -f composer-setup.php
    exit 1
fi

php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm -f composer-setup.php

echo
echo "===================================="
echo " SBHOST Part 3A Completed!"
echo "===================================="
echo "PHP: $(php -v | head -n1)"
echo "Composer: $(composer --version)"
echo "MariaDB installed."
echo "Redis installed."
echo
echo "Continue with Part 3B next."
