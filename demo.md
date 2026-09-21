# Panduan Langkah Eksekusi Demo Praktikum (Soal 1 s.d. Soal 13)

Dokumen ini menyajikan urutan instruksi perintah yang siap dijalankan (*run*) pada masing-masing terminal node GNS3 saat sesi demonstrasi praktikum bersama asisten penguji, mulai dari **Soal 1** hingga **Soal 13**.

---

### Tahap 0: Persiapan Awal / Inisialisasi Jaringan (Jika Node Baru Dinyalakan)

Jalankan perintah inisialisasi pada masing-masing node untuk memastikan konfigurasi alamat IP, gateway, DNS resolver, dan routing aktif:

* **Node Lain (Router)**:
  ```bash
  sysctl -w net.ipv4.ip_forward=1
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
  ```

* **Node Alice (`192.212.1.2`)**:
  ```bash
  echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
  ```

* **Node Mika (`192.212.1.3`)**:
  ```bash
  echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
  ```

* **Node Chisa (`192.212.2.2`)**:
  ```bash
  echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
  ```

* **Node Knights (`192.212.3.2`)**:
  ```bash
  echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
  ```

* **Node Eiri (`192.212.3.3`)**:
  ```bash
  echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
  ```

---

### Demo Soal 1: Verifikasi Pengalamatan IP & Subnetting

**Tujuan**: Menunjukkan bahwa setiap node memiliki konfigurasi IP statis sesuai prefix kelompok `192.212.x.x` dan terhubung ke default gateway subnet masing-masing.

1. **Pada Node Lain (Router)**:
   ```bash
   ip -br a
   ```
   *Hasil yang diharapkan: Menampilkan interface `eth0` (WAN/NAT), `eth1` (`192.212.1.1/24`), `eth2` (`192.212.2.1/24`), dan `eth3` (`192.212.3.1/24`).*

2. **Pada Node Alice (`192.212.1.2`)**:
   ```bash
   ping -c 2 192.212.1.1
   ```
   *Hasil yang diharapkan: 0% packet loss ke gateway Subnet 1.*

3. **Pada Node Chisa (`192.212.2.2`)**:
   ```bash
   ping -c 2 192.212.2.1
   ```
   *Hasil yang diharapkan: 0% packet loss ke gateway Subnet 2.*

4. **Pada Node Eiri (`192.212.3.3`) / Knights (`192.212.3.2`)**:
   ```bash
   ping -c 2 192.212.3.1
   ```
   *Hasil yang diharapkan: 0% packet loss ke gateway Subnet 3.*

---

### Demo Soal 2: Verifikasi Akses Internet pada Router Lain

**Tujuan**: Menunjukkan bahwa Router Lain berhasil terhubung ke jaringan publik melalui NAT dan DNS resolver berfungsi.

1. **Pada Node Lain (Router)**:
   ```bash
   ping -c 3 8.8.8.8
   ping -c 3 google.com
   ```
   *Hasil yang diharapkan: Ping berhasil dengan 0% packet loss baik via IP publik maupun domain name.*

---

### Demo Soal 3: Verifikasi Akses Internet untuk Seluruh Entitas (Client)

**Tujuan**: Menunjukkan bahwa klien di dalam jaringan privat dapat mengakses internet publik berkat fitur IP Forwarding dan Source NAT Masquerade pada router.

1. **Pada Node Lain (Router)** (Verifikasi Forwarding & NAT):
   ```bash
   cat /proc/sys/net/ipv4/ip_forward
   iptables -t nat -L POSTROUTING -n -v
   ```
   *Hasil yang diharapkan: Nilai `1` dan terdapat rule `MASQUERADE` pada interface `eth0`.*

2. **Pada Node Alice**:
   ```bash
   ping -c 3 google.com
   ```
   *Hasil yang diharapkan: 0% packet loss.*

3. **Pada Node Chisa**:
   ```bash
   ping -c 3 google.com
   ```
   *Hasil yang diharapkan: 0% packet loss.*

4. **Pada Node Knights**:
   ```bash
   ping -c 3 google.com
   ```
   *Hasil yang diharapkan: 0% packet loss.*

---

### Demo Soal 4: Verifikasi Routing Antar Entitas (Inter-Subnet Routing)

**Tujuan**: Membuktikan bahwa seluruh entitas pada subnet yang berbeda dapat saling berkomunikasi secara penuh melalui router.

1. **Pada Node Alice (`192.212.1.2`)** uji koneksi ke **Chisa (`192.212.2.2`)**:
   ```bash
   ping -c 3 192.212.2.2
   ```
   *Hasil yang diharapkan: 0% packet loss antar subnet 1 dan subnet 2.*

2. **Pada Node Mika (`192.212.1.3`)** uji koneksi ke **Knights (`192.212.3.2`)**:
   ```bash
   ping -c 3 192.212.3.2
   ```
   *Hasil yang diharapkan: 0% packet loss antar subnet 1 dan subnet 3.*

3. **Pada Node Eiri (`192.212.3.3`)** uji koneksi ke **Alice (`192.212.1.2`)**:
   ```bash
   ping -c 3 192.212.1.2
   ```
   *Hasil yang diharapkan: 0% packet loss antar subnet 3 dan subnet 1.*

---

### Demo Soal 5: Inspeksi Resolusi Alamat (ARP Table & Cache)

**Tujuan**: Memperlihatkan tabel ARP lokal yang memetakan alamat IP logis ke alamat MAC fisik perangkat dalam satu segmen jaringan.

1. **Pada Node Alice (`192.212.1.2`)**:
   ```bash
   arp -a
   ```
   *Hasil yang diharapkan: Menampilkan entri IP tetangga (misal `192.212.1.1` dan `192.212.1.3`) beserta MAC address hardware masing-masing.*

2. **Demonstrasi Live Refresh ARP**:
   ```bash
   ip neigh flush all
   ping -c 1 192.212.1.3
   arp -a
   ```
   *Hasil yang diharapkan: Cache ARP terisi kembali setelah paket ARP Request/Reply selesai dipertukarkan.*

---

### Demo Soal 6: Analisis Pola Trafik Subnet LAN 1

**Tujuan**: Memperlihatkan penangkapan dan inspeksi paket data pada segmen LAN 1 menggunakan `tcpdump`.

1. **Pada Node Mika (`192.212.1.3`)**, aktifkan sniffer tcpdump:
   ```bash
   tcpdump -i eth0 -nn -c 4
   ```

2. **Buka terminal Node Alice (`192.212.1.2`)**, kirimkan paket uji:
   ```bash
   ping -c 2 192.212.1.3
   ```

3. *Hasil yang diharapkan: Terminal Mika seketika menampilkan baris paket ICMP Echo Request dan Echo Reply yang tertangkap secara real-time.*

---

### Demo Soal 7: Demonstrasi Layanan File Sharing vsFTPd Terpusat

**Tujuan**: Membuktikan konfigurasi hak akses FTP di node Chisa (`192.212.2.2`): Alice (Read & Write), Mika (Read-Only), dan Eiri (Blacklist).

1. **Pastikan Service vsFTPd Aktif di Node Chisa**:
   ```bash
   sh /root/setup_ftp_chisa.sh
   ```

2. **Uji Akses Pengguna Alice di Node Alice (Read & Write)**:
   ```bash
   sh /root/test_ftp_alice.sh
   ```
   *Hasil yang diharapkan: Upload berkas `test_alice.txt` sukses (`Transfer complete`) dan download berkas sukses.*

3. **Uji Akses Pengguna Mika di Node Mika (Read-Only)**:
   ```bash
   sh /root/test_ftp_mika.sh
   ```
   *Hasil yang diharapkan: Pengunduhan file berhasil, namun saat mencoba mengunggah file `mika_test_upload.txt` muncul penolakan: `550 Permission denied`.*

4. **Uji Akses Pengguna Eiri di Node Eiri (Blacklist / Tolak Akses)**:
   ```bash
   sh /root/test_ftp_eiri.sh
   ```
   *Hasil yang diharapkan: Login langsung ditolak oleh server dengan status `530 Login incorrect`.*

---

### Demo Soal 8: Pengunggahan Dokumen Laporan Rahasia oleh Knights

**Tujuan**: Membuktikan node Knights mengunggah file `knights_report.txt` (1111 byte) ke server FTP Chisa dengan akun `alice`.

1. **Pada Node Knights**:
   ```bash
   sh /root/upload_knights.sh
   ```
   *Hasil yang diharapkan: Berkas `knights_report.txt` terunggah sukses ke server Chisa.*

2. **Verifikasi Keberadaan Berkas di Node Chisa**:
   ```bash
   ls -la /var/wired/data/knights_report.txt
   ```
   *Hasil yang diharapkan: Berkas terdaftar di direktori `/var/wired/data/` dengan ukuran persis **1111** byte.*

---

### Demo Soal 9: Pengunduhan Dokumen Protokol Tujuh oleh Mika

**Tujuan**: Membuktikan node Mika dapat mengunduh berkas `protocol7_manifesto.txt` dan tidak dapat mengunggah berkas baru ke server Chisa.

1. **Pada Node Mika**:
   ```bash
   sh /root/test_ftp_mika.sh
   ```
   *Hasil yang diharapkan: Berkas `protocol7_manifesto.txt` berhasil diunduh, dan percobaan upload menghasilkan pesan `550 Permission denied`.*

2. **Verifikasi Berkas yang Telah Terunduh di Node Mika**:
   ```bash
   ls -la /root/protocol7_manifesto.txt
   head -n 5 /root/protocol7_manifesto.txt
   ```
   *Hasil yang diharapkan: Berkas tersimpan lokal di node Mika dan isinya dapat dibaca.*

---

### Demo Soal 10: Uji Ketahanan Konektivitas ICMP (Knights ke Chisa)

**Tujuan**: Mengirimkan 77 paket ping dengan ukuran payload 128 byte dan interval agresif 0.3 detik dari Knights ke Chisa tanpa kehilangan paket.

1. **Pada Node Knights**:
   ```bash
   ping -c 77 -s 128 -i 0.3 192.212.2.2
   ```
   *Hasil yang diharapkan: 77 packets transmitted, 77 packets received, **0% packet loss**, dan ringkasan RTT.*

---

### Demo Soal 11: Layanan Remote Access Telnet di Chisa

**Tujuan**: Membuktikan daemon Telnet aktif di node Chisa dengan kredensial `phantom_user` / `wired_ghost`, serta Eiri dapat login remote.

1. **Pastikan Layanan Telnet Aktif di Node Chisa**:
   ```bash
   sh /root/setup_telnet_chisa.sh
   ```

2. **Lakukan Koneksi Telnet dari Node Eiri**:
   ```bash
   telnet 192.212.2.2
   ```
   Masukkan:
   - Username: `phantom_user`
   - Password: `wired_ghost`

3. **Setelah Berhasil Masuk ke Shell Chisa**:
   ```bash
   whoami
   ip a
   exit
   ```
   *Hasil yang diharapkan: Perintah `whoami` mengembalikan `phantom_user` dan prompt kembali ke shell lokal Eiri setelah `exit`.*

---

### Demo Soal 12: Pemindaian Port TCP Jaringan oleh Alice ke Knights

**Tujuan**: Membuktikan status port pada node Knights: Port 22 (SSH) dan Port 80 (HTTP) terbuka, sedangkan Port 7777 tertutup.

1. **Pastikan Layanan Aktif di Node Knights**:
   ```bash
   sh /root/setup_services_knights.sh
   ```
   Verifikasi socket listening di Knights:
   ```bash
   netstat -tlpn
   ```

2. **Jalankan Pemindaian Port pada Node Alice**:
   ```bash
   nc -zv -w 2 192.212.3.2 22
   nc -zv -w 2 192.212.3.2 80
   nc -zv -w 2 192.212.3.2 7777
   ```
   *Hasil yang diharapkan:*
   - `Connection to 192.212.3.2 22 port [tcp/ssh] succeeded!` *(Port Terbuka)*
   - `Connection to 192.212.3.2 80 port [tcp/http] succeeded!` *(Port Terbuka)*
   - `nc: connect to 192.212.3.2 port 7777 (tcp) failed: Connection refused` *(Port Tertutup)*

---

### Demo Soal 13: Remote Login Aman via SSH Key-Based Authentication

**Tujuan**: Membuktikan node Mika dapat login SSH ke Knights sebagai pengguna `mika_admin` tanpa kata sandi interaktif menggunakan pasangan kunci kriptografi RSA, serta Knights menolak autentikasi kata sandi.

1. **Pastikan Konfigurasi SSH Server Siap di Node Knights**:
   ```bash
   sh /root/setup_ssh_knights.sh
   ```

2. **Pastikan Kunci SSH Siap di Node Mika**:
   ```bash
   sh /root/setup_ssh_mika.sh
   ```

3. **Sinkronisasi Kunci Publik Mika ke Knights (via Netcat)**:
   - Pada Node Knights (jalankan listener):
     ```bash
     nc -l -p 9999 > /home/mika_admin/.ssh/authorized_keys
     ```
   - Pada Node Mika (kirim kunci publik):
     ```bash
     nc 192.212.3.2 9999 < /home/mika_admin/.ssh/id_rsa.pub
     ```
     *(Tekan Ctrl+C di Knights setelah beberapa detik jika prompt belum kembali otomatis)*
   - Pada Node Knights (perbarui permission dan restart SSH server):
     ```bash
     chmod 600 /home/mika_admin/.ssh/authorized_keys
     chown -R mika_admin:mika_admin /home/mika_admin/.ssh
     killall sshd 2>/dev/null || true
     /usr/sbin/sshd
     ```

4. **Lakukan Login SSH dari Node Mika ke Knights**:
   ```bash
   su - mika_admin -c "ssh -o StrictHostKeyChecking=no mika_admin@192.212.3.2"
   ```

5. **Verifikasi Sesi Login di Terminal**:
   ```bash
   whoami
   hostname
   exit
   ```
   *Hasil yang diharapkan: Login langsung masuk ke prompt `Knights:~$` tanpa meminta kata sandi, `whoami` menampilkan `mika_admin`, dan `exit` mengembalikan pengguna ke Mika.*


