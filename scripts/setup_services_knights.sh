apk update && apk add --no-cache openssh busybox-extras

ssh-keygen -A
/usr/sbin/sshd
httpd -p 80

netstat -tlpn | grep -E '22|80'

