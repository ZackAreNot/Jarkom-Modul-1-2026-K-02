apk update && apk add --no-cache lftp

lftp -u eiri,wired123 192.212.2.2 << 'FTP_EOF'
set ftp:ssl-allow no
set net:max-retries 1
ls
bye
FTP_EOF
