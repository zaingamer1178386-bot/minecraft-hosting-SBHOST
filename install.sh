#!/bin/bash

# Root check
if [ "$EUID" -ne 0 ]; then
  echo -e "\033[1;31m[✘] Error: Please run this script as root (use sudo).\033[0m"
  exit 1
fi

CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

clear

# Big SBHOST Banner
echo -e "${CYAN}"
echo " ███████╗██████╗ ██╗  ██╗ ██████╗ ███████╗████████╗"
echo " ██╔════╝██╔══██╗██║  ██║██╔═══██╗██╔════╝╚══██╔══╝"
echo " ███████╗██████╔╝███████║██║   ██║███████╗   ██║   "
echo " ╚════██║██╔══██╗██║  ██║██║   ██║╚════██║   ██║   "
echo " ███████║██████╔╝██║  ██║╚██████╔╝███████║   ██║   "
echo " ╚══════╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   "
echo -e "${NC}"
echo -e "${YELLOW}====================================================${NC}"
echo -e "${GREEN}      SBHOST Real Minecraft & VPS Hosting Panel     ${NC}"
echo -e "${YELLOW}====================================================${NC}"
echo ""

echo -e "${CYAN}Please select an option:${NC}"
echo "  1) Real VPS Resource & Docker Environment Setup"
echo "  2) Full Production Minecraft Hosting Panel (Pterodactyl + Wings)"
echo ""
read -p "Apna option select karein (1 ya 2): " option

case $option in
    1)
        echo ""
        echo -e "${GREEN}[+] Option 1: Real VPS Environment aur Docker setup shuru ho raha hai...${NC}"
        
        # Check systemd requirement for real VPS
        if ! pidof systemd >/dev/null 2>&1; then
            echo -e "${RED}[✘] Error: Systemd is not running! Yeh script kisi real VPS (Ubuntu 20.04/22.04) par chalayein.${NC}"
            exit 1
        fi

        apt-get update && apt-get upgrade -y
        apt-get install -y curl wget ufw git apt-transport-https ca-certificates gnupg lsb-release

        # Real Docker Installation
        if ! command -v docker &> /dev/null; then
            echo "Installing Docker engine..."
            curl -fsSL https://get.docker.com -o get-docker.sh
            sh get-docker.sh
            systemctl enable --now docker
        else
            echo -e "${GREEN}[✔] Docker pehle se installed hai.${NC}"
        fi

        echo -e "${GREEN}[✔] Real VPS Environment aur Docker mukammal taur par tayar ho gaya hai!${NC}"
        echo "Aapke server ke active resources/containers yeh hain:"
        docker ps
        ;;
    2)
        echo ""
        echo -e "${GREEN}[+] Option 2: Full Production Hosting Panel installation shuru ho rahi hai...${NC}"
        
        if ! pidof systemd >/dev/null 2>&1; then
            echo -e "${RED}[✘] Error: Systemd is required to run a real hosting panel.${NC}"
            exit 1
        fi

        read -p "Apna Panel Domain enter karein (e.g., panel.yourdomain.com): " user_domain
        
        if [ -z "$user_domain" ]; then
            echo -e "${RED}[✘] Error: Domain name khali nahi ho sakta!${NC}"
            exit 1
        fi

        # Get real public IP and check DNS domain record
        server_ip=$(curl -s ifconfig.me || hostname -I | awk '{print $1}')
        
        if ! command -v dig &> /dev/null; then
            apt-get install -y dnsutils >/dev/null 2>&1
        fi
        
        domain_ip=$(dig +short "$user_domain" | tail -n1)

        echo -e "${YELLOW}[i] Checking domain configuration for: $user_domain ...${NC}"
        echo -e "${YELLOW}[i] Server Public IP: $server_ip | Domain DNS IP: ${domain_ip:-Not Found}${NC}"

        # Real Domain Validation Logic
        if [ -z "$domain_ip" ]; then
            echo -e "${RED}[✘] This is not your domain! (Yeh domain exist nahi karta ya DNS A record set nahi hai)${NC}"
            exit 1
        elif [ "$domain_ip" != "$server_ip" ]; then
            echo -e "${RED}[✘] This is not your domain! (Domain ki IP: $domain_ip aapke server ki IP: $server_ip se match nahi karti)${NC}"
            exit 1
        else
            echo -e "${GREEN}[✔] Domain verified successfully! IP match ho gayi hai.${NC}"
            echo -e "${CYAN}[i] Installing official Pterodactyl Panel & Daemon (Real Hosting Stack)...${NC}"
            
            # Running official production installer script for panel & wings
            bash <(curl -s https://raw.githubusercontent.com/pterodactyl-installer/pterodactyl-installer/v1.7.0/install.sh) --panel --wings --mysql-root-password "SBHost$(openssl rand -hex 4)" --email admin@$user_domain --unoview --panel-domain $user_domain --php-version 8.1 --letsencrypt --cersemail admin@$user_domain
            
            echo -e "${GREEN}[✔] Real Hosting Panel successfully install ho gaya hai!${NC}"
            echo -e "Aap apna panel is secure link par access kar sakte hain: ${CYAN}https://$user_domain${NC}"
        fi
        ;;
    *)
        echo ""
        echo -e "${RED}[✘] Galat option select kiya hai. Baraye meharbani 1 ya 2 chunen.${NC}"
        exit 1
        ;;
esac
