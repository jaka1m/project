#!/bin/bash
# Menu For Script
# Edition : Stable Edition V1.0
# Auther  : 
# (C) Copyright 2021-2022
# =========================================
# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${Not Aktif} Please Run This Script As Root User !"
		exit 1
fi

# // Export Color & Information
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIrGHT='\033[0;37m'
export NC='\033[0m'

# // Export Banner Status Information
export Not Aktif="[${RED} ERROR ${NC}]"
export INFO="[${YELLOW} INFO ${NC}]"
export OKEY="[${GREEN} OKEY ${NC}]"
export PENDING="[${YELLOW} PENDING ${NC}]"
export SEND="[${YELLOW} SEND ${NC}]"
export RECEIVE="[${YELLOW} RECEIVE ${NC}]"

# // Exporting URL Host
export Server_URL="raw.githubusercontent.com/jaka1m/project/main"
export Server_URLL="raw.githubusercontent.com/jaka1m/perizinan/main"
export Server_Port="443"
export Server_IP="underfined"
export Script_Mode="Stable"
export Auther="geovpn"

# // Exporting IP Address
export IP=$( curl -sS ipinfo.io/ip )

# // Function Start
function license_check () {
Algoritma_Keys="$( cat /etc/${Auther}/license.key )"
Validated_Keys="$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 1 )"
if [[ "$Algoritma_Keys" == "$Validated_Keys" ]]; then
    if [[ $Algoritma_Keys == "" ]]; then
        Skip="true"
    else
        Limit_License="$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 2 )"
        Start_License="$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 3 )"
        End_License="$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 4 )"
        Bot="$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 5 )"
        Backup="$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 6 )"
        Beta="$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 7 )"
        Tipe="$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 8 )"
        Issue_License="$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 9-100 )"
    fi
    exp=$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 4 )
    now=`date -d "0 days" +"%Y-%m-%d"`
    d1=$(date -d "$exp" +%s)
    d2=$(date -d "$now" +%s)
    Sisa_Hari=$(( (d1 - d2) / 86400 ))
    Status_License="Activated"
else
    if [[ $Algoritma_Keys == "" ]]; then
        Skip="true"
    else
        Limit_License="$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 2 )"
        Start_License="$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 3 )"
        End_License="$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 4 )"
        Bot="$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 5 )"
        Backup="$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 6 )"
        Beta="$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 7 )"
        Tipe="$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 8 )"
        Issue_License="$( curl -s https://${Server_URLL}/registered.txt | grep $Algoritma_Keys | cut -d ' ' -f 9-100 )"
    fi
    Status_License="Not Activated"
fi
}

function script_version () {
        SC_Version="$( cat /etc/${Auther}/version.db )"
        Latest="$( curl -s https://${Server_URL}/mantap/bot/Latest-Version.txt )"
}

function os_detail () {
    OS_Name="$( cat /etc/os-release | grep -w ID | head -n1 | sed 's/ID//g' | sed 's/=//g' )"
    OS_FName="$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' | sed 's/,//g'  )"
    OS_Version="$( cat /etc/os-release | grep -w VERSION | head -n1 | sed 's/VERSION//g' | sed 's/=//g' | sed 's/"//g' )"
    OS_Version_ID="$( cat /etc/os-release | grep -w VERSION_ID | head -n1 | sed 's/VERSION_ID//g' | sed 's/=//g' | sed 's/"//g' )"
    OS_Arch="$( uname -m )"
    OS_Kernel="$( uname -r )"
}

# =========================================================================================================
# GETTING INFORMATION
ssh=$(systemctl status ssh | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
l2tp_status=$(systemctl status xl2tpd | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
openvpn_service="$(systemctl show openvpn.service --no-page)"
oovpn=$(echo "${openvpn_service}" | grep 'ActiveState=' | cut -f2 -d=)
#sst_status=$(systemctl status shadowsocks-libev-server@tls | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1) 
ss_status=$(systemctl status shadowsocks-libev | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1) 
tls_v2ray_status=$(systemctl status xray@v2ray-tls | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
nontls_v2ray_status=$(systemctl status xray@v2ray-nontls | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vless_tls_v2ray_status=$(systemctl status xray@vless-tls | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vless_nontls_v2ray_status=$(systemctl status xray@vless-nontls | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
ssr_status=$(systemctl status ssrmu | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
trojan_server=$(systemctl status xray@trojan | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
dropbear_status=$(/etc/init.d/dropbear status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
stunnel_service=$(/etc/init.d/stunnel5 status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
squid_service=$(/etc/init.d/squid status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
ssh_service=$(/etc/init.d/ssh status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vnstat_service=$(/etc/init.d/vnstat status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
cron_service=$(/etc/init.d/cron status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
fail2ban_service=$(/etc/init.d/fail2ban status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
wg="$(systemctl show wg-quick@wg0.service --no-page)"
swg=$(echo "${wg}" | grep 'ActiveState=' | cut -f2 -d=)
trgo="$(systemctl show trojan-go.service --no-page)"                                      
strgo=$(echo "${trgo}" | grep 'ActiveState=' | cut -f2 -d=)  
sswg=$(systemctl status wg-quick@wg0 | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
wstls=$(systemctl status ws-tls | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
wsdrop=$(systemctl status ws-nontls | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
wsovpn=$(systemctl status ws-ovpn | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
osslh=$(systemctl status sslh | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
ohp=$(systemctl status dropbear-ohp | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
ohq=$(systemctl status openvpn-ohp | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
ohr=$(systemctl status ssh-ohp | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
grpc=$(systemctl status geo-vmess-grpc | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vgrpc=$(systemctl status geo-vless-grpc | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)

# COLOR VALIDATION
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
clear

# STATUS SERVICE Shadowsocks HTTP
if [[ $ss_status == "running" ]]; then 
   sss_status=" ${GREEN}Running ${NC}( No Error )"
else
   sss_status="${RED}  Not Running ${NC}  ( Error )"
fi

# STATUS SERVICE OPENVPN
if [[ $oovpn == "active" ]]; then
  status_openvpn=" ${GREEN}Running ${NC}( No Error )"
else
  status_openvpn="${RED}  Not Running ${NC}  ( Error )"
fi

# STATUS SERVICE  SSH 
if [[ $ssh == "running" ]]; then 
   sssh=" ${GREEN}Running ${NC}( No Error )"
else
   sssh="${RED}  Not Running ${NC}  ( Error )"
fi

# STATUS SERVICE  SQUID 
if [[ $squid_service == "running" ]]; then 
   status_squid=" ${GREEN}Running ${NC}( No Error )"
else
   status_squid="${RED}  Not Running ${NC}  ( Error )"
fi

# STATUS SERVICE  VNSTAT 
if [[ $vnstat_service == "running" ]]; then 
   status_vnstat=" ${GREEN}Running ${NC}( No Error )"
else
   status_vnstat="${RED}  Not Running ${NC}  ( Error )"
fi

# STATUS SERVICE  CRONS 
if [[ $cron_service == "running" ]]; then 
   status_cron=" ${GREEN}Running ${NC}( No Error )"
else
   status_cron="${RED}  Not Running ${NC}  ( Error )"
fi

# STATUS SERVICE  FAIL2BAN 
if [[ $fail2ban_service == "running" ]]; then 
   status_fail2ban=" ${GREEN}Running ${NC}( No Error )"
else
   status_fail2ban="${RED}  Not Running ${NC}  ( Error )"
fi

# STATUS SERVICE  TLS 
if [[ $tls_v2ray_status == "running" ]]; then 
   status_tls_v2ray=" ${GREEN}Running${NC} ( No Error )"
else
   status_tls_v2ray="${RED}  Not Running${NC}   ( Error )"
fi

# STATUS SERVICE NON TLS V2RAY
if [[ $nontls_v2ray_status == "running" ]]; then 
   status_nontls_v2ray=" ${GREEN}Running ${NC}( No Error )${NC}"
else
   status_nontls_v2ray="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# STATUS SERVICE VLESS HTTPS
if [[ $vless_tls_v2ray_status == "running" ]]; then
  status_tls_vless=" ${GREEN}Running${NC} ( No Error )"
else
  status_tls_vless="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# STATUS SERVICE VLESS HTTP
if [[ $vless_nontls_v2ray_status == "running" ]]; then
  status_nontls_vless=" ${GREEN}Running${NC} ( No Error )"
else
  status_nontls_vless="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# SHADOWSOCKSR STATUS
if [[ $ssr_status == "running" ]] ; then
  status_ssr=" ${GREEN}Running${NC} ( No Error )${NC}"
else
  status_ssr="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# SODOSOK
if [[ $status_text == "active" ]] ; then
  status_sodosok=" ${GREEN}Running${NC} ( No Error )${NC}"
else
  status_sodosok="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# STATUS SERVICE TROJAN
if [[ $trojan_server == "running" ]]; then 
   status_virus_trojan=" ${GREEN}Running ${NC}( No Error )${NC}"
else
   status_virus_trojan="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# STATUS SERVICE WIREGUARD
if [[ $swg == "active" ]]; then
  status_wg=" ${GREEN}Running ${NC}( No Error )${NC}"
else
  status_wg="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# Status Service Trojan GO
if [[ $strgo == "active" ]]; then
  status_trgo=" ${GREEN}Running ${NC}( No Error )${NC}"
else
  status_trgo="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# STATUS SERVICE L2TP
if [[ $l2tp_status == "running" ]]; then 
   status_l2tp=" ${GREEN}Running${NC} ( No Error )${NC}"
else
   status_l2tp="${RED}  Not Running${NC}  ( Error )${NC}"
fi

# STATUS SERVICE DROPBEAR
if [[ $dropbear_status == "running" ]]; then 
   status_beruangjatuh=" ${GREEN}Running${NC} ( No Error )${NC}"
else
   status_beruangjatuh="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# STATUS SERVICE STUNNEL
if [[ $stunnel_service == "running" ]]; then 
   status_stunnel=" ${GREEN}Running ${NC}( No Error )"
else
   status_stunnel="${RED}  Not Running ${NC}  ( Error )}"
fi

# STATUS SERVICE WEBSOCKET TLS
if [[ $wstls == "running" ]]; then 
   swstls=" ${GREEN}Running ${NC}( No Error )${NC}"
else
   swstls="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# STATUS SERVICE WEBSOCKET DROPBEAR
if [[ $wsdrop == "running" ]]; then 
   swsdrop=" ${GREEN}Running ${NC}( No Error )${NC}"
else
   swsdrop="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# STATUS SERVICE WEBSOCKET OPEN OVPN
if [[ $wsovpn == "running" ]]; then 
   swsovpn=" ${GREEN}Running ${NC}( No Error )${NC}"
else
   swsovpn="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# STATUS SERVICE SSLH / SSH
if [[ $osslh == "running" ]]; then 
   sosslh=" ${GREEN}Running ${NC}( No Error )${NC}"
else
   sosslh="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# STATUS OHP DROPBEAR
if [[ $ohp == "running" ]]; then 
   sohp=" ${GREEN}Running ${NC}( No Error )${NC}"
else
   sohp="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# STATUS OHP OpenVPN
if [[ $ohq == "running" ]]; then 
   sohq=" ${GREEN}Running ${NC}( No Error )${NC}"
else
   sohq="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# STATUS OHP SSH
if [[ $ohr == "running" ]]; then 
   sohr=" ${GREEN}Running ${NC}( No Error )${NC}"
else
   sohr="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# STATUS SERVICE WEBSOCKET OPENSSH
if [[ $wsopen == "running" ]]; then 
   swsopen=" ${GREEN}Running ${NC}( No Error )${NC}" 
else
   swsopen="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# STATUS SERVICE GRPC VMESS
if [[ $grpc == "running" ]]; then 
   sgrpc=" ${GREEN}Running ${NC}( No Error )${NC}" 
else
   sgrpc="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# STATUS SERVICE GRPC VMESS
if [[ $vgrpc == "running" ]]; then 
   svgrpc=" ${GREEN}Running ${NC}( No Error )${NC}" 
else
   svgrpc="${RED}  Not Running ${NC}  ( Error )${NC}"
fi

# TOTAL RAM
total_ram=` grep "MemTotal: " /proc/meminfo | awk '{ print $2}'`
totalram=$(($total_ram/1024))
# KERNEL TERBARU
#kernelku=$(uname -r)
Domen="$(cat /etc/xray/domain)"
# =========================================================================================================
# // Running Function Requirement
os_detail
#script_version
license_check

if [[ $Backup == "1" ]]; then
        backup='Allowed'
else
        backup='Not Allowed'
fi

# // Clear
clear
clear && clear && clear
clear;clear;clear
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo -e "  Welcome To ${GREEN}Geo Project ${NC}Script Installer ${YELLOW}(${NC}${GREEN} Stable Edition ${NC}${YELLOW})${NC}"
echo -e "     This Will Quick Setup VPN Server On Your Server"
echo -e "         Auther : ${GREEN}MUHAMMAD AMIN${NC}${YELLOW}(${NC} ${GREEN}Geo Project ${NC}${YELLOW})${NC}"
echo -e "       © Copyright By Geo Project ${YELLOW}(${NC} 2021-2022 ${YELLOW})${NC}"
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo ""
echo -e "\033[0;34m┌───────────────────────────────────────────────────────────┐${NC}"
echo -e "\033[0;34m│$NC\E[41;1;39m                      Sytem Information                    \E[0m\033[0;34m│"
echo -e "\033[0;34m└───────────────────────────────────────────────────────────┘${NC}"
echo -e "\033[0;34m┌───────────────────────────────────────────────────────────┐${NC}"
echo -e "\033[0;34m│$NC Sever Uptime        = $( uptime -p  | cut -d " " -f 2-10000 ) "
echo -e "\033[0;34m│$NC Current Time        = $( date -d "0 days" +"%d-%m-%Y | %X" )"
#echo -e "\033[0;34m│$NC Script Version      = $( cat /etc/${Auther}/version.db )"
echo -e "\033[0;34m│$NC Operating System    = ${OS_FName} ( ${OS_Arch} )"
echo -e "\033[0;34m│$NC Current Domain      = $( cat /etc/xray/domain )"
echo -e "\033[0;34m│$NC Server IP           = ${IP}"
echo -e "\033[0;34m│$NC License Key Status  = ${Status_License}"
#echo -e "\033[0;34m│$NC License Type        = ${Tipe} Edition"
#echo -e "\033[0;34m│$NC Bot Allowed         = ${bot}"
#echo -e "\033[0;34m│$NC Beta Allowed        = ${beta}"
echo -e "\033[0;34m│$NC Backup Allowed      = ${backup}"
echo -e "\033[0;34m│$NC License Issued to   = ${Issue_License}"
echo -e "\033[0;34m│$NC License Start       = ${Start_License}"
echo -e "\033[0;34m│$NC License Limit       = ${Limit_License} VPS"
echo -e "\033[0;34m│$NC License Expired     = ${End_License} (${GREEN} $(if [[ ${Sisa_Hari} -lt 5 ]]; then
echo -e "\033[0;34m│$NC $RED${Sisa_Hari} Days Left${NC}"; else
echo -e "\033[0;34m$NC${GREEN}${Sisa_Hari} Days Left"; fi
)${NC} )"
echo -e "\033[0;34m└───────────────────────────────────────────────────────────┘${NC}"
echo -e "\033[0;34m┌───────────────────────────────────────────────────────────┐${NC}"
echo -e "\033[0;34m│$NC\E[41;1;39m                      Service Information                  \E[0m\033[0;34m│"
echo -e "\033[0;34m└───────────────────────────────────────────────────────────┘${NC}"
echo -e "\033[0;34m┌───────────────────────────────────────────────────────────┐${NC}"
echo -e "\033[0;34m│$NC $white SSH / TUN                    :$sssh"
echo -e "\033[0;34m│$NC $white OpenVPN                      :$status_openvpn"
echo -e "\033[0;34m│$NC $white Dropbear                     :$status_beruangjatuh"
echo -e "\033[0;34m│$NC $white Stunnel5                     :$status_stunnel"
echo -e "\033[0;34m│$NC $white Squid                        :$status_squid"
echo -e "\033[0;34m│$NC $white Fail2Ban                     :$status_fail2ban"
echo -e "\033[0;34m│$NC $white Crons                        :$status_cron"
echo -e "\033[0;34m│$NC $white Vnstat                       :$status_vnstat"
echo -e "\033[0;34m│$NC $white L2TP                         :$status_l2tp"
#echo -e "\033[0;34m│$NC $white SSTP                         :$status_sstp"
echo -e "\033[0;34m│$NC $white XRAYS Vmess TLS              :$status_tls_v2ray"
echo -e "\033[0;34m│$NC $white XRAYS Vmess None TLS         :$status_nontls_v2ray"
echo -e "\033[0;34m│$NC $white XRAYS Vless TLS              :$status_tls_vless"
echo -e "\033[0;34m│$NC $white XRAYS Vless None TLS         :$status_nontls_vless"
#echo -e "\033[0;34m│$NC $white XRAYS Vmess GRPC             :$sgrpc"
#echo -e "\033[0;34m│$NC $white XRAYS Vless GRPC             :$svgrpc"
echo -e "\033[0;34m│$NC $white Shadowsocks-R                :$status_ssr"
#echo -e " Shadowsocks-OBFS HTTPS  :$status_sst"
echo -e "\033[0;34m│$NC $white Shadowsocks-OBFS             :$sss_status"
echo -e "\033[0;34m│$NC $white XRAYS Trojan                 :$status_virus_trojan"
echo -e "\033[0;34m│$NC $white Trojan GO                    :$status_trgo"
echo -e "\033[0;34m│$NC $white Wireguard                    :$status_wg"
echo -e "\033[0;34m│$NC $white Websocket TLS                :$swstls"
echo -e "\033[0;34m│$NC $white Websocket None TLS           :$swsdrop"
echo -e "\033[0;34m│$NC $white Websocket Ovpn               :$swsovpn"
echo -e "\033[0;34m│$NC $white SSL / SSH Multiplexer        :$sosslh"
echo -e "\033[0;34m└───────────────────────────────────────────────────────────┘${NC}"
echo -e "\033[0;34m┌───────────────────────────────────────────────────────────┐${NC}"
echo -e "\033[0;34m│$NC\E[41;1;39m                          Geo Project                      \E[0m\033[0;34m│"
echo -e "\033[0;34m└───────────────────────────────────────────────────────────┘${NC}"
echo ""
echo ""
