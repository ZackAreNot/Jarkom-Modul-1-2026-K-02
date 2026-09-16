apk update && apk add --no-cache lftp

echo "Signal from Alice to The Wired - Connection Verified." > /root/signal_alice.txt

lftp -u alice,wired123 192.212.2.2 << 'FTP_EOF'
set ftp:ssl-allow no
set net:max-retries 1
put /root/signal_alice.txt
ls
bye
FTP_EOF
