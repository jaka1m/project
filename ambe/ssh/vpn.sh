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
# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(curl -sS ifconfig.me);
MYIP2="s/xxxxxxxxx/$MYIP/g";
ANU=$(ip -o $ANU -4 route show to default | awk '{print $5}');

# Install OpenVPN dan Easy-RSA
apt install openvpn easy-rsa unzip -y
apt install openssl iptables iptables-persistent -y
mkdir -p /etc/openvpn/server/easy-rsa/
cd /etc/openvpn/
wget https://${Server_URL}/ssh/vpn.zip
unzip vpn.zip
rm -f vpn.zip
chown -R root:root /etc/openvpn/server/easy-rsa/

cd
mkdir -p /usr/lib/openvpn/
cp /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so /usr/lib/openvpn/openvpn-plugin-auth-pam.so

# nano /etc/default/openvpn
sed -i 's/#AUTOSTART="all"/AUTOSTART="all"/g' /etc/default/openvpn

# restart openvpn dan cek status openvpn
systemctl enable --now openvpn-server@server-tcp
systemctl enable --now openvpn-server@server-udp
/etc/init.d/openvpn restart
/etc/init.d/openvpn status

# aktifkan ip4 forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf

# Buat config client TCP 1194
cat > /etc/openvpn/tcp.ovpn <<-END
client
dev tun
proto tcp
remote xxxxxxxxx 1194
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END

sed -i $MYIP2 /etc/openvpn/tcp.ovpn;

# Buat config client UDP 2200
cat > /etc/openvpn/udp.ovpn <<-END
client
dev tun
proto udp
remote xxxxxxxxx 2200
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END

sed -i $MYIP2 /etc/openvpn/udp.ovpn;

# Buat config client SSL
cat > /etc/openvpn/ssl.ovpn <<-END
client
dev tun
proto tcp
remote xxxxxxxxx 990
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END

sed -i $MYIP2 /etc/openvpn/ssl.ovpn;

cd
# pada tulisan xxx ganti dengan alamat ip address VPS anda 
/etc/init.d/openvpn restart

# masukkan certificatenya ke dalam config client TCP 1194
echo '<ca>' >> /etc/openvpn/tcp.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/tcp.ovpn
echo '</ca>' >> /etc/openvpn/tcp.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( TCP 1194 )
cp /etc/openvpn/tcp.ovpn /home/vps/public_html/tcp.ovpn

# masukkan certificatenya ke dalam config client UDP 2200
echo '<ca>' >> /etc/openvpn/udp.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/udp.ovpn
echo '</ca>' >> /etc/openvpn/udp.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( UDP 2200 )
cp /etc/openvpn/udp.ovpn /home/vps/public_html/udp.ovpn

# masukkan certificatenya ke dalam config client SSL
echo '<ca>' >> /etc/openvpn/ssl.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/ssl.ovpn
echo '</ca>' >> /etc/openvpn/ssl.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( SSL )
cp /etc/openvpn/ssl.ovpn /home/vps/public_html/ssl.ovpn

#firewall untuk memperbolehkan akses UDP dan akses jalur TCP

iptables -t nat -I POSTROUTING -s 10.6.0.0/24 -o $ANU -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.7.0.0/24 -o $ANU -j MASQUERADE
iptables-save > /etc/iptables.up.rules
chmod +x /etc/iptables.up.rules

iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# Restart service openvpn
systemctl enable openvpn
systemctl start openvpn
/etc/init.d/openvpn restart

# Delete script
 
cd /home/vps/public_html/
zip cfg.zip tcp.ovpn udp.ovpn ssl.ovpn
cd
cat <<'mySiteOvpn' > /home/vps/public_html/index.html
<!DOCTYPE html>
<html lang="en">
<!-- Simple OVPN Download site by Geo Project -->
  <head><center><center>
  <meta charset="utf-8" />
  <title>GEO PROJECT</title>
<meta name="viewport" content="width=device-width" />
<div class="container padded" id="dl-clients">
<body>
#<h2 class="h1"><i class="fa fa-desktop"><span style="color:yellow">Auto Script</i></h2>
#<h2 class="h1"><i class="fa fa-desktop"><span style="color:yellow">Premium</i></h2>
<h2 class="h1"><i class="fa fa-desktop"><span style="color:yellow">Geo Project</i></h2>
<meta name="description" content="MyScriptName Server" />
<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">
<meta name="theme-color" content="#000000" />
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
<link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/mdbootstrap/4.8.3/css/mdb.min.css" rel="stylesheet">
<div class="container justify-content-center" style="margin-top:9em;margin-bottom:5em;">
<div class="col-md"><div class="view"><img src="https://openvpn.net/wp-content/uploads/openvpn.jpg" class="card-img-top"></img><div class="mask rgba-white-slight"></div></div>
<div class="card"><div class="card-body"><h5 class="card-title"><span class="badge light-blue darken-4">CONFIG OVPN LIST</span></h5><br /><ul class="list-group"><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p><span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> Config OVPN Protocol TCP-1194</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESSS:89/tcp.ovpn" style="float:center;"><i class="fa fa-download"></i> Download</a></li><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p><span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br/><small> Config OVPN Protocol UDP-2200</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESSS:89/udp.ovpn" style="float:center;"><i class="fa fa-download"></i> Download</a></li><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p><span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> Config OVPN Protocol Ssl-990</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESSS:89/ssl.ovpn" style="float:center;"><i class="fa fa-download"></i> Download</a></li><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p><span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> ALL.zip</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESSS:89/cfg.zip" style="float:center;"><i class="fa fa-download"></i> Download</a></li></ul>
</div></div></div></div>
</body>
<style type="text/css">
body {
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 14px;
    color: black;
    background-color: black;
}
h1 {
    color: GREEN;
    font-size: 24px;
    text-align: center;
    padding-bottom: 0;
    margin-bottom: 0;
}
p.info {
    text-align: center;
    font-size: 12px;
}
.status0 {
    background: #ebb;
}
.status1 {
    background: lime;
}
table {
    #border: medium solid black;
    margin: 0 auto;
    border-collapse: collapse;
}
th {
    background: black;
    color: white;
}
tr {
    border-bottom: 1px solid #212223;
}
td {
    padding: 0px 10px 0px 10px;
}
</style>
<div class="container justify-content-center" style="margin-top:9em;margin-bottom:5em;">
<th><br><div class="card"><div class="card-body"><h5 class="card-title"><span class="badge light-blue darken-4">OpenVPN Config Download</span><p class='info'>🔰 COPYRIGHT © 2022 by Geo Project 🔰<br/>🔰Website Powered By Geo Project 🔰<br /></h5></br></p></div></div></th>
</html>

</ul></div></div></div></div></body></html>
mySiteOvpn

sed -i "s|IP-ADDRESSS|$(curl -sS ifconfig.me)|g" /home/vps/public_html/index.html

history -c
rm -f /root/vpn.sh
