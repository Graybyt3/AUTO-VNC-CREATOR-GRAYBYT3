---

# 🚀 GRAYBYT3 AUTO VNC-CREATOR

Automatically deploys a complete **XFCE + XRDP Remote Desktop Environment** on Ubuntu servers with a single command.

Designed for administrators who want a lightweight desktop environment without manually configuring XRDP, DBUS, Xorg, users, firewall rules, startup sessions, and common compatibility fixes.

---

# 🖼️ SUCCESS PREVIEW WINDOW

<p align="center">
  <img src="https://raw.githubusercontent.com/Graybyt3/AUTO-VNC-CREATOR-GRAYBYT3/refs/heads/main/auto-vnc.png">
</p>

## ✨ FEATURES

- Automatic User Creation & Configuration
- XFCE Desktop Installation
- XRDP Installation & Configuration
- Xorg XRDP Backend Installation
- DBUS Dependency Installation
- XRDP Auto Start Configuration
- UFW Firewall Detection & Port Opening
- XRDP Session Cleanup
- Connection Information Generator
- Built-In Troubleshooting Guide
- Colorized Installation Output
- Interactive Server IP Prompt
- One-Command Deployment

---

## 🖥️ SUPPORTED OPERATING SYSTEMS

| OS | Supported |
|----|-----------|
| Ubuntu 22.04 | ✅ |
| Ubuntu 24.04 | ✅ |
| Ubuntu Server | ✅ |
| Debian-Based Systems | ⚠️ Untested |

---

## 📦 COMPONENTS INSTALLED

```text
XFCE4
XFCE4-GOODIES
XRDP
XORGXRDP
DBUS-X11
```

---

## ⚡ INSTALLATION

```bash
wget https://your-domain.com/vnc.sh
chmod +x vnc.sh
sudo ./vnc.sh
```

or

```bash
sudo bash vnc.sh
```

---

## 📋 AUTOMATED DEPLOYMENT FLOW

```text
1. Creates and Configures User
2. Updates Package Lists
3. Installs XFCE Desktop
4. Installs XRDP Service
5. Installs Xorg Backend
6. Installs DBUS Components
7. Configures XRDP Startup Environment
8. Enables XRDP Service
9. Opens Port 3389 (When Applicable)
10. Cleans Old Session Files
11. Displays Connection Instructions
12. Displays Troubleshooting Tips
```

---

## 🖥️ REMOTE DESKTOP CONNECTION

After installation:

```text
SERVER_IP:3389
```

### Windows

```text
Remote Desktop Connection (mstsc)
```

### Linux

```text
Remmina
```

---

## 🔒 SSH TUNNEL METHOD

IF YOUR VPS PROVIDER BLOCKS INBOUND TCP PORT 3389:

```bash
ssh -L 3389:127.0.0.1:3389 USER@SERVER_IP
```

### REMMINA CONFIGURATION

```text
Protocol : RDP
Server   : 127.0.0.1
```

---

## 🛠️ COMMON FIXES

### PORT 3389 APPEARS FILTERED

This is usually caused by a cloud-provider firewall or security group.

EXAMPLES:

```text
AWS Security Groups
Alibaba Cloud Security Groups
Oracle Cloud Security Lists
Hetzner Firewalls
Contabo Firewalls
Vultr Firewalls
```

ALLOW:

```text
TCP 3389
Source: 0.0.0.0/0
```

---

### BLACK SCREEN AFTER LOGIN

```bash
sudo apt install -y xorgxrdp dbus-x11
sudo systemctl restart xrdp
```

---

### DBUS ERROR

Error:

```text
Unable to contact settings server
Failed to execute child process dbus-launch
```

FIX:

```bash
sudo apt install -y dbus-x11
sudo systemctl restart xrdp
```

---

### SESSION DISCONNECTS IMMEDIATELY

```bash
rm -f ~/.Xauthority
rm -f ~/.xsession-errors
rm -f ~/.xsession-errors.old

sudo systemctl restart xrdp
```

---

### RESET XRDP SESSIONS

```bash
sudo systemctl stop xrdp

sudo pkill -u USER Xorg || true
sudo pkill -u USER xfce4-session || true

sudo rm -f /tmp/.X*-lock

sudo systemctl start xrdp
```

---

## 📊 VERIFICATION COMMANDS

### XRDP STATUS

```bash
systemctl status xrdp
```

### PORT CHECK

```bash
ss -tulpn | grep 3389
```

### FIREWALL CHECK

```bash
sudo ufw status
```

---

## 📱 RECOMMENDED CLIENTS

### LINUX FOR LIFE

- Remmina
- FreeRDP

### WINDOWS

- Remote Desktop Connection (mstsc)

### ANDROID

- Microsoft Remote Desktop

---

## 📜 DISCLAIMER

THIS UTILITY IS INTENDED FOR SYSTEM ADMINISTRATION, INFRASTRUCTURE MANAGEMENT, REMOTE ACCESS DEPLOYMENT, AND EDUCATIONAL PURPOSES.

USE ONLY ON SYSTEMS YOU OWN OR HAVE PERMISSION.

---

## 👨‍💻 AUTHOR

**THE GRAYBYT3**

TELEGRAM:

```text
https://t.me/rex_cc
```

---
