# Laporan Resmi Praktikum Modul 1
### Komunikasi Data & Jaringan Komputer 2026

**Kelompok:** K-02  
**Prefix IP Kelompok:** `192.212.x.x`  
**Tema:** *Serial Experiments Lain*  

---

## Soal 1

### Soal
> Untuk mempersiapkan pembangunan The Wired, Lain yang berperan sebagai Router membuat tiga Switch/Gateway: Switch 1 menuju dua Entitas yaitu Alice dan Mika, Switch 2 menuju Chisa, sedangkan Switch 3 menuju Knights dan Eiri. Kelima Entitas tersebut dikonfigurasi sebagai Client di GNS3. [GUNAKAN PREFIX IP MASING-MASING KELOMPOK]

### Langkah Pengerjaan

1. **Menambahkan Node pada GNS3**:
   - 1 node Debian (`debinet-1`) sebagai **Router Lain** (diatur memiliki 4 interface network adapter).
   - 3 node **Ethernet Switch** (`Switch1`, `Switch2`, `Switch3`).
   - 5 node Alpine (`alpinet`) sebagai Client: **Alice**, **Mika**, **Chisa**, **Knights**, dan **Eiri**.

2. **Pengkabelan (Wiring)**:
   - **Router Lain**:
     - `eth0` $\rightarrow$ NAT1
     - `eth1` $\rightarrow$ Switch1
     - `eth2` $\rightarrow$ Switch2
     - `eth3` $\rightarrow$ Switch3
   - **Switch1** $\rightarrow$ Alice (`eth0`), Mika (`eth0`)
   - **Switch2** $\rightarrow$ Chisa (`eth0`)
   - **Switch3** $\rightarrow$ Knights (`eth0`), Eiri (`eth0`)

3. **Konfigurasi Interface (`/etc/network/interfaces`)**:

   - **Router Lain**:
     ```bash
     auto eth0
     iface eth0 inet dhcp

     auto eth1
     iface eth1 inet static
         address 192.212.1.1
         netmask 255.255.255.0

     auto eth2
     iface eth2 inet static
         address 192.212.2.1
         netmask 255.255.255.0

     auto eth3
     iface eth3 inet static
         address 192.212.3.1
         netmask 255.255.255.0
     ```

   - **Alice (`alpinet-1`)**:
     ```bash
     auto eth0
     iface eth0 inet static
         address 192.212.1.2
         netmask 255.255.255.0
         gateway 192.212.1.1
     ```

   - **Mika (`alpinet-2`)**:
     ```bash
     auto eth0
     iface eth0 inet static
         address 192.212.1.3
         netmask 255.255.255.0
         gateway 192.212.1.1
     ```

   - **Chisa (`alpinet-3`)**:
     ```bash
     auto eth0
     iface eth0 inet static
         address 192.212.2.2
         netmask 255.255.255.0
         gateway 192.212.2.1
     ```

   - **Knights (`alpinet-4`)**:
     ```bash
     auto eth0
     iface eth0 inet static
         address 192.212.3.2
         netmask 255.255.255.0
         gateway 192.212.3.1
     ```

   - **Eiri (`alpinet-5`)**:
     ```bash
     auto eth0
     iface eth0 inet static
         address 192.212.3.3
         netmask 255.255.255.0
         gateway 192.212.3.1
     ```

4. **Menjalankan dan Menerapkan Konfigurasi**:
   - Simpan konfigurasi pada setiap node.
   - Jalankan perintah `ifup -a` (atau restart node) di GNS3 agar seluruh konfigurasi antarmuka diterapkan.

### Bukti dan Hasil

1. **Topologi Jaringan di GNS3**:
   ![Topologi GNS3](images/soal-1/topologi.png)

2. **Verifikasi Alamat IP Router Lain (`ip -br a`)**:
   ![IP Router Lain](images/soal-1/ip-router.png)

3. **Uji Ping ke Gateway Masing-Masing Subnet**:
   - **Alice $\rightarrow$ Gateway Subnet 1 (`192.212.1.1`)**:
     ![Ping Gateway Subnet 1](images/soal-1/ping-gateway-sw1.png)

   - **Chisa $\rightarrow$ Gateway Subnet 2 (`192.212.2.1`)**:
     ![Ping Gateway Subnet 2](images/soal-1/ping-gateway-sw2.png)

   - **Eiri $\rightarrow$ Gateway Subnet 3 (`192.212.3.1`)**:
     ![Ping Gateway Subnet 3](images/soal-1/ping-gateway-sw3.png)

---

## Soal 2

### Soal
> Karena menurut Lain pada saat itu The Wired masih terisolasi dari dunia luar, konfigurasikan router Lain agar dapat tersambung langsung ke jaringan internet publik melalui NAT/DHCP pada interface eth0.

### Langkah Pengerjaan

1. **Konfigurasi DHCP pada Interface `eth0` Router Lain**:
   Menghubungkan interface `eth0` Router Lain ke interface `nat0` pada node `NAT1`, kemudian mengatur `eth0` menggunakan mode DHCP pada file `/etc/network/interfaces`:
   ```bash
   auto eth0
   iface eth0 inet dhcp
   ```

2. **Konfigurasi DNS Resolver**:
   Menambahkan nameserver pada `/etc/resolv.conf` di Router Lain agar dapat melakukan translasi nama domain ke IP internet:
   ```bash
   nameserver 8.8.8.8
   nameserver 1.1.1.1
   ```

3. **Pengujian Konektivitas**:
   Melakukan verifikasi koneksi dari konsol Router Lain dengan mengirimkan ping ke IP publik Google (`8.8.8.8`) dan ke nama domain (`google.com`).

### Bukti dan Hasil

1. **Uji Koneksi Internet Publik (IP & Domain)**:
   ![Uji Koneksi Internet Router](images/soal-2/ping-internet-router.png)
   *Hasil pengujian menunjukkan bahwa Router Lain berhasil tersambung ke jaringan internet publik melalui interface eth0 (DHCP NAT) dengan bukti balasan ping ke `8.8.8.8` dan `google.com` bernilai 0% packet loss.*

---

## Soal 3

### Soal
> Setelah router Lain terhubung ke internet, pastikan seluruh Entitas (Client) di bawah Switch 1, Switch 2, dan Switch 3 dapat saling terhubung dan berkomunikasi satu sama lain melalui konfigurasi routing.

### Langkah Pengerjaan

1. **Mengaktifkan IP Forwarding pada Router Lain**:
   Agar router dapat meneruskan paket antar-interface (antar-subnet yang terhubung langsung ke `eth1`, `eth2`, dan `eth3`), fitur perutean paket pada kernel Linux diaktifkan melalui perintah:
   ```bash
   sysctl -w net.ipv4.ip_forward=1
   ```
   Verifikasi nilai kernel IP forwarding aktif (bernilai `1`):
   ```bash
   cat /proc/sys/net/ipv4/ip_forward
   ```

2. **Pengujian Routing Antar-Entitas (Inter-Subnet)**:
   Melakukan uji konektivitas antar-client yang berada di switch berbeda:
   - Dari **Alice** (`192.212.1.2` di Switch 1) menuju **Chisa** (`192.212.2.2` di Switch 2).
   - Dari **Alice** (`192.212.1.2` di Switch 1) menuju **Knights** (`192.212.3.2` di Switch 3).

### Bukti dan Hasil

1. **Verifikasi IP Forwarding Aktif di Router Lain**:
   ![IP Forwarding Aktif](images/soal-3/ip-forward.png)
   *Pengecekan `/proc/sys/net/ipv4/ip_forward` menghasilkan nilai `1` yang menandakan Router Lain siap meneruskan lalu lintas antar-subnet.*

2. **Uji Ping Alice ke Chisa (Switch 1 $\rightarrow$ Switch 2)**:
   ![Ping Alice ke Chisa](images/soal-3/ping-alice-ke-chisa.png)
   *Ping dari Alice ke Chisa (`192.212.2.2`) berhasil dengan 0% packet loss dan TTL bernilai 63 (berkurang 1 hop saat melintasi Router Lain).*

3. **Uji Ping Alice ke Knights (Switch 1 $\rightarrow$ Switch 3)**:
   ![Ping Alice ke Knights](images/soal-3/ping-alice-ke-knights.png)
   *Ping dari Alice ke Knights (`192.212.3.2`) berhasil dengan 0% packet loss dan TTL bernilai 63.*

---

## Soal 4

### Soal
> Lain ingin agar setiap Entitas (Client) memiliki kemandirian di The Wired. Konfigurasikan firewall/iptables (NAT Masquerade) dan DNS resolver agar setiap Client dapat terhubung ke internet secara mandiri (dapat melakukan ping ke 8.8.8.8 dan membuka domain web google.com).

### Langkah Pengerjaan

1. **Konfigurasi NAT Masquerade pada Router Lain**:
   Menerapkan aturan iptables pada chain `POSTROUTING` dengan interface keluar `eth0` agar seluruh paket dari segmen LAN (`192.212.x.x`) disamarkan alamat sumbernya menjadi IP milik `eth0` Router saat menuju jaringan luar:
   ```bash
   iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
   ```
   Memeriksa tabel NAT untuk memastikan rule aktif:
   ```bash
   iptables -t nat -L -v -n
   ```

2. **Konfigurasi DNS Resolver pada Client**:
   Menambahkan nameserver publik (`8.8.8.8` dan `1.1.1.1`) ke file `/etc/resolv.conf` pada seluruh entitas client agar dapat mengenali nama domain internet:
   ```bash
   nameserver 8.8.8.8
   nameserver 1.1.1.1
   ```

3. **Pengujian Konektivitas Internet dari Client**:
   Melakukan uji coba konektivitas dari konsol client (Eiri) dengan mengirimkan ping ke IP publik (`8.8.8.8`) dan domain web (`google.com`).

### Bukti dan Hasil

1. **Verifikasi Tabel NAT di Router Lain**:
   ![Tabel NAT Router](images/soal-4/iptables-nat.png)
   *Tabel NAT chain POSTROUTING menunjukkan rule target MASQUERADE aktif pada interface eth0 untuk semua traffic (0.0.0.0/0).*

2. **Uji Koneksi Internet dari Client (Eiri)**:
   ![Ping Internet Eiri](images/soal-4/ping-internet-eiri.png)
   *Client Eiri (`192.212.3.3`) berhasil melakukan ping ke `8.8.8.8` dan domain web `google.com` dengan 0% packet loss, membuktikan bahwa client memiliki akses internet mandiri via NAT Masquerade dan DNS resolver.*

---

## Soal 5

### Soal
> Eiri tetap berupaya menanamkan kekacauan ke dalam jaringan. Untuk mengantisipasi restart tiba-tiba, pastikan seluruh konfigurasi jaringan tidak hilang saat semua node di-restart. Buat script verifikasi di `/root/cek_status.sh` pada router Lain yang menampilkan ringkasan interface (`ip -br a`) dan status tabel NAT (`iptables -t nat -L -v -n`) setelah reboot.

### Langkah Pengerjaan

1. **Menjaga Persistensi Konfigurasi Jaringan**:
   Seluruh konfigurasi interface, kernel IP forwarding, iptables NAT Masquerade, dan DNS didaftarkan ke dalam file `/etc/network/interfaces` serta dibuatkan script otomatisasi `/root/init.sh` yang dipanggil melalui `/root/.bashrc` agar dieksekusi secara otomatis setiap kali sistem menyala.

2. **Pembuatan Script Verifikasi `/root/cek_status.sh`**:
   Membuat script pada direktori root (`/root/cek_status.sh`) di Router Lain yang menampilkan ringkasan IP antarmuka dan tabel NAT:
   ```bash
   cat << 'EOF' > /root/cek_status.sh
   #!/bin/bash
   echo "RINGKASAN INTERFACE"
   ip -br a
   echo ""
   echo "STATUS TABEL NAT (IPTABLES)"
   iptables -t nat -L -v -n
   EOF
   chmod +x /root/cek_status.sh
   ```

3. **Verifikasi Pasca-Reboot**:
   Melakukan restart pada node Router Lain (Stop $\rightarrow$ Start di GNS3), kemudian mengeksekusi `/root/cek_status.sh` untuk membuktikan bahwa konfigurasi tetap bertahan dan tidak hilang.

### Bukti dan Hasil

1. **Pembuatan Script `/root/cek_status.sh`**:
   ![Pembuatan Script Cek Status](images/soal-5/script-cek-status.png)
   *Isi file script `/root/cek_status.sh` pada Router Lain.*

2. **Eksekusi Script Pasca-Reboot**:
   ![Eksekusi Cek Status](images/soal-5/eksekusi-cek-status.png)
   *Hasil eksekusi `/root/cek_status.sh` setelah reboot membuktikan bahwa seluruh interface (`eth0`, `eth1`, `eth2`, `eth3`) tetap UP dengan pengalamatan IP yang sesuai, serta tabel NAT Masquerade tetap bertahan dan aktif mencatat paket lalu lintas jaringan.*

---

## Soal 6

### Soal
> Mika mencurigai adanya anomali traffic pada segmen jaringannya. Jalankan generator traffic berikut pada node Mika, lalu lakukan packet sniffing menggunakan Wireshark pada interface node Mika. Terapkan display filter khusus untuk menyaring paket yang berprotokol DNS atau ICMP. Tunjukkan screenshot hasil filter beserta ringkasan paket yang lolos.

### Langkah Pengerjaan

1. **Menjalankan Script Generator Traffic**:
   Menjalankan script `/root/traffic_protocol7.sh` pada node Mika untuk menghasilkan anomali lalu lintas data berupa paket ICMP (ping ke berbagai IP) dan query DNS (nslookup & dig ke berbagai domain).

2. **Packet Sniffing dengan Wireshark**:
   Melakukan penyadapan paket (*packet sniffing*) secara live pada link antarmuka antara `Switch1` dan `Mika` (`eth0`) menggunakan Wireshark.

3. **Penerapan Display Filter**:
   Menerapkan display filter khusus untuk memilah paket yang hanya berprotokol DNS atau ICMP:
   ```text
   dns || icmp
   ```

### Bukti dan Hasil

1. **Eksekusi Generator Traffic di Mika**:
   ![Eksekusi Traffic Generator](images/soal-6/eksekusi-generator.png)
   *Proses eksekusi `/root/traffic_protocol7.sh` pada node Mika berhasil membangkitkan lalu lintas jaringan DNS dan ICMP.*

2. **Hasil Display Filter Wireshark & Ringkasan Paket**:
   ![Filter DNS dan ICMP Wireshark](images/soal-6/filter-dns-icmp.png)
   *Penerapan display filter `dns || icmp` (berwarna hijau) berhasil menyaring seluruh paket terkait. Berdasarkan status bar Wireshark, dari total 66 paket yang tertangkap, terdapat **58 paket (84.8%)** yang lolos filter berprotokol DNS dan ICMP.*
