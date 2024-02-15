#!/bin/bash
#########
  source <(curl -sL https://github.com/jaka1m/project/raw/main/up/ipserver)
  wget -O /etc/sysctl.conf "https://github.com/jaka1m/project/raw/main/up/sysctl.conf" >/dev/null 2>&1
  wget -O /etc/haproxy/haproxy.cfg "https://github.com/jaka1m/project/raw/main/up/haproxy.cfg" >/dev/null 2>&1
  wget -q -O /etc/ssh/sshd_config "https://github.com/jaka1m/project/raw/main/up/sshd" >/dev/null 2>&1
  wget -O /etc/nginx/conf.d/xray.conf "https://github.com/jaka1m/project/raw/main/up/xray" >/dev/null 2>&1
  wget -O /etc/nginx/nginx.conf "https://github.com/jaka1m/project/raw/main/up/nginx.conf" >/dev/null 2>&1
  wget -O /usr/bin/ws.py "https://github.com/jaka1m/project/raw/main/up/ws.py" >/dev/null 2>&1
  wget -O /etc/systemd/system/ws.service "https://github.com/jaka1m/project/raw/main/up/ws.service" >/dev/null 2>&1
  sysctl -p
 systemctl daemon-reload
  systemctl restart haproxy
  systemctl restart server
  systemctl restart client
  systemctl restart nginx
  systemctl restart ssh
  systemctl restart sshd
  systemctl enable udp
  systemctl enable ws
  systemctl start udp
  systemctl start ws
  systemctl restart udp
cat /etc/xray/xray.crt /etc/xray/xray.key | tee /etc/haproxy/hap.pem
echo""
rm -rf /root/opo.sh
