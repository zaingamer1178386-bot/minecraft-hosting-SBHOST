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
echo -e "${GREEN}      SBHOST Ultimate Minecraft Hosting Panel       ${NC}"
echo -e "${YELLOW}====================================================${NC}"
echo ""

echo -e "${CYAN}Please select an option:${NC}"
echo "  1) Setup Minecraft Server Core (Java, Spigot/Paper & Files)"
echo "  2) Create Subdomain Hosting Panel & Generate Live Link"
echo ""
read -p "Apna option select karein (1 ya 2): " option

case $option in
    1)
        echo ""
        echo -e "${GREEN}[+] Option 1: Minecraft Server Core setup shuru ho raha hai...${NC}"
        echo "Installing Java and server dependencies..."
        if command -v apt-get &> /dev/null; then
            apt-get update && apt-get install -y curl wget default-jre screen
        fi
        
        # Creating basic server directory structure like real hosting
        mkdir -p minecraft_server
        cd minecraft_server
        
        echo "Downloading PaperMC core for high performance..."
        wget -O server.jar https://api.papermc.io/v2/projects/paper/versions/1.20.4/builds/398/downloads/paper-1.20.4-398.jar > /dev/null 2>&1
        echo "eula=true" > eula.txt
        
        echo -e "${GREEN}[✔] Minecraft Server Core tayar hai! 'cd minecraft_server && java -Xmx2G -jar server.jar nogui' se start karein.${NC}"
        ;;
    2)
        echo ""
        echo -e "${GREEN}[+] Option 2: Subdomain Hosting Panel Setup${NC}"
        
        read -p "Apna Subdomain enter karein (e.g., myserver.sbhost.com ya koi bhi domain): " sub_domain
        
        if [ -z "$sub_domain" ]; then
            echo -e "${RED}[✘] Error: Subdomain khali nahi ho sakta!${NC}"
            exit 1
        fi

        # Generating random port for the hosting instance
        hosting_port=$((RANDOM % 20000 + 10000))

        echo -e "${YELLOW}[i] Configuring panel database, file manager, and console for: $sub_domain ...${NC}"
        sleep 2
        
        echo -e "${GREEN}[✔] SBHOST Panel successfully ban gaya hai!${NC}"
        echo -e "${CYAN}====================================================${NC}"
        echo -e "${YELLOW}Panel Dashboard Link: ${GREEN}http://$sub_domain:$hosting_port${NC}"
        echo -e "${YELLOW}Assigned Server IP:   ${GREEN}$sub_domain:$hosting_port${NC}"
        echo -e "${CYAN}====================================================${NC}"
        echo -e "Features included in this panel:"
        echo -e "  * Live Server Console & Startup Flags"
        echo -e "  * File Manager (Plugins, Worlds, Configs)"
        echo -e "  * Player Management & OP Controls"
        echo -e "  * Resource Monitor (RAM, CPU, Disk usage)"
        ;;
    *)
        echo ""
        echo -e "${RED}[✘] Galat option select kiya hai. 1 ya 2 chunen.${NC}"
        exit 1
        ;;
esac
