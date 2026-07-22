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
echo " ╚════██║██╔══██║██║  ██║██║   ██║╚════██║   ██║   "
echo " ███████║██████╔╝██║  ██║╚██████╔╝███████║   ██║   "
echo " ╚══════╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   "
echo -e "${NC}"
echo -e "${YELLOW}====================================================${NC}"
echo -e "${GREEN}    SBHOST Minecraft VPS & Pterodactyl Panel      ${NC}"
echo -e "${YELLOW}====================================================${NC}"
echo ""

echo -e "${CYAN}Please select an option:${NC}"
echo "  1) Real Minecraft VPS Setup (Docker/Container Environment)"
echo "  2) Minecraft Panel Install (Pterodactyl Panel on this VPS)"
echo ""
read -p "Apna option select karein (1 ya 2): " option

case $option in
    1)
        echo ""
        echo -e "${GREEN}[+] Option 1: Real Minecraft VPS Environment shuru ho raha hai...${NC}"
        echo "Updating system and installing Docker for Minecraft containers..."
        apt-get update && apt-get upgrade -y
        apt-get install -y curl wget ufw git
        
        # Install Docker if not installed
        if ! command -v docker &> /dev/null; then
            curl -sSL https://get.docker.com | channel=stable sh
            systemctl enable --now docker
        fi
        
        echo -e "${GREEN}[✔] Minecraft VPS Environment mukammal taur par tayar ho gaya hai!${NC}"
        ;;
    2)
        echo ""
        echo -e "${GREEN}[+] Option 2: Minecraft Panel (Pterodactyl) installation shuru ho rahi hai...${NC}"
        
        read -p "Apna Panel Domain enter karein (e.g., panel.yourdomain.com): " user_domain
        
        if [ -z "$user_domain" ]; then
            echo -e "${RED}[✘] Error: Domain name khali nahi ho sakta!${NC}"
            exit 1
        fi

        # Get server public IP and check domain DNS
        server_ip=$(curl -s ifconfig.me)
        domain_ip=$(dig +short "$user_domain" | tail -n1)

        echo -e "${YELLOW}[i] Checking domain configuration for: $user_domain ...${NC}"
        echo -e "${YELLOW}[i] Server IP: $server_ip | Domain IP: ${domain_ip:-Not Found}${NC}"

        if [ -z "$domain_ip" ]; then
            echo -e "${RED}[✘] Yeh domain exist nahi karta ya DNS A record set nahi hai!${NC}"
            exit 1
        elif [ "$domain_ip" != "$server_ip" ]; then
            echo -e "${RED}[✘] This is not your domain! (Domain IP: $domain_ip current server IP: $server_ip se match nahi karti)${NC}"
            exit 1
        else
            echo -e "${GREEN}[✔] Domain verified successfully! IP match ho gayi hai.${NC}"
            echo -e "${CYAN}[i] Installing Pterodactyl Minecraft Panel locally on this VPS...${NC}"
            
            # Automated Pterodactyl Panel single-click script execution for local VPS
            bash <(curl -s https://raw.githubusercontent.com/pterodactyl-installer/pterodactyl-installer/v1.7.0/install.sh) --panel --extras --email admin@$user_domain --unoview --panel-domain $user_domain --php-version 8.1 --no-firewall --no-letsencrypt
            
            echo -e "${GREEN}[✔] Minecraft Panel successfully is VPS par ban gaya hai!${NC}"
            echo -e "Aap apna panel is link par access kar sakte hain: ${CYAN}http://$user_domain${NC}"
        fi
        ;;
    *)
        echo ""
        echo -e "${RED}[✘] Galat option select kiya hai. Baraye meharbani 1 ya 2 chunen.${NC}"
        exit 1
        ;;
esac
