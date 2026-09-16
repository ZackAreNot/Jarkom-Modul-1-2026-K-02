## Soal 14

### Soal
> Setelah gagal mengakses FTP, Eiri melancarkan serangan brute-force terhadap form login web Alice. Analisis file capture wired_bruteforce.pcapng untuk mengidentifikasi alamat IP penyerang, target IP beserta port yang diserang, password user lain_admin yang berhasil ditembus, serta web server software dan versi yang dilaporkan pada response header. Validasi temuan kalian pada socket server: (link file) nc [IP_Group] 3401

### Bukti dan Hasil
![alt text](image-1.png)
   - Bukti mendapat IP penyerang dan diserang
      ![alt text](image-2.png)
   - Bukti menemukan port, password dan server
      ![alt text](image-3.png)
### Langkah Pengerjaan

1. **Membuka Wire the shark**:
   - Untuk melhat aktivitas yang dilakukan kita bisa mencapture melalui Wire the shark
2. **Import file yang telah disediakan ke Wire The Shark**
3. **Amati aktivitas yang ada dan cari yang ditanyakan**
    - Pastinya terdapat banyak sekali aktivitas, cara memilahnya adalah dengan menggunakan fitur find lalu cari HTTP. Maka akan terlihat aktivitasnya. Kita juga bisa klik kanan dan tekan follow lalu tekan HTTP form 

## Soal 15



