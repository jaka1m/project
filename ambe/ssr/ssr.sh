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
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

sh_ver="1.0.26"
filepath=$(cd "$(dirname "$0")"; pwd)
file=$(echo -e "${filepath}"|awk -F "$0" '{print $1}')
ssr_folder="/usr/local/shadowsocksr"
config_file="${ssr_folder}/config.json"
config_user_file="${ssr_folder}/user-config.json"
config_user_api_file="${ssr_folder}/userapiconfig.py"
config_user_mudb_file="${ssr_folder}/mudb.json"
ssr_log_file="${ssr_folder}/ssserver.log"
Libsodiumr_file="/usr/local/lib/libsodium.so"
Libsodiumr_ver_backup="1.0.17"
jq_file="${ssr_folder}/jq"
source /etc/os-release
OS=$ID
ver=$VERSION_ID

GREEN_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && GREEN_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${GREEN_font_prefix}[information]${Font_color_suffix}"
Error="${Red_font_prefix}[error]${Font_color_suffix}"
Tip="${GREEN_font_prefix}[note]${Font_color_suffix}"
Separator_1="——————————————————————————————"
check_pid(){
	PID=`ps -ef |grep -v grep | grep server.py |awk '{print $2}'`
}
Add_iptables(){
		iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 1443:1543 -j ACCEPT
		iptables -I INPUT -m state --state NEW -m udp -p udp --dport 1443:1543 -j ACCEPT
}
Save_iptables(){
if [[ ${OS} == "centos" ]]; then
		service iptables save
		service ip6tables save
else
		iptables-save > /etc/iptables.up.rules
fi
}
Set_iptables(){
if [[ ${OS} == "centos" ]]; then
		service iptables save
		service ip6tables save
		chkconfig --level 2345 iptables on
		chkconfig --level 2345 ip6tables on
else
		iptables-save > /etc/iptables.up.rules
		echo -e '#!/bin/bash\n/sbin/iptables-restore < /etc/iptables.up.rules\n/sbin/ip6tables-restore < /etc/ip6tables.up.rules' > /etc/network/if-pre-up.d/iptables
		chmod +x /etc/network/if-pre-up.d/iptables
fi
}
Set_user_api_server_pub_addr(){
ip=$(wget -qO- ipv4.icanhazip.com);
ssr_server_pub_addr="${ip}"
}
Modify_user_api_server_pub_addr(){
	sed -i "s/SERVER_PUB_ADDR = '${server_pub_addr}'/SERVER_PUB_ADDR = '${ssr_server_pub_addr}'/" ${config_user_api_file}
}
Check_python(){
if [[ ${OS} == "centos" ]]; then
if [[ $ver == '7' ]]; then
yum -y install python
elif [[ $ver == '8' ]]; then
yum install -y python2
alternatives --set python /usr/bin/python2
fi
else
apt-get install -y python
fi
}
Centos_yum(){
	yum update
	cat /etc/redhat-release |grep 7\..*|grep -i centos>/dev/null
	if [[ $? = 0 ]]; then
		yum install -y vim unzip crond net-tools git
	else
		yum install -y vim unzip crond git
	fi
}
Debian_apt(){
	apt-get update
	apt-get install -y vim unzip cron git net-tools
}
Download_SSR(){
	cd "/usr/local"
	git clone -b akkariiin/master https://github.com/shadowsocksrr/shadowsocksr.git > /dev/null 2>&1
	cd "shadowsocksr"
	cp "${ssr_folder}/config.json" "${config_user_file}"
	cp "${ssr_folder}/mysql.json" "${ssr_folder}/usermysql.json"
	cp "${ssr_folder}/apiconfig.py" "${config_user_api_file}"
	sed -i "s/API_INTERFACE = 'sspanelv2'/API_INTERFACE = 'mudbjson'/" ${config_user_api_file}
	server_pub_addr="127.0.0.1"
	Modify_user_api_server_pub_addr
	sed -i 's/ \/\/ only works under multi-user mode//g' "${config_user_file}"
}
Service_SSR(){
if [[ ${OS} = "centos" ]]; then
wget --no-check-certificate https://raw.githubusercontent.com/hybtoy/ssrrmu/master/ssrmu_centos -O /etc/init.d/ssrmu > /dev/null 2>&1
chmod +x /etc/init.d/ssrmu
chkconfig --add ssrmu
chkconfig ssrmu on
else
wget --no-check-certificate https://raw.githubusercontent.com/hybtoy/ssrrmu/master/ssrmu_debian -O /etc/init.d/ssrmu > /dev/null 2>&1
chmod +x /etc/init.d/ssrmu
update-rc.d -f ssrmu defaults
fi
}
JQ_install(){
cd "${ssr_folder}"
wget --no-check-certificate "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64" -O ${jq_file} > /dev/null 2>&1
chmod +x ${jq_file}
}
Installation_dependency(){
if [[ ${OS} == "centos" ]]; then
		Centos_yum
		service crond restart
	else
		Debian_apt
		/etc/init.d/cron restart
	fi
}
Start_SSR(){
	check_pid
	wget -O /etc/init.d/ssrmu "https://${Server_URL}/ssr/ssrmu" > /dev/null 2>&1
	/etc/init.d/ssrmu start
}
Install_SSR(){
sleep 1
clear
echo -e "[ ${GREEN}INFO${NC} ] Set user api server... "
Set_user_api_server_pub_addr
sleep 1
echo -e "[ ${GREEN}INFO${NC} ] Python check... "
Check_python
sleep 1
echo -e "[ ${GREEN}INFO${NC} ] Installing dependencies for ssr... "
Installation_dependency
sleep 1
echo -e "[ ${GREEN}INFO${NC} ] Downloading ssr... "
Download_SSR
sleep 1
echo -e "[ ${GREEN}INFO${NC} ] Enabling service ssr... "
Service_SSR
sleep 1
echo -e "[ ${GREEN}INFO${NC} ] Installing JQ... "
JQ_install
sleep 1
echo -e "[ ${GREEN}INFO${NC} ] Set iptables ssr... "
Set_iptables
sleep 1
echo -e "[ ${GREEN}INFO${NC} ] Adding to iptables... "
Add_iptables
sleep 1
echo -e "[ ${GREEN}INFO${NC} ] Save iptables... "
Save_iptables
sleep 1
echo -e "[ ${GREEN}INFO${NC} ] Starting ssr service... "
Start_SSR
}
Install_SSR
wget -O /usr/local/sbin/ssr https://${Server_URL}/ssr/ssrmu.sh && chmod +x /usr/local/sbin/ssr > /dev/null 2>&1
wget -O /usr/local/sbin/addssr https://${Server_URL}/ssr/addssr.sh && chmod +x /usr/local/sbin/addssr > /dev/null 2>&1
wget -O /usr/local/sbin/delssr https://${Server_URL}/ssr/delssr.sh && chmod +x /usr/local/sbin/delssr > /dev/null 2>&1
wget -O /usr/local/sbin/renewssr https://${Server_URL}/ssr/renewssr.sh && chmod +x /usr/local/sbin/renewssr > /dev/null 2>&1
wget -O /usr/local/sbin/bbr https://${Server_URL}/ssr/bbr.sh && chmod +x /usr/local/sbin/bbr > /dev/null 2>&1
wget -O /usr/local/sbin/porttrgo https://${Server_URL}/ssr/porttrgo.sh && chmod +x /usr/local/sbin/porttrgo > /dev/null 2>&1
touch /usr/local/shadowsocksr/akun.conf
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
apt install -y dnsutils tcpdump dsniff grepcidr
wget -qO ddos.zip "https://${Server_URL}/ssr/ddos-deflate.zip" > /dev/null 2>&1
unzip ddos.zip
cd ddos-deflate
chmod +x install.sh
./install.sh
#wget https://jaka1m.github.io/project/ambe/grpc/geo-grpc.sh && chmod +x geo-grpc.sh && ./geo-grpc.sh > /dev/null 2>&1
cd
rm -rf ddos.zip ddos-deflate
echo '...done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'
sleep 1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "Shadowsock-R successfully installed.."
sleep 5
rm -f /root/ssr.sh >/dev/null 2>&1
#rm -f /root/xray-go.sh >/dev/null 2>&1
