#!/bin/bash
REPO="https://jaka1m.github.io/project/"
wget -q -O /etc/systemd/system/limitvmess.service "${REPO}limit/limitvmess.service" && chmod +x limitvmess.service >/dev/null 2>&1
wget -q -O /etc/systemd/system/limitvless.service "${REPO}limit/limitvless.service" && chmod +x limitvless.service >/dev/null 2>&1
wget -q -O /etc/systemd/system/limittrojan.service "${REPO}limit/limittrojan.service" && chmod +x limittrojan.service >/dev/null 2>&1
wget -q -O /etc/systemd/system/limitshadowsocks.service "${REPO}limit/limitshadowsocks.service" && chmod +x limitshadowsocks.service >/dev/null 2>&1
wget -q -O /etc/xray/vmess "${REPO}limit/vmess" >/dev/null 2>&1
wget -q -O /etc/xray/vless "${REPO}limit/vless" >/dev/null 2>&1
wget -q -O /etc/xray/trojan "${REPO}limit/trojan" >/dev/null 2>&1
wget -q -O /etc/xray/shadowsocks "${REPO}limit/shadowsocks" >/dev/null 2>&1
chmod +x /etc/xray/vmess
chmod +x /etc/xray/vless
chmod +x /etc/xray/trojan
chmod +x /etc/xray/shadowsocks
systemctl daemon-reload
systemctl enable --now limitvmess
systemctl enable --now limitvless
systemctl enable --now limittrojan
systemctl enable --now limitshadowsocks
systemctl start limitvmess
systemctl start limitvless
systemctl start limittrojan
systemctl start limitshadowsocks
systemctl restart limitvmess
systemctl restart limitvless
systemctl restart limittrojan
systemctl restart limitshadowsocks
rm -rf /root/limit.sh
