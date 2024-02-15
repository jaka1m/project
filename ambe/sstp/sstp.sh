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
sleep 3
sleep 1
source /etc/os-release
OS=$ID
ver=$VERSION_ID
if [[ $OS == 'ubuntu' ]]; then
if [[ "$ver" = "18.04" ]]; then
yoi=Ubuntu18
elif [[ "$ver" = "20.04" ]]; then
yoi=Ubuntu20
fi
elif [[ $OS == 'debian' ]]; then
if [[ "$ver" = "9" ]]; then
yoi=Debian9
elif [[ "$ver" = "10" ]]; then
yoi=Debian10
fi
fi

echo -e "[ ${GREEN}INFO${NC} ] Checking... "
mkdir -p /home/sstp > /dev/null 2>&1
touch /home/sstp/sstp_account
touch /var/lib/geovpnstore/data-user-sstp

#detail nama perusahaan
country=ID
state=Indonesia
locality=Indonesia
organization=geovpn
organizationalunit=geovpn
commonname=geovpn
email=admin@geolstore.net
cd
sstppkgs='cmake gcc libpcre3-dev libssl-dev liblua5.1-0-dev ppp'
if ! dpkg -s $sstppkgs >/dev/null 2>&1; then

        echo -e "[ ${GREEN}INFO${NC} ] Installing sstp packages..."
        apt-get install -y $sstppkgs >/dev/null 2>&1
        git clone https://github.com/accel-ppp/accel-ppp.git /opt/accel-ppp-code >/dev/null 2>&1
        mkdir -p /opt/accel-ppp-code/build >/dev/null 2>&1
        cd /opt/accel-ppp-code/build/
        cmake -DBUILD_IPOE_DRIVER=TRUE -DBUILD_VLAN_MON_DRIVER=TRUE -DCMAKE_INSTALL_PREFIX=/usr -DKDIR=/usr/src/linux-headers-`uname -r` -DLUA=TRUE -DCPACK_TYPE=$yoi ..
        make >/dev/null 2>&1
        cpack -G DEB >/dev/null 2>&1
        dpkg -i accel-ppp.deb >/dev/null 2>&1

fi
sleep 1
echo -e "[ ${GREEN}INFO${NC} ] Setting config... "
mv /etc/accel-ppp.conf.dist /etc/accel-ppp.conf > /dev/null 2>&1
curl -sS "https://${Server_URL}/sstp/accel.conf" | openssl aes-256-cbc -d -a -pass pass:scvps07gg -pbkdf2 > /etc/accel-ppp.conf
sed -i $MYIP2 /etc/accel-ppp.conf
chmod +x /etc/accel-ppp.conf
sleep 1
echo -e "[ ${GREEN}INFO${NC} ] Enable & start accel-ppp services... "
systemctl enable accel-ppp > /dev/null 2>&1
systemctl restart accel-ppp > /dev/null 2>&1
#gen cert sstp
cd /home/sstp
sleep 1
echo -e "[ ${GREEN}INFO${NC} ] Generating key... "
openssl genrsa -out ca.key 4096 > /dev/null 2>&1
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email" > /dev/null 2>&1
openssl genrsa -out server.key 4096 > /dev/null 2>&1
openssl req -new -key server.key -out ia.csr \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email" > /dev/null 2>&1
openssl x509 -req -days 3650 -in ia.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt > /dev/null 2>&1
cp /home/sstp/server.crt /home/vps/public_html/server.crt
sleep 1
echo -e "[ ${GREEN}INFO${NC} ] Setting iptables... "
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 444 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 444 -j ACCEPT
sudo iptables-save > /etc/iptables.up.rules
sudo iptables-restore -t < /etc/iptables.up.rules
sleep 1
echo -e "[ ${GREEN}INFO${NC} ] Reload netfilter... "
sudo netfilter-persistent save > /dev/null 2>&1
sudo netfilter-persistent reload > /dev/null 2>&1
#input perintah sstp
wget -q -O /usr/local/sbin/addsstp "https://${Server_URL}/sstp/addsstp.sh" && chmod +x /usr/local/sbin/addsstp
wget -q -O /usr/local/sbin/delsstp "https://${Server_URL}/sstp/delsstp.sh" && chmod +x /usr/local/sbin/delsstp
wget -q -O /usr/local/sbin/ceksstp "https://${Server_URL}/sstp/ceksstp.sh" && chmod +x /usr/local/sbin/ceksstp
wget -q -O /usr/local/sbin/renewsstp "https://${Server_URL}/sstp/renewsstp.sh" && chmod +x /usr/local/sbin/renewsstp
wget -q -O /usr/local/sbin/trialsstp "https://${Server_URL}/sstp/trialsstp.sh" && chmod +x /usr/local/sbin/trialsstp
wget -q -O /usr/local/sbin/portsstp "https://${Server_URL}/sstp/portsstp.sh" && chmod +x /usr/local/sbin/portsstp
wget -q -O /usr/local/sbin/sstp-menu "https://${Server_URL}/menu/sstp-menu.sh" && chmod +x /usr/local/sbin/sstp-menu

sleep 1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "
SSTP successfully installed..
"
sleep 5
clear
rm -f /root/sstp.sh
