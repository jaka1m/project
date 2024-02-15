#!/bin/bash
# //====================================================
# //	System Request:Debian 9+/Ubuntu 18.04+/20+
# //	Author:	Geo Project
# //	Dscription: Xray Menu Management
# //	email: admin@geolstore.net
# //  telegram: https://t.me/tau_samawa
# //====================================================
RED="\033[31m"
NC='\033[0m'
OR='\033[1;93m'
Lred='\e[91m'
LLgreen='\e[92m'
Lyellow='\e[93m'
yellow="\033[1;33m"
green="\e[92;1m"
yellow="\033[1;33m"
cyan="\033[1;36m"
MYIP=$(curl -sS ipv4.icanhazip.com)
IP=$(curl -sS ipv4.icanhazip.com)
domain=$(cat /etc/xray/domain)
date=$(date +"%Y-%m-%d")
echo -e "\e[32mloading...\e[0m"
clear
export Random_Number=$( </dev/urandom tr -dc 1-$( curl -s https://raw.githubusercontent.com/jaka1m/project/main/backup/akun-smtp.txt | grep -E Jumlah-Notif | cut -d " " -f 2 | tail -n1 ) | head -c1 )
export email=$( curl -s https://raw.githubusercontent.com/jaka1m/project/main/backup/akun-smtp.txt | grep -E Notif$Random_Number | cut -d " " -f 2 | tr -d '\r')
export password=$( curl -s https://raw.githubusercontent.com/jaka1m/project/main/backup/akun-smtp.txt | grep -E Notif$Random_Number | cut -d " " -f 3 | tr -d '\r')

# // Import SMTP Account
cat > /etc/msmtprc << END
defaults
port 587
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
auth on
logfile        ~/.msmtp.log

account        GeoVPN
host           smtp.gmail.com
port           587
from           Your Backup Is Ready
user           $email
password       $password
account default : GeoVPN
END

date2=$(date +"%X")
clear
email=$(cat /usr/local/sbin/email)
if [[ "$email" = "" ]]; then
echo -e "${green}Masukkan Email Untuk Menerima Backup $NC"
read -rp "Email : " -e email
cat <<EOF>>/usr/local/sbin/email
$email
EOF
fi

# // Email Requirement
if [[ $( cat /usr/local/sbin/email | head -n1 | awk '{print $1}' ) == "" ]]; then
    echo -e "${EROR} Please Setup Email For Backup Data"
    exit 1
fi
clear
echo -e "${green}Mohon Menunggu , Proses Backup sedang berlangsung !! $NC"
rm -rf /root/backup
mkdir /root/backup
    cp -r /root/.acme.sh /root/backup/ &> /dev/null
cp /etc/passwd /root/backup/ &> /dev/null
cp /etc/group /root/backup/ &> /dev/null
cp /etc/shadow /root/backup/ &> /dev/null
cp /etc/gshadow /root/backup/ &> /dev/null
cp -r /etc/wireguard /root/backup/wireguard &> /dev/null
cp /etc/ppp/chap-secrets /root/backup/chap-secrets &> /dev/null
cp /etc/ipsec.d/passwd /root/backup/passwd1 &> /dev/null
cp /etc/shadowsocks-libev/akun.conf /root/backup/ss.conf &> /dev/null
cp -r /var/lib/geovpnstore/ /root/backup/geovpnstore &> /dev/null
cp -r /home/sstp /root/backup/sstp &> /dev/null
cp -r /etc/v2ray /root/backup/v2ray &> /dev/null
cp -r /etc/xray /root/backup/xray &> /dev/null
cp -r /etc/trojan-go /root/backup/trojan-go &> /dev/null
cp -r /usr/local/shadowsocksr/ /root/backup/shadowsocksr &> /dev/null
cp -r /home/vps/public_html /root/backup/public_html &> /dev/null
cp -r /etc/cron.d /root/backup/cron.d &> /dev/null
cp /etc/crontab /root/backup/crontab &> /dev/null
cd /root
zip -r $IP-$date.zip backup > /dev/null 2>&1
rclone copy /root/$IP-$date.zip dr:backup/
url=$(rclone link dr:backup/$IP-$date.zip)
id=(`echo $url | grep '^https' | cut -d'=' -f2`)
link="https://drive.google.com/u/4/uc?id=${id}&export=download"
echo " 
Berikut Merupakan Data Backup anda
==================================
IP Address     : ${IP}
Tanggal Backup : ${date}
Waktu Backup   : ${date2}
Backup ID      : ${id}
Backup Link    : ${link}
==================================
" | mail -s "Backup Data" $email
rm -rf /root/backup
rm -r /root/$IP-$date.zip
clear
echo ""
clear
echo -e "${yellow}Your Backup Is Ready"
echo -e "${green}=====================================$NC"
echo -e "This Is Your Backup ID"
echo " IP    = ${IP}"
echo " Date  = ${date}"
echo " ID    = ${id}"
echo " Link  = ${link}"
echo -e "${green}=====================================$NC"
echo ""
echo -e "${green}Silahkan copy ID dan restore di VPS baru $NC"
echo ""
