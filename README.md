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
```

If you want to skip the confirmation prompt, add `--force`:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/shahinrtm/Install-MikroTik-CHR-on-VPS/main/last_mk_install.sh)" -- --force
```

---

## 🧩 What It Does
1. Detects your **network interface**, IP address, and gateway.  
2. Fetches the **latest RouterOS 7.x** version automatically.  
3. Downloads and extracts the CHR image (`.img.zip`).  
4. Detects your **root disk** (e.g. `/dev/sda`, `/dev/nvme0n1`).  
5. Writes the CHR image directly to the root disk using `dd`.  
6. Performs a **hard reboot** into MikroTik RouterOS.

---

## 🖥️ After Reboot
- Your VPS will boot into **MikroTik RouterOS CHR**.  
- Default username: `admin`  
- Default password: *(blank)*  
- You can connect via:
  - Winbox (using the VPS IP)
  - SSH (`ssh admin@<your-vps-ip>`)

---

## 🧰 Requirements
Make sure these packages are installed before running the script:
```bash
sudo apt update
sudo apt install -y curl unzip coreutils util-linux iproute2
```

---

## 🛑 Warning
- This script **completely wipes your disk**.  
- Do **not** run it on a system you want to keep.  
- Only for VPS or servers you plan to turn into a **dedicated MikroTik CHR**.

---

## 🧠 Credits
Created by [**@shahinrtm**](https://github.com/shahinrtm)  
Inspired by [azadrahorg]([https://azadrah.org](https://github.com/azadrahorg)) installer concept.  

---

## 📜 License
MIT License — Free to use, modify, and share.
