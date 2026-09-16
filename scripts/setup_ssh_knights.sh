adduser -D -s /bin/sh mika_admin 2>/dev/null || true
echo "mika_admin:wired123" | chpasswd

mkdir -p /home/mika_admin/.ssh
chmod 700 /home/mika_admin/.ssh

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC05Q6G7mDSvudIz7fISJrVS8zEnflyQNzK7fdzYxrNkWPUoZsCQMuj5jRoZtMU9zP+Qzz2aE05P5MoELObTpoG018B0NYKiakASmoSelqrR+bk32q89r73PnhDwmIkmjeysNg+ixkvhmX4La3PCXyeIPC+Z52uer0JuRYzyl93u1B/5Hd4aQV32HvLziTTzHbbJJV4eTORwHYwEL5RoxIDsN2xnGzBl9AKwSgC08L3sFeCFINEfJ6EnBw5AdvixyqcrmaWeqqOeY55p7/vjyxEcWz6ihXr2+QdElxcQ5MgEEetL6sT98KK8HhNOmRgsSPJgKiEc2zQ/Ow/Y5Y5potd root@Mika" > /home/mika_admin/.ssh/authorized_keys

chmod 600 /home/mika_admin/.ssh/authorized_keys
chmod 755 /home/mika_admin
chown -R mika_admin:mika_admin /home/mika_admin

echo "PubkeyAcceptedAlgorithms +ssh-rsa" >> /etc/ssh/sshd_config
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

killall sshd 2>/dev/null || true
/usr/sbin/sshd
