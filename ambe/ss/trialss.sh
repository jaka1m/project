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
SSTrial=trial`</dev/urandom tr -dc A-Z0-9 | head -c4`
Hariii=1
Passss=1
IP=$(curl -sS ifconfig.me);
lastport1=$(grep "port_tls" /etc/shadowsocks-libev/akun.conf | tail -n1 | awk '{print $2}')
lastport2=$(grep "port_http" /etc/shadowsocks-libev/akun.conf | tail -n1 | awk '{print $2}')
if [[ $lastport1 == '' ]]; then
tls=2443
else
tls="$((lastport1+1))"
fi
if [[ $lastport2 == '' ]]; then
http=3443
else
http="$((lastport2+1))"
fi
until [[ $SSTrial =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		
		CLIENT_EXISTS=$(grep -w $SSTrial /etc/shadowsocks-libev/akun.conf | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m           ⇱ Trial SS ⇲            \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

			echo ""
			echo "A client with the specified name was already created, please choose another name."
			echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"            
ss-menu
		fi
	done
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m           ⇱ Trial SS ⇲            \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

exp=`date -d "$Hariii days" +"%Y-%m-%d"`
cat > /etc/shadowsocks-libev/$SSTrial-tls.json<<END
{   
    "server":"0.0.0.0",
    "server_port":$tls,
    "password":"$SSTrial",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "no_delay":true,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=tls"
}
END
cat > /etc/shadowsocks-libev/$SSTrial-http.json <<-END
{
    "server":"0.0.0.0",
    "server_port":$http,
    "password":"$SSTrial",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "no_delay":true,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=http"
}
END
chmod +x /etc/shadowsocks-libev/$SSTrial-tls.json
chmod +x /etc/shadowsocks-libev/$SSTrial-http.json

systemctl start shadowsocks-libev-server@$SSTrial-tls.service > /dev/null 2>&1
systemctl enable shadowsocks-libev-server@$SSTrial-tls.service > /dev/null 2>&1
systemctl start shadowsocks-libev-server@$SSTrial-http.service > /dev/null 2>&1
systemctl enable shadowsocks-libev-server@$SSTrial-http.service > /dev/null 2>&1
tmp1=$(echo -n "aes-256-cfb:${SSTrial}@${IP}:$tls" | base64 -w0)
tmp2=$(echo -n "aes-256-cfb:${SSTrial}@${IP}:$http" | base64 -w0)
linkss1="ss://${tmp1}?plugin=obfs-local;obfs=tls;obfs-host=bing.com"
linkss2="ss://${tmp2}?plugin=obfs-local;obfs=http;obfs-host=bing.com"
echo -e "### $SSTrial $exp
port_tls $tls
port_http $http">>"/etc/shadowsocks-libev/akun.conf"
service cron restart > /dev/null 2>&1
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m           ⇱ Trial SS ⇲            \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -e "IP/Host : $IP"
echo -e "Port OBFS TLS : $tls"
echo -e "Port OBFS HTTP : $http"
echo -e "Password : $SSTrial"
echo -e "Method : aes-256-cfb"
echo -e "Expired On : $exp"
echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link OBFS TLS : $linkss1"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link OBFS HTTP : $linkss2"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"            
ss-menu