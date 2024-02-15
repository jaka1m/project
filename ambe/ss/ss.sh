#!/bin/bash
#shadowsocks-libev obfs 
# Link Hosting Kalian
geovpn="jaka1m.github.io/project/ambe/ss"
clear
source /etc/os-release
OS=$ID
ver=$VERSION_ID
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
NC='\e[0m'
date
echo ""
sleep 1
echo -e "[ ${green}INFO${NC} ] Checking... "

pkgs='build-essential autoconf libtool libssl-dev libpcre3-dev libev-dev asciidoc xmlto automake'
if ! dpkg -s $pkgs > /dev/null 2>&1; then
   sleep 1
   echo -e "[ ${green}INFO${NC} ] Common pkgs not installed... "
   sleep 3
   echo -e "[ ${green}INFO${NC} ] Installing common pkgs... "
   apt-get install --no-install-recommends $pkgs -y > /dev/null 2>&1
fi

pkgscommon='software-properties-common'
if ! dpkg -s $pkgscommon > /dev/null 2>&1; then
   apt-get install $pkgscommon -y > /dev/null 2>&1
fi

if [[ $OS == 'ubuntu' ]]; then
sleep 1
echo -e "[ ${green}INFO${NC} ] Ubuntu detected... "
sleep 1
echo -e "[ ${green}INFO${NC} ] Installing shadowsocks $OS... "
apt install shadowsocks-libev -y > /dev/null 2>&1
apt install simple-obfs -y > /dev/null 2>&1
elif [[ $OS == 'debian' ]]; then
if [[ "$ver" = "9" ]]; then
sleep 1
echo -e "[ ${green}INFO${NC} ] Debian ver 9 detected... "
sleep 1
echo -e "[ ${green}INFO${NC} ] Installing shadowsocks for $OS $ver ... "

if [ -f "/etc/apt/sources.list.d/buster-backports.list" ]; then
detect=( `cat /etc/apt/sources.list.d/buster-backports.list | grep -ow "stretch-backports"` )
if [ "$detect" != "stretch-backports" ]; then
touch /etc/apt/sources.list.d/stretch-backports.list
echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list.d/stretch-backports.list
fi
else
touch /etc/apt/sources.list.d/stretch-backports.list
echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list.d/stretch-backports.list
fi

apt update -y > /dev/null 2>&1
apt -t stretch-backports install shadowsocks-libev -y > /dev/null 2>&1
apt -t stretch-backports install simple-obfs -y > /dev/null 2>&1
elif [[ "$ver" = "10" ]]; then
sleep 1
echo -e "[ ${green}INFO${NC} ] Debian ver 10 detected... "
sleep 1
echo -e "[ ${green}INFO${NC} ] Installing shadowsocks for $OS $ver ... "

if [ -f "/etc/apt/sources.list.d/buster-backports.list" ]; then
detect=( `cat /etc/apt/sources.list.d/buster-backports.list | grep -ow "buster-backports"` )
if [ "$detect" != "buster-backports" ]; then
touch /etc/apt/sources.list.d/buster-backports.list
echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list.d/buster-backports.list
fi
else
touch /etc/apt/sources.list.d/buster-backports.list
echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list.d/buster-backports.list
fi

apt update -y  > /dev/null 2>&1
apt -t buster-backports install shadowsocks-libev -y > /dev/null 2>&1
apt -t buster-backports install simple-obfs -y > /dev/null 2>&1
fi
fi

#Server konfigurasi
sleep 1
echo -e "[ ${green}INFO${NC} ] Creating config shadowsocks..."
cat > /etc/shadowsocks-libev/config.json <<END
{   
    "server":"0.0.0.0",
    "server_port":8488,
    "password":"tes",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
}
END

#mulai ~shadowsocks-libev~ server
sleep 1
echo -e "[ ${green}INFO${NC} ] Enable service on boot..."
systemctl enable shadowsocks-libev.service > /dev/null 2>&1
sleep 1
echo -e "[ ${green}INFO${NC} ] Start service shadowsocks..."
systemctl start shadowsocks-libev.service > /dev/null 2>&1

#buat client config
cat > /etc/shadowsocks-libev.json <<END
{
    "server":"127.0.0.1",
    "server_port":8388,
    "local_port":1080,
    "password":"",
    "timeout":60,
    "method":"chacha20-ietf-poly1305",
    "mode":"tcp_and_udp",
    "fast_open":true,
    "plugin":"/usr/bin/obfs-local",
    "plugin_opts":"obfs=tls;failover=127.0.0.1:1443;fast-open"
}
END
chmod +x /etc/shadowsocks-libev.json

echo -e "">>"/etc/shadowsocks-libev/akun.conf"

sleep 1
echo -e "[ ${green}INFO${NC} ] Set iptables..."
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 2443:3543 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 2443:3543 -j ACCEPT
sudo iptables-save > /etc/iptables.up.rules
sudo ip6tables-save > /etc/ip6tables.up.rules

wget -q -O /usr/local/sbin/addss "https://${geovpn}/addss.sh" && chmod +x /usr/local/sbin/addss
wget -q -O /usr/local/sbin/delss "https://${geovpn}/delss.sh" && chmod +x /usr/local/sbin/delss
wget -q -O /usr/local/sbin/cekss "https://${geovpn}/cekss.sh" && chmod +x /usr/local/sbin/cekss
wget -q -O /usr/local/sbin/renewss "https://${geovpn}/renewss.sh" && chmod +x /usr/local/sbin/renewss
wget -q -O /usr/local/sbin/ss-menu "https://jaka1m.github.io/project/ambe/menu/ss-menu.sh" && chmod +x /usr/local/sbin/ss-menu
sleep 1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "Shadowsock OBFS successfully installed.."
sleep 5
clear
rm -f /root/sss.sh
