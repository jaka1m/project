#!/usr/bin/env bash

## grpc
# / / Ambil Xray Core Version Terbaru
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"

# / / Installation Xray Core
xraycore_link="https://github.com/XTLS/Xray-core/releases/download/v$latest_version/xray-linux-64.zip"

# 
uuid=$(cat /proc/sys/kernel/random/uuid)

# / / Make Main Directory
mkdir -p /usr/bin/xray
mkdir -p /etc/xray

# / / Unzip Xray Linux 64
cd `mktemp -d`
curl -sL "$xraycore_link" -o xray.zip
unzip -q xray.zip && rm -rf xray.zip
mv xray /usr/local/bin/xray
chmod +x /usr/local/bin/xray

# Make Folder XRay
mkdir -p /var/log/xray/
#
wget -q -O /usr/local/bin/geosite.dat "https://jaka1m.github.io/project/ambe/grpc/geosite.dat"
wget -q -O /usr/local/bin/geoip.dat "https://jaka1m.github.io/project/ambe/grpc/geoip.dat"


#wget -q -O /usr/local/xray/xray "https://jaka1m.github.io/project/ambe/core/xray"
#wget -q -O /usr/local/xray/xray "https://jaka1m.github.io/project/ambe/core/xray" 
wget -q -O /usr/local/bin/geosite.dat "https://jaka1m.github.io/project/ambe/grpc/geosite.dat"
wget -q -O /usr/local/bin/geoip.dat "https://jaka1m.github.io/project/ambe/grpc/geoip.dat"
mkdir -p /etc/xray/
chmod 775 /etc/xray/
#
  cat > /etc/xray//trojangrpc.json << END
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": 2022,
      "listen": "127.0.0.1",
      "protocol": "trojan",
      "tag": "trojangRPC",
        "settings": {
            "clients": [
                {
                    "password": "$uuid"
                }
            ]
        },
        "streamSettings": {
            "network": "grpc",
            "grpcSettings": {
                "serviceName": "/grpc_trojan"
            }
        }
    }
  ],
  "outbounds": [
    {
      "tag": "direct",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag": "blocked",
      "protocol": "blackhole",
      "settings": {}
    }
  ],
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "type": "field",
        "ip": [
          "geoip:private"
        ],
        "outboundTag": "direct"
      },
      {
        "type": "field",
        "domain": [
          "geosite:category-ads"
        ],
        "outboundTag": "blocked"
      }
    ]
  }
}
EOF

  cat > /etc/systemd/system/trojangrpc.service << EOF
[Unit]
Description=XRay VMess GRPC Service
Documentation=https://t.me/sampiiiiu
After=network.target nss-lookup.target

[Service]
User=root
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /etc/xray/trojangrpc.json
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/trojangrpc.service << EOF
[Unit]
Description=XRay VMess GRPC Service
Documentation=https://t.me/sampiiiiu
After=network.target nss-lookup.target

[Service]
User=root
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /etc/xray/trojangrpc.json
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable trojan-grpc.service
systemctl restart trojan-grpc.service

#
cd /usr/bin

wget -O addgrpc "https://jaka1m.github.io/project/ambe/grpc/addgrpc.sh"
wget -O delgrpc "https://jaka1m.github.io/project/ambe/grpc/delgrpc.sh"
wget -O renewgrpc "https://jaka1m.github.io/project/ambe/grpc/renewgrpc.sh"
wget -O cekgrpc "https://jaka1m.github.io/project/ambe/grpc/cekgrpc.sh"
chmod +x addgrpc
chmod +x delgrpc
chmod +x renewgrpc
chmod +x cekgrpc
cd
rm -f grpc.sh
