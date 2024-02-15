#!/bin/bash
# =========================================
# Quick Setup | Script Setup Manager
# Edition : Stable Edition V1.0
# Auther  : Adit Ardiansyah
# (C) Copyright 2022
# =========================================

# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${EROR} Please Run This Script As Root User !"
		exit 1
fi

# // Exporting Language to UTF-8
export LC_ALL='en_US.UTF-8' > /dev/null
export LANG='en_US.UTF-8' > /dev/null
export LANGUAGE='en_US.UTF-8' > /dev/null
export LC_CTYPE='en_US.utf8' > /dev/null

# // Export Color & Information
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'

# // Export Banner Status Information
export EROR="[${RED} ERROR ${NC}]"
export INFO="[${YELLOW} INFO ${NC}]"
export OKEY="[${GREEN} OKEY ${NC}]"
export PENDING="[${YELLOW} PENDING ${NC}]"
export SEND="[${YELLOW} SEND ${NC}]"
export RECEIVE="[${YELLOW} RECEIVE ${NC}]"

# // Export Align
export BOLD="\e[1m"
export WARNING="${RED}\e[5m"
export UNDERLINE="\e[4m"

# // Exporting URL Host
export Server_URL="jaka1m.github.io/project/ambe"
export Server_URLL="raw.githubusercontent.com/jaka1m/perizinan/main"
export Server_Port="443"
export Server_IP="underfined"
export Script_Mode="Stable"
export Auther="geovpn"

# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${EROR} Please Run This Script As Root User !"
		exit 1
fi

# // Exporting IP Address
export IP=$( curl -sS ipinfo.io/ip )

# // Exporting Network Interface
export NETWORK_IFACE="$(ip route show to default | awk '{print $5}')"

# // Validate Result ( 1 )
touch /etc/${Auther}/license.key
export Your_License_Key="$( cat /etc/${Auther}/license.key | awk '{print $1}' )"
export Validated_Your_License_Key_With_Server="$( curl -s https://${Server_URLL}/registered.txt | grep -w $Your_License_Key | head -n1 | cut -d ' ' -f 1 )"
if [[ "$Validated_Your_License_Key_With_Server" == "$Your_License_Key" ]]; then
    validated='true'
else
    echo -e "${EROR} License Key Not Valid"
    exit 1
fi

# // Checking VPS Status > Got Banned / No
if [[ $IP == "$( curl -s https://${Server_URLL}/blacklist.txt | cut -d ' ' -f 1 | grep -w $IP | head -n1 )" ]]; then
    echo -e "${EROR} 403 Forbidden ( Your VPS Has Been Banned )"
    exit  1
fi

# // Checking VPS Status > Got Banned / No
if [[ $Your_License_Key == "$( curl -s https://${Server_URLL} | cut -d ' ' -f 1 | grep -w $Your_License_Key | head -n1)" ]]; then
    echo -e "${EROR} 403 Forbidden ( Your License Has Been Limited )"
    exit  1
fi

# // Checking VPS Status > Got Banned / No
if [[ 'Standart' == "$( curl -s https://${Server_URLL}/registered.txt | grep -w $Your_License_Key | head -n1 | cut -d ' ' -f 8 )" ]]; then 
    License_Mode='Standart'
elif [[ Pro == "$( curl -s https://${Server_URLL}/registered.txt | grep -w $Your_License_Key | head -n1 | cut -d ' ' -f 8 )" ]]; then 
    License_Mode='Pro'
else
    echo -e "${EROR} Please Using Genuine License !"
    exit 1
fi

# // Checking Script Expired
exp=$( curl -s https://${Server_URLL}/registered.txt | grep -w $Your_License_Key | cut -d ' ' -f 4 )
now=`date -d "0 days" +"%Y-%m-%d"`
expired_date=$(date -d "$exp" +%s)
now_date=$(date -d "$now" +%s)
sisa_hari=$(( ($expired_date - $now_date) / 86400 ))
if [[ $sisa_hari -lt 0 ]]; then
    echo $sisa_hari > /etc/${Auther}/license-remaining-active-days.db
    echo -e "${EROR} Your License Key Expired ( $sisa_hari Days )"
    exit 1
else
    echo $sisa_hari > /etc/${Auther}/license-remaining-active-days.db
fi
clear
date
echo ""
x="ok"

cekray=`cat /root/log-install.txt | grep -ow "XRAY" | sort | uniq`
if [ "$cekray" = "XRAY" ]; then
kjj='xray'
else
kjj='xray'
fi
[[ -f /etc/ontorrent ]] && sts="\033[0;32mON \033[0m" || sts="\033[1;31mOFF\033[0m"

enabletorrent() {
[[ ! -f /etc/ontorrent ]] && {
sudo iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
sudo iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
sudo iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
sudo iptables-save > /etc/iptables.up.rules
sudo iptables-restore -t < /etc/iptables.up.rules
sudo netfilter-persistent save >/dev/null 2>&1
sudo netfilter-persistent reload >/dev/null 2>&1
touch /etc/ontorrent
setting-menu
} || {
sudo iptables -D FORWARD -m string --string "get_peers" --algo bm -j DROP
sudo iptables -D FORWARD -m string --string "announce_peer" --algo bm -j DROP
sudo iptables -D FORWARD -m string --string "find_node" --algo bm -j DROP
sudo iptables -D FORWARD -m string --algo bm --string "BitTorrent" -j DROP
sudo iptables -D FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
sudo iptables -D FORWARD -m string --algo bm --string "peer_id=" -j DROP
sudo iptables -D FORWARD -m string --algo bm --string ".torrent" -j DROP
sudo iptables -D FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
sudo iptables -D FORWARD -m string --algo bm --string "torrent" -j DROP
sudo iptables -D FORWARD -m string --algo bm --string "announce" -j DROP
sudo iptables -D FORWARD -m string --algo bm --string "info_hash" -j DROP
sudo iptables-save > /etc/iptables.up.rules
sudo iptables-restore -t < /etc/iptables.up.rules
sudo netfilter-persistent save >/dev/null 2>&1
sudo netfilter-persistent reload >/dev/null 2>&1
rm -f /etc/ontorrent
setting-menu
}
}

while true $x != "ok"
do

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e "\E[41;1;39m             ⇱ SETTINGS  MENU ⇲                \E[0m"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e "\033[1;33mSettings\033[0m :

[${GREEN}01${NC}] ${color1}•${NC} Add/Change VPS Host Subdomain
[${GREEN}02${NC}] ${color1}•${NC} Add Subdomain to Cloudflare
[${GREEN}03${NC}] ${color1}•${NC} Add Pointing Bug
[${GREEN}04${NC}] ${color1}•${NC} Renew Certificate $kjj
[${GREEN}05${NC}] ${color1}•${NC} Change Banner VPS
[${GREEN}06${NC}] ${color1}•${NC} Change VPS Auto Reboot Time
[${GREEN}07${NC}] ${color1}•${NC} Limit Bandwidth Speed Server

${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e "\033[1;33mChange-Port\033[0m :

[${GREEN}08${NC}] ${color1}•${NC} Change Port OpenVPN
[${GREEN}09${NC}] ${color1}•${NC} Change Port Wireguard
[${GREEN}10${NC}] ${color1}•${NC} Change Port Vmess
[${GREEN}11${NC}] ${color1}•${NC} Change Port Vless
[${GREEN}12${NC}] ${color1}•${NC} Change Port Trojan
[${GREEN}13${NC}] ${color1}•${NC} Change Port Squid
[${GREEN}14${NC}] ${color1}•${NC} Change Port SSTP
[${GREEN}15${NC}] ${color1}•${NC} Change Port SSH WS None TLS
[${GREEN}16${NC}] ${color1}•${NC} Change Port SSH WS TLS

[${GREEN}00${NC}] ${color1} •${color3}$bd Back to Main Menu \033[1;32m<\033[1;33m<\033[1;31m<\033[1;31m"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e "\E[41;1;39m               ⇱ GEOVPN PROJECT ⇲               \E[0m"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo ""
echo -ne "Select menu : "; read x

case "$x" in 
   1 | 01)
   clear
   addhost
   break
   ;;
   2 | 02)
   clear
   cloudflare-setting
   break
   ;;
   3 | 03)
   clear
   cloudflare-pointing
   break
   ;;
   4 | 04)
   clear
   certv2ray
   break
   ;;
   5 | 05)
   clear
   nano /etc/issue.net
   break
   ;;
   6 | 06)
   clear
   autoreboot
   break
   ;;
   7 | 07)
   clear
   limitspeed
   break
   ;;
   8 | 08)
   clear
   portovpn
   break
   ;;
   9 | 09)
   clear
   portwg
   break
    ;;
   10)
   clear
   portv2ray
   break
   ;;
   11)
   clear
   portvless
   break
   ;;
   12)
   clear
   porttrojan
   break
   ;;
   13)
   clear
   portsquid
   break
   ;;
   14)
   clear
   portsstp
   break
   ;;
   15)
   clear
   portwsnon
   break
   ;;
   16)
   clear
   portwstls
   break
   ;;
   0 | 00)
   clear
   menu
   break
   ;;
   *)
   clear
esac
done
#fim
