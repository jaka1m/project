[Unit]
Description=Python Proxy geovpn
Documentation=https://t.me/tau_samawa
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /usr/bin/ws.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
