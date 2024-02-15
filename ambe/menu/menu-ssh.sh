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
IP=$(curl -sS ifconfig.me)
x="ok"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
chck_pid(){
	PID=`ps -ef |grep -v grep | grep dropbear |awk '{print $2}'`
}
menu_sts(){
	if dpkg -s dropbear > /dev/null 2>&1; then
		chck_pid
		if [[ ! -z "${PID}" ]]; then
			echo -e "Current status dropbear: ${Green_font_prefix} Installed${Font_color_suffix} & ${Green_font_prefix}Running${Font_color_suffix}"
		else
			echo -e "Current status dropbear: ${Green_font_prefix} Installed${Font_color_suffix} but ${Red_font_prefix}Not Running${Font_color_suffix}"
		fi
	#	cd "${ssr_folder}"
	else
		echo -e "Current status dropbear: ${Red_font_prefix}Not Installed${Font_color_suffix}"
	fi
}

chck_stunnel(){
	PID=`ps -ef |grep -v grep | grep stunnel5 |awk '{print $2}'`
	if [[ ! -z "${PID}" ]]; then
			echo -e "Current status stunnel5: ${Green_font_prefix} Installed${Font_color_suffix} & ${Green_font_prefix}Running${Font_color_suffix}"
			sts="\033[0;32m◉ \033[0m"
		else
			echo -e "Current status stunnel5: ${Green_font_prefix} Installed${Font_color_suffix} but ${Red_font_prefix}Not Running${Font_color_suffix}"
			sts="\033[1;31m○ \033[0m"
    fi
}
while true $x != "ok"
do

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e "\E[41;1;39m                     ⇱ SSH MENU ⇲               \E[0m"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
menu_sts
chck_stunnel
echo -e "
[${GREEN}01${NC}] ${color1}•${color3}$bd Create SSH & OpenVPN Account
[${GREEN}02${NC}] ${color1}•${color3}$bd Renew SSH & OpenVPN Account
[${GREEN}03${NC}] ${color1}•${color3}$bd Delete SSH & OpenVPN Account
[${GREEN}04${NC}] ${color1}•${color3}$bd Check User Login SSH & OpenVPN
[${GREEN}05${NC}] ${color1}•${color3}$bd List Member SSH & OpenVPN
[${GREEN}06${NC}] ${color1}•${color3}$bd Delete User Expired SSH & OpenVPN
[${GREEN}07${NC}] ${color1}•${color3}$bd Set up Autokill SSH
[${GREEN}08${NC}] ${color1}•${color3}$bd Cek Users Who Do Multi Login SSH
[${GREEN}09${NC}] ${color1}•${color3}$bd Restart Services

[${GREEN}00${NC}] ${color1}• ${NC}Kembali Ke Menu \033[1;32m<\033[1;33m<\033[1;31m<\033[1;31m"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e "\E[41;1;39m                  ⇱ GEOVPN PROJECT ⇲            \E[0m"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -ne "Select menu : "; read x

case "$x" in 
   1 | 01)
   clear
   addssh
   break
   ;;
   2 | 02)
   clear
   renewssh
   break
   ;;
   3 | 03)
   clear
   delssh
   break
   ;;
   4 | 04)
   clear
   cekssh
   break
   ;;
   5 | 05)
   clear
   member
   break
   ;;
   6 | 06)
   clear
   delexp
   break
   ;;
   7 | 07)
   clear
   autokill
   break
   ;;
   8 | 08)
   clear
   ceklim
   break
   ;;
   9 | 08)
   clear
   restart
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
