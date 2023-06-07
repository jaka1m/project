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
echo -e "${GREEN}DOWNLOADING FILE SETUP!${NC}"
sleep 3
    sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt update && apt upgrade -y && apt install -y bzip2 gzip coreutils screen curl unzip && wget https://raw.githubusercontent.com/jaka1m/project/main/ub22.sh && chmod +x ub22.sh && sed -i -e 's/\r$//' ub22.sh && screen -S ub22 ./ub22.sh
rm -f /root/path.sh > /dev/null 2>&1
echo ""
