apk update && apk add --no-cache vsftpd
mkdir -p /var/wired/data /etc/vsftpd/user_conf
adduser -D -h /var/wired/data -s /bin/sh alice 2>/dev/null || true
echo "alice:wired123" | chpasswd

adduser -D -h /var/wired/data -s /bin/sh mika 2>/dev/null || true
echo "mika:wired123" | chpasswd

adduser -D -h /var/wired/data -s /bin/sh eiri 2>/dev/null || true
echo "eiri:wired123" | chpasswd

chmod -R 777 /var/wired/data

cat << 'USER_EOF' > /etc/vsftpd/user_conf/alice
write_enable=YES
local_root=/var/wired/data
USER_EOF

cat << 'USER_EOF' > /etc/vsftpd/user_conf/mika
write_enable=NO
local_root=/var/wired/data
USER_EOF

echo "eiri" > /etc/vsftpd/user_list

cat << 'CONF_EOF' > /etc/vsftpd/vsftpd.conf
listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
local_root=/var/wired/data
chroot_local_user=YES
allow_writeable_chroot=YES
seccomp_sandbox=NO
user_config_dir=/etc/vsftpd/user_conf
userlist_enable=YES
userlist_file=/etc/vsftpd/user_list
userlist_deny=YES
pasv_enable=YES
pasv_min_port=30000
pasv_max_port=30005
CONF_EOF

killall vsftpd 2>/dev/null || true
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf &
