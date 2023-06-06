#!/bin/bash
### Color
Green="\e[92;1m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[36m"
FONT="\033[0m"
GREENBG="\033[42;37m"
REDBG="\033[41;37m"
OK="${Green}--->${FONT}"
ERROR="${RED}[ERROR]${FONT}"
GRAY="\e[1;30m"
NC='\e[0m'
red='\e[1;31m'
green='\e[0;32m'
# ===================
export GREEN='\033[0;32m'
export NC='\033[0m'
clear
echo ""
# // Setup
echo -e "${GREEN}UPDATE HAP!${NC}"
sleep 3


sudo apt install haproxy -y
sudo apt purge haproxy -y
sudo add-apt-repository ppa:vbernat/haproxy-2.4 -y
sudo apt install haproxy=2.4.\* -y
rm /etc/haproxy/haproxy.cfg
wget -O /etc/haproxy/haproxy.cfg "https://raw.githubusercontent.com/jaka1m/project/main/xray/haproxy.cfg" >/dev/null 2>&1
cat /etc/xray/xray.crt /etc/xray/xray.key | tee /etc/haproxy/hap.pem

rm -f /root/up.sh > /dev/null 2>&1
reboot
echo ""
