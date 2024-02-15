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
export Server_URL="autosscript.site/ambe"
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
MYIP=$(curl -sS ipinfo.io/ip)
echo "Checking VPS"
clear
domain=$(cat /etc/xray/domain)
clear
MYIP=$(curl -sS ipinfo.io/ip)
wssl="$(cat ~/log-install.txt | grep -w "Websocket TLS" | cut -d: -f2|sed 's/ //g')"
ws="$(cat ~/log-install.txt | grep -w "Websocket None TLS" | cut -d: -f2|sed 's/ //g')"
wso="$(cat ~/log-install.txt | grep -w "Websocket Ovpn" | cut -d: -f2|sed 's/ //g')"
ohps="$(cat ~/log-install.txt | grep -w "OHP_SSH" | cut -d: -f2|sed 's/ //g')"
ohpd="$(cat ~/log-install.txt | grep -w "OHP_Dropbear" | cut -d: -f2|sed 's/ //g')"
ohpo="$(cat ~/log-install.txt | grep -w "OHP_OpenVPN" | cut -d: -f2|sed 's/ //g')"
open="$(cat ~/log-install.txt | grep -w "OpenSSH" | cut -d: -f2|sed 's/ //g')"
drop="$(cat ~/log-install.txt | grep -w "Dropbear" | cut -d: -f2|sed 's/ //g')"
web="$(cat ~/log-install.txt | grep -w "Websocket Ovpn" | cut -d: -f2|sed 's/ //g')"

ssl="$(cat ~/log-install.txt | grep -w "Stunnel5" | cut -d: -f2)"
sqd="$(cat ~/log-install.txt | grep -w "Squid" | cut -d: -f2)"
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
clear
Login=Trial`</dev/urandom tr -dc X-Z0-9 | head -c10`
hari="1"
Pass=123
clear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
hariini=`date -d "0 days" +"%Y-%m-%d"`
expi=`date -d "$masaaktif days" +"%Y-%m-%d"`
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e ""
echo -e "${GREEN}━━━━━━━━━━━━━━\033[0m"
echo -e "Thank You For Using Our Services Trial SSH ${off}"
echo -e "OpenVPN & Websocket Account Info${off}"
echo -e "${GREEN}━━━━━━━━━━━━━━\033[0m"
echo -e "Username      : $Login"
echo -e "Password      : $Pass"
echo -e "Created       : $hariini"
echo -e "Expired       : $expi"
echo -e "${GREEN}━━━━━━━━━━━━━━\033[0m"
echo -e "IP/Host       : ${domain}"
echo -e "OpenSSH       : $open"
echo -e "Dropbear      : $drop"
echo -e "SSL/TLS       :$ssl"
echo -e "Port Squid    :$sqd"
echo -e "Port OHP      : SSH $ohps, Dropbear $ohpd, Ovpn $ohpo"
echo -e "${GREEN}━━━━━━━━━━━━━━\033[0m"
echo -e "SSH WS        : $ws"
echo -e "SSH WS SSL    : $wssl"
echo -e "OpenVPN WS    : $wso"
#echo -e "${CYAN}==Payload WS==\033[0m"
#echo -e "\E[41;1;39m GET / HTTP/1.1[crlf]Host: ${domain}[crlf]Connection: Keep-Alive[crlf]User-Agent: [ua][crlf]Upgrade: websocket[crlf][crlf]${off}"
echo -e "${GREEN}━━━━━━━━━━━━━━\033[0m"
echo -e "Link Ovpn     : http://$MYIP:89/"
echo -e "badvpn        : 7100-7200-7300"
echo -e "${GREEN}━━━━━━━━━━━━━━\033[0m"
echo -e " Enjoy Our Auto Script Service $off"
echo -e ""
echo -e ""
echo -e ""
read -n 1 -s -r -p "Press Any Key To Back On Menu"

menu-trial