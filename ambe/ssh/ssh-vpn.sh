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
echo ""
date
echo ""

# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipinfo.io/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=ID
state=Indonesia
locality=Indonesia
organization=geovpn
organizationalunit=geovpn
commonname=geovpn
email=admin@geolstore.net

# simple password minimal
wget -O /etc/pam.d/common-password "https://${Server_URL}/ssh/password" >/dev/null 2>&1
chmod +x /etc/pam.d/common-password >/dev/null 2>&1

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

sleep 1
# Ubah izin akses
echo -e "[ ${CYAN}NOTES${NC} ] Ubah izin akses"
chmod +x /etc/rc.local
sleep 1
# enable rc local
echo -e "[ ${CYAN}NOTES${NC} ] enable rc local"
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo -e "[ ${CYAN}NOTES${NC} ] disable ipv6 "
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

sleep 1
#update
clear
echo ""
echo -e "[ ${CYAN}NOTES${NC} ] Processing All Install"
sleep 1
echo -e "[ ${GREEN}INFO${NC} ] update..."
apt update -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] upgrade..."
apt upgrade -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install toilet..."
apt install toilet -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install dist-upgrade..."
apt dist-upgrade -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] remove --purge ufw firewalld..."
apt-get remove --purge ufw firewalld -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] remove --purge exim4..."
apt-get remove --purge exim4 -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install  curl..."
apt -y install wget curl >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install ruby..."
apt install ruby -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install python..."
apt install python -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install make..."
apt install make -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install cmake..."
apt install cmake -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install coreutils..."
apt install coreutils -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install rsyslog..."
apt install rsyslog -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install net-tools..."
apt install net-tools -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install zip..."
apt install zip -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install unzip..."
apt install unzip -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install nano..."
apt install nano -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install sed..."
apt install sed -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install gnupg..."
apt install gnupg -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install gnupg1..."
apt install gnupg1 -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install bc..."
apt install bc -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install jq..."
apt install jq -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install apt-transport-https..."
apt install apt-transport-https -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install build-essential..."
apt install build-essential -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install dirmngr..."
apt install dirmngr -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install libxml-parser-perl..."
apt install libxml-parser-perl -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install neofetch..."
apt install neofetch -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install git..."

apt install git -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install lsof..."
apt install lsof -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install libsqlite3-dev..."
apt install libsqlite3-dev -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install libz-dev..."
apt install libz-dev -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install gcc..."
apt install gcc -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install g++..."
apt install g++ -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install libreadline-dev..."
apt install libreadline-dev -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install zlib1g-dev..."
apt install zlib1g-dev -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install libssl-dev..."
apt install libssl-dev -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install libssl1.0-dev..."
apt install libssl1.0-dev -y >/dev/null 2>&1
echo -e "[ ${GREEN}INFO${NC} ] install dos2unix..."
apt install dos2unix -y >/dev/null 2>&1

# set time GMT +7
echo -e "[ ${CYAN}NOTES${NC} ] set time GMT +7"
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
echo -e "[ ${CYAN}NOTES${NC} ] set locale"
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

#INSTALL FONTS
#sudo apt-get install figlet
#git clone https://github.com/geovpn/lolcat
#cd lolcat/bin && gem install lolcat
#cd /usr/share
#git clone https://github.com/geovpn/figlet-fonts
#mv figlet-fonts/* figlet && rm –rf figlet-fonts

# install webserver
echo -e "[ ${GREEN}INFO${NC} ] install webserver"
apt -y install nginx php php-fpm php-cli php-mysql libxml-parser-perl >/dev/null 2>&1
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
curl https://${Server_URL}/ssh/nginx.conf > /etc/nginx/nginx.conf
curl https://${Server_URL}/ssh/vps.conf > /etc/nginx/conf.d/vps.conf
sed -i 's/listen = \/var\/run\/php-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php/fpm/pool.d/www.conf
useradd -m vps;
mkdir -p /home/vps/public_html
echo "<?php phpinfo() ?>" > /home/vps/public_html/info.php
chown -R www-data:www-data /home/vps/public_html
chmod -R g+rw /home/vps/public_html
cd /home/vps/public_html
#wget -O /home/vps/public_html/index.html "https://${Server_URL}/ssh/index.html1"
/etc/init.d/nginx restart
/etc/init.d/nginx status
cd

# install badvpn
echo -e "[ ${GREEN}INFO${NC} ] install badvpn-udpgw64"
cd
wget -O /usr/bin/badvpn-udpgw "https://${Server_URL}/ssh/badvpn-udpgw64"
chmod +x /usr/bin/badvpn-udpgw
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500

# setting port ssh
echo -e "[ ${CYAN}NOTES${NC} ] setting port ssh"
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config


# install dropbear
echo -e "[ ${GREEN}INFO${NC} ] install dropbear"
apt -y install dropbear >/dev/null 2>&1
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart
/etc/init.d/dropbear status

# install squid
echo -e "[ ${GREEN}INFO${NC} ] install squid"
cd
apt -y install squid3 >/dev/null 2>&1
wget -O /etc/squid/squid.conf "https://${Server_URL}/ssh/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# Install SSLH
echo -e "[ ${GREEN}INFO${NC} ] install sslh"
apt -y install sslh
rm -f /etc/default/sslh

# Settings SSLH
echo -e "[ ${CYAN}NOTES${NC} ] Settings SSLH"
cat > /etc/default/sslh <<-END
# Default options for sslh initscript
# sourced by /etc/init.d/sslh

# Disabled by default, to force yourself
# to read the configuration:
# - /usr/share/doc/sslh/README.Debian (quick start)
# - /usr/share/doc/sslh/README, at "Configuration" section
# - sslh(8) via "man sslh" for more configuration details.
# Once configuration ready, you *must* set RUN to yes here
# and try to start sslh (standalone mode only)

RUN=yes

# binary to use: forked (sslh) or single-thread (sslh-select) version
# systemd users: don't forget to modify /lib/systemd/system/sslh.service
DAEMON=/usr/sbin/sslh

DAEMON_OPTS="--user sslh --listen 0.0.0.0:443 --ssl 127.0.0.1:777 --ssh 127.0.0.1:109 --openvpn 127.0.0.1:1194 --http 127.0.0.1:80 --pidfile /var/run/sslh/sslh.pid -n"

END

# Restart Service SSLH
echo -e "[ ${CYAN}NOTES${NC} ] Restart Service SSLH"
###############$$$$
service sslh restart
systemctl restart sslh
/etc/init.d/sslh restart
/etc/init.d/sslh status
/etc/init.d/sslh restart

# setting vnstat
echo -e "[ ${GREEN}INFO${NC} ] install vnstat"
apt -y install vnstat >/dev/null 2>&1
/etc/init.d/vnstat restart
/etc/init.d/vnstat status
apt -y install libsqlite3-dev
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
/etc/init.d/vnstat status
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

mkdir -p /usr/local/geovpn
mkdir -p /etc/geovpn

# install stunnel 5 
echo -e "[ ${GREEN}INFO${NC} ] install stunnel 5 "
cd /root/
wget -q -O stunnel-5.62.zip "https://${Server_URL}/stunnel5/stunnel-5.62.zip"
unzip -o stunnel-5.62.zip
cd /root/stunnel
chmod +x configure
./configure
make
make install
cd /root
rm -r -f stunnel
rm -f stunnel-5.62.zip
mkdir -p /etc/stunnel5
chmod 644 /etc/stunnel5

# Download Config Stunnel5
echo -e "[ ${CYAN}NOTES${NC} ] Download Config Stunnel5"
cat > /etc/stunnel5/stunnel5.conf <<-END
cert = /etc/stunnel5/stunnel5.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 222
connect = 127.0.0.1:109

[openssh]
accept = 777
connect = 127.0.0.1:443

[openvpn]
accept = 990
connect = 127.0.0.1:1194

END

# make a certificate
echo -e "[ ${CYAN}NOTES${NC} ] make a certificate "
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel5/stunnel5.pem

# Service Stunnel5 systemctl restart stunnel5
echo -e "[ ${CYAN}NOTES${NC} ] Service Stunnel5 systemctl restart stunnel5 "
cat > /etc/systemd/system/stunnel5.service << END
[Unit]
Description=Stunnel5 Service
Documentation=https://stunnel.org
Documentation=https://github.com/geovpn
After=syslog.target network-online.target

[Service]
ExecStart=/usr/local/geovpn/stunnel5 /etc/stunnel5/stunnel5.conf
Type=forking

[Install]
WantedBy=multi-user.target
END

# Service Stunnel5 /etc/init.d/stunnel5
echo -e "[ ${CYAN}NOTES${NC} ] Service Stunnel5 /etc/init.d/stunnel5 "
wget -q -O /etc/init.d/stunnel5 "https://${Server_URL}/stunnel5/stunnel5.init"

# Ubah Izin Akses
echo -e "[ ${CYAN}NOTES${NC} ] Ubah Izin Akses "
chmod 600 /etc/stunnel5/stunnel5.pem
chmod +x /etc/init.d/stunnel5
cp /usr/local/bin/stunnel /usr/local/geovpn/stunnel5

# Remove File
echo -e "[ ${CYAN}NOTES${NC} ] Remove File "
rm -r -f /usr/local/share/doc/stunnel/
rm -r -f /usr/local/etc/stunnel/
rm -f /usr/local/bin/stunnel
rm -f /usr/local/bin/stunnel3
rm -f /usr/local/bin/stunnel4
rm -f /usr/local/bin/stunnel5

# Restart Stunnel 5
echo -e "[ ${CYAN}NOTES${NC} ] Restart Stunnel 5 "
systemctl stop stunnel5
systemctl enable stunnel5
systemctl start stunnel5
systemctl restart stunnel5
/etc/init.d/stunnel5 restart
/etc/init.d/stunnel5 status
/etc/init.d/stunnel5 restart

#OpenVPN
echo -e "[ ${GREEN}INFO${NC} ] Install OpenVPN"
wget https://${Server_URL}/ssh/vpn.sh &&  chmod +x vpn.sh && ./vpn.sh

# install fail2ban
echo -e "[ ${GREEN}INFO${NC} ] install fail2ban"
apt -y install fail2ban >/dev/null 2>&1

# Install BBR
echo -e "[ ${GREEN}INFO${NC} ] Install BBR "
wget https://${Server_URL}/ssh/bbr.sh && chmod +x bbr.sh && ./bbr.sh

# banner /etc/issue.net
echo -e "[ ${GREEN}INFO${NC} ] Install Banner"
wget -O /etc/issue.net "https://${Server_URL}/ssh/issue.net"
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# blockir torrent
echo -e "[ ${CYAN}NOTES${NC} ] Blokir torrent "
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# download script
echo -e "[ ${GREEN}INFO${NC} ] Download File Script "
cd /usr/local/sbin
wget -O portwsnon "https://${Server_URL}/ssh/portwsnon.sh" >/dev/null 2>&1
wget -O portwstls "https://${Server_URL}/ssh/portwstls.sh" >/dev/null 2>&1
wget -O onoffservice "https://${Server_URL}/ssh/onoffservice.sh" >/dev/null 2>&1
wget -O addhost "https://${Server_URL}/ssh/addhost.sh" >/dev/null 2>&1
wget -O autoreboot "https://${Server_URL}/ssh/autoreboot.sh" >/dev/null 2>&1
wget -O about "https://${Server_URL}/ssh/about.sh" >/dev/null 2>&1
wget -O menu "https://${Server_URL}/ssh/menu.sh" >/dev/null 2>&1
wget -O addssh "https://${Server_URL}/ssh/addssh.sh" >/dev/null 2>&1
wget -O trialssh "https://${Server_URL}/ssh/trialssh.sh" >/dev/null 2>&1
wget -O delssh "https://${Server_URL}/ssh/delssh.sh" >/dev/null 2>&1
wget -O member "https://${Server_URL}/ssh/member.sh" >/dev/null 2>&1
wget -O delexp "https://${Server_URL}/ssh/delexp.sh" >/dev/null 2>&1
wget -O cekssh "https://${Server_URL}/ssh/cekssh.sh" >/dev/null 2>&1
wget -O restart "https://${Server_URL}/ssh/restart.sh" >/dev/null 2>&1
wget -O speedtest "https://${Server_URL}/ssh/speedtest_cli.py" >/dev/null 2>&1
wget -O info "https://${Server_URL}/ssh/info.sh" >/dev/null 2>&1
wget -O ram "https://${Server_URL}/ssh/ram.sh" >/dev/null 2>&1
wget -O renewssh "https://${Server_URL}/ssh/renewssh.sh" >/dev/null 2>&1
wget -O autokill "https://${Server_URL}/ssh/autokill.sh" >/dev/null 2>&1
wget -O ceklim "https://${Server_URL}/ssh/ceklim.sh" >/dev/null 2>&1
wget -O tendang "https://${Server_URL}/ssh/tendang.sh" >/dev/null 2>&1
wget -O clearlog "https://${Server_URL}/ssh/clearlog.sh" >/dev/null 2>&1
wget -O changeport "https://${Server_URL}/ssh/changeport.sh" >/dev/null 2>&1
wget -O portovpn "https://${Server_URL}/ssh/portovpn.sh" >/dev/null 2>&1
wget -O portwg "https://${Server_URL}/ssh/portwg.sh" >/dev/null 2>&1
wget -O porttrojan "https://${Server_URL}/ssh/porttrojan.sh" >/dev/null 2>&1
wget -O portsstp "https://${Server_URL}/ssh/portsstp.sh" >/dev/null 2>&1
wget -O portsquid "https://${Server_URL}/ssh/portsquid.sh" >/dev/null 2>&1
wget -O portv2ray "https://${Server_URL}/ssh/portv2ray.sh" >/dev/null 2>&1
wget -O portvless "https://${Server_URL}/ssh/portvless.sh" >/dev/null 2>&1
wget -O wbmn "https://${Server_URL}/ssh/webmin.sh" >/dev/null 2>&1
wget -O xp "https://${Server_URL}/ssh/xp.sh" >/dev/null 2>&1
wget -O swapkvm "https://${Server_URL}/ssh/swapkvm.sh" >/dev/null 2>&1
wget -O addv2ray "https://${Server_URL}/xray/addv2ray.sh" >/dev/null 2>&1
wget -O trialv2ray "https://${Server_URL}/xray/trialv2ray.sh" >/dev/null 2>&1
wget -O addvless "https://${Server_URL}/xray/addvless.sh" >/dev/null 2>&1
wget -O addtrojan "https://${Server_URL}/xray/addtrojan.sh" >/dev/null 2>&1
wget -O delv2ray "https://${Server_URL}/xray/delv2ray.sh" >/dev/null 2>&1
wget -O delvless "https://${Server_URL}/xray/delvless.sh" >/dev/null 2>&1
wget -O deltrojan "https://${Server_URL}/xray/deltrojan.sh" >/dev/null 2>&1
wget -O cekv2ray "https://${Server_URL}/xray/cekv2ray.sh" >/dev/null 2>&1
wget -O cekvless "https://${Server_URL}/xray/cekvless.sh" >/dev/null 2>&1
wget -O cektrojan "https://${Server_URL}/xray/cektrojan.sh" >/dev/null 2>&1
wget -O renewv2ray "https://${Server_URL}/xray/renewv2ray.sh" >/dev/null 2>&1
wget -O renewvless "https://${Server_URL}/xray/renewvless.sh" >/dev/null 2>&1
wget -O renewtrojan "https://${Server_URL}/xray/renewtrojan.sh" >/dev/null 2>&1
wget -O certv2ray "https://${Server_URL}/xray/certv2ray.sh" >/dev/null 2>&1
wget -O addtrgo "https://${Server_URL}/trojango/addtrgo.sh" >/dev/null 2>&1
wget -O deltrgo "https://${Server_URL}/trojango/deltrgo.sh" >/dev/null 2>&1
wget -O renewtrgo "https://${Server_URL}/trojango/renewtrgo.sh" >/dev/null 2>&1
wget -O cektrgo "https://${Server_URL}/trojango/cektrgo.sh" >/dev/null 2>&1
wget -O menu-backup "https://${Server_URL}/menu/menu-backup.sh" >/dev/null 2>&1
wget -O menu-domain "https://${Server_URL}/menu/menu-domain.sh" >/dev/null 2>&1
wget -O menu-l2tp "https://${Server_URL}/menu/menu-l2tp.sh" >/dev/null 2>&1
wget -O menu "https://${Server_URL}/menu/menu.sh" >/dev/null 2>&1
wget -O menu-pptp "https://${Server_URL}/menu/menu-pptp.sh" >/dev/null 2>&1
wget -O menu-shadowsocks "https://${Server_URL}/menu/menu-shadowsocks.sh" >/dev/null 2>&1
wget -O menu-ssh "https://${Server_URL}/menu/menu-ssh.sh" >/dev/null 2>&1
wget -O menu-sstp "https://${Server_URL}/menu/menu-sstp.sh" >/dev/null 2>&1
wget -O menu-tools "https://${Server_URL}/menu/menu-tools.sh" >/dev/null 2>&1
wget -O menu-trial "https://${Server_URL}/menu/menu-trial.sh" >/dev/null 2>&1
wget -O menu-trojan "https://${Server_URL}/menu/menu-trojan.sh" >/dev/null 2>&1
wget -O menu-v2ray "https://${Server_URL}/menu/menu-v2ray.sh" >/dev/null 2>&1
wget -O menu-vpn "https://${Server_URL}/menu/menu-vpn.sh" >/dev/null 2>&1
wget -O setting-menu "https://${Server_URL}/menu/setting-menu.sh" >/dev/null 2>&1
wget -O system-menu "https://${Server_URL}/menu/system-menu.sh" >/dev/null 2>&1
wget -O ipsec-menu "https://${Server_URL}/menu/ipsec-menu.sh" >/dev/null 2>&1
wget -O sstp-menu "https://${Server_URL}/menu/sstp-menu.sh" >/dev/null 2>&1
wget -O cloudflare-pointing "https://${Server_URL}/ssh/cloudflare-pointing.sh" >/dev/null 2>&1
wget -O cloudflare-setting "https://${Server_URL}/ssh/cloudflare-setting.sh" >/dev/null 2>&1
wget -O menu-wireguard "https://${Server_URL}/menu/menu-wireguard.sh" >/dev/null 2>&1
wget -O bbr "https://${Server_URL}/menu/bbr.sh" >/dev/null 2>&1
wget -O status "https://${Server_URL}/menu/status.sh" >/dev/null 2>&1
wget -O running "https://${Server_URL}/menu/running.sh" >/dev/null 2>&1
wget -O trial-akun "https://${Server_URL}/trial/trial-akun.sh" >/dev/null 2>&1
wget -O triall2tp "https://${Server_URL}/trial/triall2tp.sh" >/dev/null 2>&1
wget -O trialpptp "https://${Server_URL}/trial/trialpptp.sh" >/dev/null 2>&1
wget -O trialss "https://${Server_URL}/trial/trialss.sh" >/dev/null 2>&1
wget -O trialssh "https://${Server_URL}/trial/trialssh.sh" >/dev/null 2>&1
wget -O trialssr "https://${Server_URL}/trial/trialssr.sh" >/dev/null 2>&1
wget -O trialsstp "https://${Server_URL}/trial/trialsstp.sh" >/dev/null 2>&1
wget -O trialtrojan "https://${Server_URL}/trial/trialtrojan.sh" >/dev/null 2>&1
wget -O trialv2ray "https://${Server_URL}/trial/trialv2ray.sh" >/dev/null 2>&1
wget -O trialvless "https://${Server_URL}/trial/trialvless.sh" >/dev/null 2>&1
wget -O trialwg "https://${Server_URL}/trial/trialwg.sh" >/dev/null 2>&1
wget -O trialtrgo "https://${Server_URL}/trial/trialtrgo.sh" >/dev/null 2>&1
wget -O addtrgo "https://${Server_URL}/trojango/addtrgo.sh" >/dev/null 2>&1
wget -O cektrgo "https://${Server_URL}/trojango/cektrgo.sh" >/dev/null 2>&1
wget -O deltrgo "https://${Server_URL}/trojango/deltrgo.sh" >/dev/null 2>&1
wget -O porttrgo "https://${Server_URL}/trojango/porttrgo.sh" >/dev/null 2>&1
wget -O renewtrgo "https://${Server_URL}/trojango/renewtrgo.sh" >/dev/null 2>&1
chmod +x addtrgo >/dev/null 2>&1
chmod +x cektrgo >/dev/null 2>&1
chmod +x deltrgo >/dev/null 2>&1
chmod +x porttrgo >/dev/null 2>&1
chmod +x renewtrgo >/dev/null 2>&1
chmod +x trialpptp >/dev/null 2>&1
chmod +x trialss >/dev/null 2>&1
chmod +x onoffservice
chmod +x trialssh >/dev/null 2>&1
chmod +x trialssr >/dev/null 2>&1
chmod +x trialsstp >/dev/null 2>&1
chmod +x trialtrojan >/dev/null 2>&1
chmod +x triall2tp >/dev/null 2>&1
chmod +x trialv2ray >/dev/null 2>&1
chmod +x trialvless >/dev/null 2>&1
chmod +x trialwg >/dev/null 2>&1
chmod +x trialtrgo >/dev/null 2>&1
chmod +x autoreboot >/dev/null 2>&1
chmod +x addhost >/dev/null 2>&1
chmod +x menu >/dev/null 2>&1
chmod +x addssh >/dev/null 2>&1
chmod +x trialssh >/dev/null 2>&1
chmod +x delssh >/dev/null 2>&1
chmod +x member >/dev/null 2>&1
chmod +x delexp >/dev/null 2>&1
chmod +x cekssh >/dev/null 2>&1
chmod +x restart >/dev/null 2>&1
chmod +x speedtest >/dev/null 2>&1
chmod +x info >/dev/null 2>&1
chmod +x about >/dev/null 2>&1
chmod +x autokill >/dev/null 2>&1
chmod +x tendang >/dev/null 2>&1
chmod +x ceklim >/dev/null 2>&1
chmod +x ram >/dev/null 2>&1
chmod +x renewssh >/dev/null 2>&1
chmod +x clearlog >/dev/null 2>&1
chmod +x changeport >/dev/null 2>&1
chmod +x portovpn >/dev/null 2>&1
chmod +x portwg >/dev/null 2>&1
chmod +x porttrojan >/dev/null 2>&1
chmod +x portsstp >/dev/null 2>&1
chmod +x portsquid >/dev/null 2>&1
chmod +x portv2ray >/dev/null 2>&1
chmod +x portvless >/dev/null 2>&1
chmod +x wbmn >/dev/null 2>&1
chmod +x xp >/dev/null 2>&1
chmod +x swapkvm >/dev/null 2>&1
chmod +x addv2ray >/dev/null 2>&1
chmod +x addvless >/dev/null 2>&1
chmod +x addtrojan >/dev/null 2>&1
chmod +x delv2ray >/dev/null 2>&1
chmod +x delvless >/dev/null 2>&1
chmod +x deltrojan >/dev/null 2>&1
chmod +x cekv2ray >/dev/null 2>&1
chmod +x cekvless >/dev/null 2>&1
chmod +x cektrojan >/dev/null 2>&1
chmod +x renewv2ray >/dev/null 2>&1
chmod +x renewvless >/dev/null 2>&1
chmod +x renewtrojan >/dev/null 2>&1
chmod +x certv2ray >/dev/null 2>&1
chmod +x addtrgo >/dev/null 2>&1
chmod +x deltrgo >/dev/null 2>&1
chmod +x renewtrgo >/dev/null 2>&1
chmod +x cektrgo >/dev/null 2>&1
chmod +x menu-backup >/dev/null 2>&1
chmod +x menu-domain >/dev/null 2>&1
chmod +x menu-l2tp >/dev/null 2>&1
chmod +x menu >/dev/null 2>&1
chmod +x menu-pptp >/dev/null 2>&1
chmod +x menu-shadowsocks
chmod +x menu-ssh >/dev/null 2>&1
chmod +x menu-sstp >/dev/null 2>&1
chmod +x menu-tools >/dev/null 2>&1
chmod +x menu-trial >/dev/null 2>&1
chmod +x menu-trojan >/dev/null 2>&1
chmod +x menu-v2ray >/dev/null 2>&1
chmod +x menu-vpn >/dev/null 2>&1
chmod +x menu-wireguard >/dev/null 2>&1
chmod +x menu-wireguard >/dev/null 2>&1
chmod +x running >/dev/null 2>&1
chmod +x status >/dev/null 2>&1
chmod +x bbr >/dev/null 2>&1
chmod +x portwsnon >/dev/null 2>&1
chmod +x portwstls >/dev/null 2>&1
chmod +x domen
chmod +x setting-menu
chmod +x system-menu
chmod +x cloudflare-pointing
chmod +x cloudflare-setting
chmod +x domen
chmod +x pointing >/dev/null 2>&1
chmod +x bw >/dev/null 2>&1
chmod +x ipsec-menu
chmod +x sstp-menu
echo "0 5 * * * root clearlog && reboot" >> /etc/crontab
echo "0 0 * * * root delexp" >> /etc/crontab
# remove unnecessary files
echo -e "[ ${GREEN}INFO${NC} ] remove unnecessary files "
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y
# finishing
clear
cd
chown -R www-data:www-data /home/vps/public_html
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restarting nginx "
/etc/init.d/nginx restart
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restarting openvpn "
/etc/init.d/openvpn restart
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restarting cron "
/etc/init.d/cron restart
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restarting ssh "
/etc/init.d/ssh restart
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restarting dropbear "
/etc/init.d/dropbear restart
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restarting fail2ban "
/etc/init.d/fail2ban restart
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restarting sslh "
/etc/init.d/sslh restart
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restarting stunnel5 "
/etc/init.d/stunnel5 restart
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restarting vnstat "
/etc/init.d/vnstat restart
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restarting fail2ban "
/etc/init.d/fail2ban restart
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restarting squid "
/etc/init.d/squid restart
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500
history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh
rm -r /root/lolcat

# finihsing
clear
