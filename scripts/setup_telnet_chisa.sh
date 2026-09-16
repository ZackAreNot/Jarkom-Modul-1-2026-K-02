apk update && apk add --no-cache busybox-extras

adduser -D -s /bin/sh phantom_user 2>/dev/null || true
echo "phantom_user:wired_ghost" | chpasswd

killall telnetd 2>/dev/null || true
telnetd -p 23

netstat -tlpn | grep 23

