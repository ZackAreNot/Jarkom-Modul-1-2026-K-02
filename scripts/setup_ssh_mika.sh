apk update && apk add --no-cache openssh-client

adduser -D -s /bin/sh mika_admin 2>/dev/null || true

mkdir -p /home/mika_admin/.ssh
chmod 700 /home/mika_admin/.ssh

rm -f /home/mika_admin/.ssh/id_rsa*
ssh-keygen -t rsa -b 2048 -f /home/mika_admin/.ssh/id_rsa -N ""

chown -R mika_admin:mika_admin /home/mika_admin/.ssh

cat /home/mika_admin/.ssh/id_rsa.pub

