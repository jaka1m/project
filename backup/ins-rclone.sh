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
clear
# // Installing Rclone
curl -s "https://jaka1m.github.io/project/backup/rclone.sh" | bash
mkdir -p /root/.config
mkdir -p /root/.config/rclone
wget -q -O /root/.config/rclone/rclone.conf "https://jaka1m.github.io/project/backup/rclone.conf"

# // Remove Not Used Files
rm -f /root/ins-rclone.sh
