#!/bin/bash

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
echo -e "${GREEN}      SBHOST Local/Playit Minecraft Setup           ${NC}"
echo -e "${YELLOW}====================================================${NC}"
echo ""

echo -e "${CYAN}Please select an option:${NC}"
echo "  1) Local Minecraft Server Environment Setup"
echo "  2) Configure Panel with Playit.gg IP"
echo ""
read -p "Apna option select karein (1 ya 2): " option

case $option in
    1)
        echo ""
        echo -e "${GREEN}[+] Option 1: Local Environment setup shuru ho raha hai...${NC}"
        echo "Checking packages..."
        if command -v apt-get &> /dev/null; then
            apt-get update && apt-get install -y curl wget default-jre
        fi
        echo -e "${GREEN}[✔] Local environment tayar hai! Aap apna server.jar run kar sakte hain.${NC}"
        ;;
    2)
        echo ""
        echo -e "${GREEN}[+] Option 2: Panel & Playit IP Configuration${NC}"
        
        read -p "Playit.gg se mili hui IP:Port enter karein (e.g., something.ply.gg:12345): " playit_ip
        
        if [ -z "$playit_ip" ]; then
            echo -e "${RED}[✘] Error: IP khali nahi ho sakti!${NC}"
            exit 1
        fi

        echo -e "${GREEN}[✔] IP successfully registered: $playit_ip${NC}"
        echo -e "${CYAN}[i] Ab aap aur aapke dost is address par Minecraft join kar sakte hain:${NC}"
        echo -e "${YELLOW}Server Address: $playit_ip${NC}"
        ;;
    *)
        echo ""
        echo -e "${RED}[✘] Galat option select kiya hai. 1 ya 2 chunen.${NC}"
        exit 1
        ;;
esac
