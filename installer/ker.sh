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
echo -e "${GREEN}UPDATE FILE KERNEL!${NC}"
sleep 3
sudo apt update
sudo apt upgrade -y
sudo apt install wget -y
wget https://raw.githubusercontent.com/pimlie/ubuntu-mainline-kernel.sh/master/ubuntu-mainline-kernel.sh
chmod +x ubuntu-mainline-kernel.sh
sudo mv ubuntu-mainline-kernel.sh /usr/local/bin/
ubuntu-mainline-kernel.sh -c
ubuntu-mainline-kernel.sh -r
sudo ubuntu-mainline-kernel.sh -i v5.19.1
sudo ubuntu-mainline-kernel.sh -i
sudo ubuntu-mainline-kernel.sh -l
rm -f /root/ker.sh > /dev/null 2>&1
sudo apt install haproxy -y
reboot
echo ""
