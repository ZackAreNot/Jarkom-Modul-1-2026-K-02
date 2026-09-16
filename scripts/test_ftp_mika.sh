apk update && apk add --no-cache lftp

echo "This is a test upload from Mika to test read-only policy." > /root/mika_test_upload.txt

lftp -u mika,wired123 192.212.2.2 << 'FTP_EOF'
set ftp:ssl-allow no
set net:max-retries 1
get protocol7_manifesto.txt
put /root/mika_test_upload.txt
bye
FTP_EOF

cat /root/protocol7_manifesto.txt

