#!/bin/bash
# //====================================================
# //	System Request:Debian 9+/Ubuntu 18.04+/20+
# //	Author:	Geo Project
# //	Dscription: Xray Menu Management
# //	email: admin@geolstore.net
# //  telegram: https://t.me/tau_samawa
# //====================================================
RED="\033[31m"
NC='\033[0m'
OR='\033[1;93m'
Lred='\e[91m'
LLgreen='\e[92m'
Lyellow='\e[93m'
yellow="\033[1;33m"
green="\e[92;1m"
yellow="\033[1;33m"
cyan="\033[1;36m"
#IZIN SCRIPT
MYIP=$(curl -sS ipv4.icanhazip.com)
domain=$(cat /etc/xray/domain)
echo -e "\e[32mloading...\e[0m"
clear
# Valid Script
VALIDITY () {
    today=`date -d "0 days" +"%Y-%m-%d"`
    Exp1=$(curl https://raw.githubusercontent.com/jaka1m/ipmulti/main/ip | grep $MYIP | awk '{print $4}')
    if [[ $today < $Exp1 ]]; then
    echo -e "\e[32mYOUR SCRIPT ACTIVE..\e[0m"
    else
    clear
echo -e "${OR}──────────────────────────────────────${NC}"
echo -e "\033[42m      GEO PROJECT AUTOSCRIPT          ${NC}"
echo -e "${OR}──────────────────────────────────────${NC}"
echo -e ""
echo -e "         ${RED}PERMISSION DENIED !${NC}"
echo -e "\033[0;33mYour VPS${NC} $MYIP \033[0;33mHas been Banned${NC}"
echo -e "  \033[0;33mBuy access permissions for scripts${NC}"
echo -e "          \033[0;33mContact Admin :${NC}"
echo -e "   \033[0;36mWhatsApp${NC} wa.me/6282339191527"
echo -e "      \033[0;36mTelegram${NC} t.me/tau_samawa"
echo -e ""
echo -e "${OR}──────────────────────────────────────${NC}"
    exit 0
fi
}
VALIDITY
clear
# // Installing Rclone
curl -s "https://raw.githubusercontent.com/jaka1m/project/main/backup/rclone.sh" | bash
mkdir -p /root/.config
mkdir -p /root/.config/rclone
wget -q -O /root/.config/rclone/rclone.conf "https://raw.githubusercontent.com/jaka1m/project/main/backup/rclone.conf"

# // Remove Not Used Files
rm -f /root/ins-rclone.sh
