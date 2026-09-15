#!/bin/bash
# =======================================================
# /root/init.sh - Universal Setup Script (Soal 1 - 4)
# Otomatis mendeteksi hostname node atau menerima argumen:
# Penggunaan: bash /root/init.sh [router|alice|mika|chisa|knights|eiri]
# =======================================================

NODE_NAME="${1:-$(hostname)}"
NODE_LOWER=$(echo "$NODE_NAME" | tr '[:upper:]' '[:lower:]')

case "$NODE_LOWER" in
    *router*|*debinet*)
        echo "=== Mengonfigurasi Router Lain ==="
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
        ifup -a 2>/dev/null || true
        sysctl -w net.ipv4.ip_forward=1 >/dev/null
        iptables -t nat -C POSTROUTING -o eth0 -j MASQUERADE 2>/dev/null || iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
        echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
        echo "[OK] Router Lain terkonfigurasi!"
        ;;

    *alice*)
        echo "=== Mengonfigurasi Client Alice (192.212.1.2) ==="
        cat << 'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.212.1.2
    netmask 255.255.255.0
    gateway 192.212.1.1
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
        ifup eth0 2>/dev/null || true
        echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
        echo "[OK] Alice terkonfigurasi!"
        ;;

    *mika*)
        echo "=== Mengonfigurasi Client Mika (192.212.1.3) ==="
        cat << 'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.212.1.3
    netmask 255.255.255.0
    gateway 192.212.1.1
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
        ifup eth0 2>/dev/null || true
        echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
        echo "[OK] Mika terkonfigurasi!"
        ;;

    *chisa*)
        echo "=== Mengonfigurasi Client Chisa (192.212.2.2) ==="
        cat << 'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.212.2.2
    netmask 255.255.255.0
    gateway 192.212.2.1
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
        ifup eth0 2>/dev/null || true
        echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
        echo "[OK] Chisa terkonfigurasi!"
        ;;

    *knights*)
        echo "=== Mengonfigurasi Client Knights (192.212.3.2) ==="
        cat << 'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.212.3.2
    netmask 255.255.255.0
    gateway 192.212.3.1
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
        ifup eth0 2>/dev/null || true
        echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
        echo "[OK] Knights terkonfigurasi!"
        ;;

    *eiri*)
        echo "=== Mengonfigurasi Client Eiri (192.212.3.3) ==="
        cat << 'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.212.3.3
    netmask 255.255.255.0
    gateway 192.212.3.1
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
        ifup eth0 2>/dev/null || true
        echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
        echo "[OK] Eiri terkonfigurasi!"
        ;;

    *)
        echo "Node tidak dikenali: '$NODE_NAME'."
        echo "Gunakan: bash /root/init.sh [router|alice|mika|chisa|knights|eiri]"
        exit 1
        ;;
esac

