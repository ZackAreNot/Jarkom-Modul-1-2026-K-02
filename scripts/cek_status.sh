#!/bin/bash
echo "RINGKASAN INTERFACE"
ip -br a
echo ""
echo "STATUS TABEL NAT (IPTABLES)"
iptables -t nat -L -v -n

