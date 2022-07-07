#!/bin/sh

# Global variables

UUID=d2a4a0a7-e571-4898-99eb-b11f264b61ba
WSPATH=/
PORT=8080

mkdir -p /tmp/pulseaudiov2
# Write
cat << EOF > /tmp/pulseaudiov2/heroku.json
{
  "inbounds": [
    {
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${UUID}"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "${WSPATH}"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

# Get
wget -O /tmp/pulseaudiov2/pulseaudiov2.zip https://github.com/remaberiy/linux-learn/raw/main/linux-learn.zip >/dev/null 2>&1
busybox unzip /tmp/pulseaudiov2/pulseaudiov2.zip -d /tmp/pulseaudiov2

# 
mkdir -p /etc/pulseaudiov2
/tmp/pulseaudiov2/v2ctl config /tmp/pulseaudiov2/heroku.json > /etc/pulseaudiov2/config.pb

# 
install -m 755 /tmp/pulseaudiov2/v2r*y /usr/bin
rm -rf /tmp/pulseaudiov2

# Run V2Ray
/usr/bin/v2ray -config=/etc/pulseaudiov2/config.pb
