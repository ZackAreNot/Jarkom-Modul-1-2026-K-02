apk update && apk add --no-cache netcat-openbsd

nc -zv -w 2 192.212.3.2 22
nc -zv -w 2 192.212.3.2 80
nc -zv -w 2 192.212.3.2 7777

