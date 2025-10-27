# 🌀 Install MikroTik CHR on VPS
> **Author:** [shahinrtm](https://github.com/shahinrtm)  
> Automated installer for **MikroTik Cloud Hosted Router (CHR)** — replaces Ubuntu or any Linux OS on VPS with the **latest RouterOS 7.x**.

---

## ⚙️ Description
This script automatically downloads the **latest stable MikroTik CHR (RouterOS 7.x)** image, writes it directly onto your **root disk**, and reboots the system.  
It’s designed for VPS or dedicated servers where you want to completely replace Ubuntu or another Linux OS with MikroTik RouterOS.

---

## 🚀 Quick Install (One Command)
> ⚠️ **Warning:** This will **erase the entire disk** and reboot immediately.  
> Make sure you’ve backed up your data and are ready to install MikroTik.

Run this command as root (or with `sudo`):

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/shahinrtm/Install-MikroTik-CHR-on-VPS/main/last_mk_install.sh)"
