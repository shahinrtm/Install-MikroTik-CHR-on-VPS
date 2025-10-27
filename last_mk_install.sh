#!/usr/bin/env bash
set -euo pipefail

# === shahinrtm ===
# === https://github.com/shahinrtm ===
# === MikroTik CHR Latest 7.x Installer (overwrite ROOT disk) ===
# Usage: sudo bash last_mk_install.sh [--force]

FORCE="${1:-}"

need_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "Missing dependency: $1"; exit 1; }; }
need_cmd curl; need_cmd unzip; need_cmd lsblk; need_cmd awk; need_cmd dd
need_cmd ip; need_cmd grep; need_cmd sed; need_cmd sort; need_cmd findmnt

[[ $EUID -eq 0 ]] || { echo "Please run as root (sudo)."; exit 1; }

echo "=== Network info ==="
ETH="$(ip route show default 0.0.0.0/0 | awk '/default/ {print $5; exit}')"
ADDRESS="$(ip -o -4 addr show dev "${ETH:-}" | awk '{print $4}' | head -n1)"
GATEWAY="$(ip route show default | awk '/default/ {print $3; exit}')"
echo "IFACE   : ${ETH:-unknown}"
echo "ADDRESS : ${ADDRESS:-unknown}"
echo "GATEWAY : ${GATEWAY:-unknown}"

echo
echo "=== Detecting latest RouterOS 7.x (CHR) ==="
# === Detecting latest RouterOS 7.x (CHR) via upgrade API (no 403) ===
LATEST="$(curl -fsSL https://upgrade.mikrotik.com/routeros/NEWESTa7.stable | awk '{print $1}')"
DL_URL="https://download.mikrotik.com/routeros/${LATEST}/chr-${LATEST}.img.zip"
echo "Latest version : ${LATEST}"
echo "Download URL   : ${DL_URL}"

echo
echo "=== Downloading & unpacking ==="
rm -f chr.img chr.img.zip
curl -fSLo chr.img.zip "${DL_URL}"
unzip -p chr.img.zip > chr.img
[[ -s chr.img ]] || { echo "Unpack failed (chr.img is empty)."; exit 1; }
sync

echo
echo "=== Resolving ROOT disk (will be OVERWRITTEN) ==="
ROOT_SRC="$(findmnt -n -o SOURCE /)"
echo "Root mount source: ${ROOT_SRC}"
ROOT_DISK="$(lsblk -no PKNAME "${ROOT_SRC}" 2>/dev/null || true)"
[[ -n "${ROOT_DISK}" ]] || ROOT_DISK="$(lsblk -no NAME,TYPE -s "${ROOT_SRC}" 2>/dev/null | awk '$2=="disk"{print $1; exit}')"
[[ -n "${ROOT_DISK}" ]] || ROOT_DISK="$(basename "${ROOT_SRC}")"
[[ -n "${ROOT_DISK}" ]] || { echo "Could not detect root disk."; exit 1; }
echo "Root disk       : ${ROOT_DISK} (/dev/${ROOT_DISK})"

echo
echo "=== Summary ==="
echo "Will WRITE chr image to the ROOT DISK: /dev/${ROOT_DISK}"
echo "This will IRREVERSIBLY ERASE the entire disk and reboot immediately."
if [[ "${FORCE}" != "--force" ]]; then
  read -r -p "Type 'ERASE /dev/${ROOT_DISK}' to confirm: " CONFIRM
  [[ "${CONFIRM}" == "ERASE /dev/${ROOT_DISK}" ]] || { echo "Confirmation mismatch. Aborting."; exit 1; }
else
  echo "--force provided; skipping interactive confirmation."
fi

echo
echo "=== Writing image to /dev/${ROOT_DISK} ==="
while read -r mp; do
  if [[ -n "${mp}" && "${mp}" != "/" ]]; then
    echo "Unmounting ${mp}"
    umount -f "${mp}" || true
  fi
done < <(lsblk -nr -o MOUNTPOINT "/dev/${ROOT_DISK}" | awk 'NF')
sync
command -v wipefs >/dev/null 2>&1 && wipefs -a "/dev/${ROOT_DISK}" || true
dd if=chr.img of="/dev/${ROOT_DISK}" bs=4M conv=fsync status=progress
sync

echo
echo "=== Done. Forcing immediate reboot (sysrq) ==="
echo 1 > /proc/sys/kernel/sysrq || true
echo b > /proc/sysrq-trigger || true
reboot -f || true
