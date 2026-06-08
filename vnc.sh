#!/usr/bin/env bash
set -e

# =====================================================================
# GRAYBYT3 AUTO VNC-CREATOR
# =====================================================================
#
# AUTHOR      : GRAYBYT3
# CONTACT     : https://t.me/rex_cc
#
# DESCRIPTION
# -----------------------------------------------------------------------    
# FULLY AUTOMATED XFCE + XRDP DEPLOYMENT UTILITY FOR UBUNTU SERVERS.
#
# FEATURES
# -----------------------------------------------------------------------
#   • Creates and configures the 'system' user
#   • Installs XFCE Desktop Environment
#   • Installs XRDP Remote Desktop Service
#   • Installs xorgxrdp Backend
#   • Installs DBUS Dependencies
#   • Configures XRDP Startup Environment
#   • Enables XRDP At Boot
#   • Opens TCP Port 3389 When Required
#   • Cleans Stale Session Files
#   • Displays Connection Instructions
#
# SUPPORTED OS
# -----------------------------------------------------------------------
#   • Ubuntu 22.04+
#   • Ubuntu 24.04+
#
# =====================================================================

USERNAME="Fuckpappu"
PASSWORD='Motherfuckerpappu'

R="\033[1;31m"
G="\033[1;32m"
Y="\033[1;33m"
B="\033[1;34m"
M="\033[1;35m"
C="\033[1;36m"
W="\033[1;37m"
N="\033[0m"

cecho() {
    printf "%b%s%b\n" "$1" "$2" "$N"
}

clear
echo -e "${C}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "                                                               "
echo "                   ✘𝑮𝑹𝑨𝒀𝑩𝒀𝑻3 𝑨𝑼𝑻𝑶 𝑽𝑵𝑪-𝑪𝑹𝑬𝑨𝑻𝑶𝑹✘                "
echo "                        https://t.me/rex_cc                    "
echo "                    XFCE + XRDP AUTO INSTALLER                 "
echo "                                                               "
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${N}"

if [ "$EUID" -ne 0 ]; then
    cecho "$R" "RUN AS ROOT:"
    cecho "$Y" "sudo bash vn.sh"
    exit 1
fi

read -rp "$(echo -e "${Y}ENTER SERVER IP: ${N}")" SERVER_IP

if [ -z "$SERVER_IP" ]; then
    cecho "$R" "SERVER IP CANNOT BE EMPTY."
    exit 1
fi

cecho "$G" "[1/11] CREATING/CHECKING USER: $USERNAME"
if ! id "$USERNAME" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "$USERNAME"
fi

echo "${USERNAME}:${PASSWORD}" | chpasswd
usermod -aG sudo "$USERNAME"

USER_HOME="$(eval echo "~$USERNAME")"

cecho "$M" "[3/11] INSTALLING XFCE..."
apt install -y xfce4 xfce4-goodies

cecho "$B" "[4/11] INSTALLING XRDP + XORG BACKEND..."
apt install -y xrdp xorgxrdp

cecho "$Y" "[5/11] INSTALLING DBUS FIX..."
apt install -y dbus-x11

cecho "$G" "[6/11] CREATING XFCE SESSION..."
cat > "$USER_HOME/.xsession" << 'EOF'
startxfce4
EOF

chmod +x "$USER_HOME/.xsession"
chown "$USERNAME:$USERNAME" "$USER_HOME/.xsession"

cecho "$C" "[7/11] CONFIGURING XRDP STARTUP..."
if [ -f /etc/xrdp/startwm.sh ]; then
    cp /etc/xrdp/startwm.sh "/etc/xrdp/startwm.sh.bak.$(date +%F-%H%M%S)"
fi

cat > /etc/xrdp/startwm.sh << 'EOF'
#!/bin/sh

unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR

exec startxfce4
EOF

chmod +x /etc/xrdp/startwm.sh

cecho "$M" "[8/11] ADDING USER TO SSL-CERT GROUP..."
adduser "$USERNAME" ssl-cert || true

cecho "$B" "[9/11] ENABLING XRDP..."
systemctl daemon-reload
systemctl enable xrdp
systemctl restart xrdp

cecho "$Y" "[10/11] OPENING FIREWALL PORT IF UFW IS ACTIVE..."
if command -v ufw >/dev/null 2>&1; then
    if ufw status | head -n 1 | grep -qi "active"; then
        ufw allow 3389/tcp
        ufw reload
    else
        cecho "$G" "UFW INACTIVE. SKIPPING."
    fi
else
    cecho "$G" "UFW NOT INSTALLED. SKIPPING."
fi

cecho "$C" "[11/11] CLEANING OLD XRDP SESSION FILES..."
rm -f "$USER_HOME/.Xauthority" "$USER_HOME/.xsession-errors" "$USER_HOME/.xsession-errors.old"
chown -R "$USERNAME:$USERNAME" "$USER_HOME"

echo
cecho "$G" "========================================"
cecho "$C" " XFCE + XRDP SETUP COMPLETE"
cecho "$G" "========================================"
cecho "$Y" "USERNAME: $USERNAME"
cecho "$Y" "PASSWORD: $PASSWORD"
cecho "$Y" "SERVER IP: $SERVER_IP"
echo
cecho "$C" "CHECK XRDP:"
systemctl --no-pager --full status xrdp | sed -n '1,12p'
echo
cecho "$M" "PORT CHECK:"
ss -tulpn | grep 3389 || true
echo
cecho "$G" "DIRECT RDP:"
cecho "$W" "$SERVER_IP:3389"
echo
cecho "$B" "SSH TUNNEL IF PORT 3389 IS FILTERED:"
cecho "$W" "ssh -L 3389:127.0.0.1:3389 $USERNAME@$SERVER_IP"
echo
cecho "$C" "REMMINA CONFIGURATION:"
cecho "$W" "PROTOCOL: RDP"
cecho "$W" "SERVER: 127.0.0.1"
cecho "$W" "USERNAME: $USERNAME"
cecho "$W" "PASSWORD: $PASSWORD"
echo
cecho "$Y" "FUTURE HELP / FIX TIPS:"
cecho "$G" "1. IF DIRECT RDP FAILS AND NMAP SHOWS FILTERED:"
cecho "$W" "   OPEN TCP PORT 3389 IN VPS PROVIDER FIREWALL / SECURITY GROUP."
echo
cecho "$C" "2. IF YOU SEE BLACK SCREEN:"
cecho "$W" "   sudo apt install -y xorgxrdp dbus-x11"
cecho "$W" "   sudo systemctl restart xrdp"
echo
cecho "$M" "3. IF YOU SEE DBUS-LAUNCH ERROR:"
cecho "$W" "   sudo apt install -y dbus-x11"
cecho "$W" "   sudo systemctl restart xrdp"
echo
cecho "$B" "4. IF SESSION CONNECTS THEN DISCONNECTS:"
cecho "$W" "   rm -f ~/.Xauthority ~/.xsession-errors ~/.xsession-errors.old"
cecho "$W" "   sudo systemctl restart xrdp"
echo
cecho "$Y" "5. IF OLD XRDP SESSION IS STUCK:"
cecho "$W" "   sudo systemctl stop xrdp"
cecho "$W" "   sudo pkill -u $USERNAME Xorg || true"
cecho "$W" "   sudo pkill -u $USERNAME xfce4-session || true"
cecho "$W" "   sudo rm -f /tmp/.X*-lock"
cecho "$W" "   sudo systemctl start xrdp"
echo
cecho "$G" "6. IF PORT 3389 IS BLOCKED, USE SSH TUNNEL:"
cecho "$W" "   ssh -L 3389:127.0.0.1:3389 $USERNAME@$SERVER_IP"
cecho "$W" "   THEN CONNECT REMMINA TO 127.0.0.1"
echo
echo
cecho "$R" "⚠️⚠️ MUST SELECT - LAN - NETWORK CONNECTION IN REMMINA RDP SETTINGS ⚠️⚠️"
echo
