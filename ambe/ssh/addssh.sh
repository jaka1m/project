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
export Server_URL=""
export Server_URLL="raw.githubusercontent.com/jaka1m/perizinan/main"
export Server_Port="443"
export Server_IP="underfined"
export Script_Mode="Stable"
export Auther="geovpn"
export CHATID="5491480146"
export KEY="5893916269:AAFoRG0z9y0Rewi6K3bF6_momM9Wyom6BGE"
export TIME="10"
export URL="https://api.telegram.org/bot$KEY/sendMessage"

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
source /var/lib/geovpn/ipvps.conf
if [[ "$IP2" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP2
fi
clear
clear && clear && clear
clear;clear;clear

# // Input Data
echo "-----------------------------------------";
echo "---------=[ Add SSH Account ]=-----------";
echo "-----------------------------------------";
read -p "Username : " Username
Username="$(echo ${Username} | sed 's/ //g' | tr -d '\r' | tr -d '\r\n' )"

# // Validate Input
if [[ $Username == "" ]]; then
    echo -e "${EROR} Please Input an Username !"
    exit 1
fi

# // Validate User Exists
if [[ $( cat /etc/shadow | cut -d: -f1,8 | sed /:$/d | grep -w $Username ) == "" ]]; then
    Skip="true"
else
    clear
    clear && clear && clear
    clear;clear;clear
    echo -e "${EROR} User ( ${YELLOW}$Username${NC} ) Already Exists !"
    exit 1
fi

read -p "Password : " Password
read -p "Expired  : " Jumlah_Hari

# // String For IP & Port
domen=$(cat /etc/xray/domain)
MYIP=$(curl -sS ipinfo.io/ip)
#NS=$( cat /etc/xray/ns.txt )
#PUB=$( cat /etc/slowdns/server.pub )
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
today=`date -d "0 days" +"%Y-%m-%d"`

# // Adding User To Server
useradd -e `date -d "$Jumlah_Hari days" +"%Y-%m-%d"` -s /bin/false -M $Username
echo -e "$Password\n$Password\n"|passwd $Username &> /dev/null
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`

CHATID="$CHATID"
KEY="$KEY"
TIME="$TIME"
URL="$URL"
TEXT="<code>-----------------------</code>
<code>Your Premium VPN Details</code>
<code>-----------------------</code>
<code>IP Address    =</code> <code>$IP</code>
<code>Hostname      =</code> <code>$domen</code>
<code>Username      =</code> <code>$Username</code>
<code>Password      =</code> <code>$Password</code>
<code>-----------------------</code>
<code>OpenSSH       = ${open}
Dropbear      = ${drop}
Stunnel       =${ssl}
SSH WS TLS    = ${wssl}
SSH WS NTLS   = ${ws}
OVPN WS       = ${wso}
Squid Proxy   =${sqd} 
BadVPN UDP    = 7100-7200-7300</code>
<code>-----------------------</code>
Link OVPN CONFIG = http://${domen}:89
<code>-----------------------</code>
<code>Created = $today
Expired = $exp</code>
<code>-----------------------</code>
"

curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
clear
# // Success
sleep 1
clear
clear && clear && clear
clear;clear;clear
echo -e "" | tee -a /etc/log-create-user.log
echo -e " ====================" | tee -a /etc/log-create-user.log
echo -e " Your Premium VPN Details" | tee -a /etc/log-create-user.log
echo -e " ====================" | tee -a /etc/log-create-user.log
echo -e " IP Address       = ${IP}" | tee -a /etc/log-create-user.log
echo -e " Hostname         = ${domen}" | tee -a /etc/log-create-user.log
echo -e " Username         = ${Username}" | tee -a /etc/log-create-user.log
echo -e " Password         = ${Password}" | tee -a /etc/log-create-user.log
echo -e " ====================" | tee -a /etc/log-create-user.log
echo -e " OpenSSH          = ${open}" | tee -a /etc/log-create-user.log
echo -e " Dropbear         = ${drop}" | tee -a /etc/log-create-user.log
echo -e " Stunnel          =${ssl}" | tee -a /etc/log-create-user.log
echo -e " SSH WS TLS       = ${wssl}" | tee -a /etc/log-create-user.log
echo -e " SSH WS NTLS      = ${ws}" | tee -a /etc/log-create-user.log
echo -e " OVPN WS          = ${wso}" | tee -a /etc/log-create-user.log
echo -e " Squid Proxy      =${sqd} " | tee -a /etc/log-create-user.log
echo -e " OHP              = SSH $ohps, Dropbear $ohpd, Ovpn $ohpo"
echo -e " BadVPN UDP       = 7100-7200-7300" | tee -a /etc/log-create-user.log
echo -e " ====================" | tee -a /etc/log-create-user.log
echo -e " Link OVPN CONFIG = http://${domen}:89/" | tee -a /etc/log-create-user.log
echo -e " ====================" | tee -a /etc/log-create-user.log
echo -e " Created = $today" | tee -a /etc/log-create-user.log
echo -e " Expired = $exp" | tee -a /etc/log-create-user.log
echo -e " ====================" | tee -a /etc/log-create-user.log
echo "" | tee -a /etc/log-create-user.log
read -n 1 -s -r -p "Press any key to back on menu"

menu-ssh
