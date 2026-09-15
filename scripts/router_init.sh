#!/bin/bash
# =======================================================
# /root/init.sh - Router Lain
# Menjalankan seluruh konfigurasi Soal 1 s.d. Soal 4
# =======================================================

echo "[1/4] Mengonfigurasi /etc/network/interfaces Router..."
cat << 'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet dhcp
    up sysctl -w net.ipv4.ip_forward=1
    up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

auto eth1
iface eth1 inet static
    address 192.212.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 192.212.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 192.212.3.1
    netmask 255.255.255.0
EOF

# Terapkan interface
ifup -a 2>/dev/null || true

echo "[2/4] Menyetel DNS Resolver (nameserver 8.8.8.8 & 1.1.1.1)..."
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

echo "[3/4] Mengaktifkan Kernel IP Forwarding..."
sysctl -w net.ipv4.ip_forward=1 >/dev/null

echo "[4/4] Menerapkan iptables NAT Masquerade pada eth0..."
iptables -t nat -C POSTROUTING -o eth0 -j MASQUERADE 2>/dev/null || iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

echo "======================================================="
echo "Konfigurasi Router (Soal 1-4) Berhasil Diterapkan!"
echo "======================================================="

