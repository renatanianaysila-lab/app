<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class MateriSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // 1. Matikan pengecekan foreign key sementara agar bisa menghapus data induk
        Schema::disableForeignKeyConstraints();

        // 2. Kosongkan tabel materis dan reset Auto Increment ID kembali ke 1
        DB::table('materis')->truncate();

        // 3. Hidupkan kembali pengecekan foreign key demi keamanan relasi database
        Schema::enableForeignKeyConstraints();

        $materis = [
            // ── TINGKAT DASAR (LEVEL 1) ──────────────────────────────────────
            [
                'judul' => 'Budaya Tuli & Etika Memanggil Teman Tuli (melambai/menepuk pundak lembut)',
                'kategori' => 'Dasar',
                'deskripsi' => 'Modul 1: Orientasi Dunia Tuli & Fingerspelling. Pelajari dasar-dasar budaya Tuli, cara pandang komunitas Tuli terhadap komunikasi visual, serta etika yang tepat saat berinteraksi dengan teman Tuli.',
                'video_url' => 'https://youtu.be/oRLVz5I2l6o',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Isyarat Abjad BISINDO A–M (Menggunakan dua tangan sesuai pakem asli)',
                'kategori' => 'Dasar',
                'deskripsi' => 'Modul 1: Orientasi Dunia Tuli & Fingerspelling. Peserta diperkenalkan dengan huruf-huruf alfabet BISINDO A hingga M menggunakan sistem fingerspelling dua tangan.',
                'video_url' => 'https://youtu.be/Py6Ch1vBvL0',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Isyarat Abjad BISINDO N–Z (Menggunakan dua tangan)',
                'kategori' => 'Dasar',
                'deskripsi' => 'Modul 1: Orientasi Dunia Tuli & Fingerspelling. Lanjutan pembelajaran fingerspelling huruf N hingga Z. Setelah menyelesaikan materi ini, peserta dapat mengeja alfabet BISINDO secara lengkap.',
                'video_url' => 'https://youtu.be/4DZnZv3weBw',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Isyarat Angka Satuan & Puluhan (1–50)',
                'kategori' => 'Dasar',
                'deskripsi' => 'Modul 2: Angka Dasar & Keterangan Waktu. Pelajari cara mengisyaratkan angka satuan dan puluhan dalam BISINDO. Memahami penggunaan angka dalam konteks sehari-hari seperti usia, jumlah, maupun waktu.',
                'video_url' => 'https://youtu.be/h681dhezQyw?si=MW0v9LzRmRamzYm5',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Isyarat Nama-Nama Hari (Senin–Minggu)',
                'kategori' => 'Dasar',
                'deskripsi' => 'Modul 2: Angka Dasar & Keterangan Waktu. Peserta mempelajari kosakata hari dalam satu minggu menggunakan BISINDO sebagai dasar menyusun informasi aktivitas harian.',
                'video_url' => 'https://youtu.be/9A8sVFdMxcA?si=XGhNk3JP3IVGnttS',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Isyarat Keterangan Waktu Harian (Hari ini, Besok, Kemarin, Tadi)',
                'kategori' => 'Dasar',
                'deskripsi' => 'Modul 2: Angka Dasar & Keterangan Waktu. Kenali berbagai keterangan waktu yang sering digunakan dalam percakapan sehari-hari untuk memahami konsep waktu dalam komunikasi visual.',
                'video_url' => 'https://youtu.be/pJofzmnodDc?si=kJp1ZwhQZYnmmU11',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Salam & Sapaan Dasar ("Halo", "Selamat Pagi", "Terima Kasih", "Maaf")',
                'kategori' => 'Dasar',
                'deskripsi' => 'Modul 3: Sapaan & Perkenalan Diri. Pelajari berbagai ungkapan sopan santun yang umum digunakan dalam percakapan sebagai langkah awal membangun komunikasi yang ramah.',
                'video_url' => 'https://youtu.be/xnxydJPDD1M?si=pRl8lFNoYLuABG5Q',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Frasa Perkenalan Diri ("Nama saya...", "Umur saya...", "Saya tinggal di...")',
                'kategori' => 'Dasar',
                'deskripsi' => 'Modul 3: Sapaan & Perkenalan Diri. Peserta akan belajar memperkenalkan diri menggunakan BISINDO, termasuk menyebutkan nama, usia, dan tempat tinggal secara sederhana.',
                'video_url' => 'https://youtu.be/tldOiBC_TwM?si=DqcPYVzCN5MDXVrT',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Kata Ganti Orang',
                'kategori' => 'Dasar',
                'deskripsi' => 'Modul 4: Kosakata Dasar Kehidupan Sehari-hari. Pelajari penggunaan kata ganti orang seperti saya, kamu, dan dia dalam BISINDO untuk merujuk persona dalam percakapan.',
                'video_url' => 'https://youtu.be/KAX855yUJs0?si=kNYtMWWij1tzubtQ',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Kata Sifat Hati & Fisik',
                'kategori' => 'Dasar',
                'deskripsi' => 'Modul 4: Kosakata Dasar Kehidupan Sehari-hari. Peserta mempelajari kosakata yang menggambarkan perasaan maupun kondisi fisik, sehingga dapat mengungkapkan keadaan diri.',
                'video_url' => 'https://youtu.be/uOaUk4D52oQ?si=NA4K7C1hh90ztU9V',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Kata Kerja Dasar',
                'kategori' => 'Dasar',
                'deskripsi' => 'Modul 4: Kosakata Dasar Kehidupan Sehari-hari. Kenali berbagai kata kerja dasar yang sering digunakan dalam aktivitas sehari-hari sebagai bekal penting membentuk kalimat.',
                'video_url' => 'https://youtu.be/NEnBXwS9K5U?si=VpNcyCUiPBauJfza',
                'created_at' => now(), 'updated_at' => now()
            ],

            // ── TINGKAT MENENGAH (LEVEL 2) ───────────────────────────────────
            [
                'judul' => 'Isyarat Emosi Dasar & Kata Sifat ("Marah", "Malu", "Sabar")',
                'kategori' => 'Menengah',
                'deskripsi' => 'Modul 4: Ekspresi, Emosi, & Kata Sifat. Pelajari berbagai ekspresi emosi seperti marah, malu, dan sabar beserta penggunaannya agar penyampaian perasaan menjadi lebih ekspresif.',
                'video_url' => 'https://youtu.be/lio9OmhZa5I?si=0p6WzH0zBZl2S02z',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Sinkronisasi Gerakan Tangan dengan Ekspresi Wajah (Non-Manual Markers)',
                'kategori' => 'Menengah',
                'deskripsi' => 'Modul 4: Ekspresi, Emosi, & Kata Sifat. Memahami peran penting mimik wajah dan ekspresi non-manual markers dalam memperjelas makna suatu isyarat BISINDO.',
                'video_url' => 'https://youtu.be/E6Fvre5BHqI?si=xfYX-CD4AmjuozwW',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Anggota Keluarga',
                'kategori' => 'Menengah',
                'deskripsi' => 'Modul 5: Lingkungan Keluarga & Aktivitas Harian. Peserta mempelajari kosakata anggota keluarga yang umum digunakan untuk menceritakan atau memperkenalkan lingkungan keluarga.',
                'video_url' => 'https://youtu.be/4icuKB1w5Z0?si=OH6tV3SSa1ACwLy7',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Kata Kerja Rutinitas ("Makan", "Minum")',
                'kategori' => 'Menengah',
                'deskripsi' => 'Modul 5: Lingkungan Keluarga & Aktivitas Harian. Pelajari kata kerja yang berkaitan dengan aktivitas rutin sehari-hari seperti makan dan minum untuk membentuk informasi aktivitas pribadi.',
                'video_url' => 'https://youtu.be/2aoK924M5s8?si=sOR6wAL1dDQ2N-BH',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Menyusun Frasa Sederhana',
                'kategori' => 'Menengah',
                'deskripsi' => 'Modul 5: Lingkungan Keluarga & Aktivitas Harian. Gabungkan kosakata yang telah dipelajari menjadi frasa sederhana bermakna sebagai jembatan menuju kemampuan berkomunikasi.',
                'video_url' => 'https://youtu.be/arAzoJ5aFZ4?si=ObJU6dWBiOwPBu6N',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Kosakata Tempat ("Rumah", "Sekolah", "Kantor")',
                'kategori' => 'Menengah',
                'deskripsi' => 'Modul 6: Percakapan Interaktif & Lokasi. Peserta mempelajari berbagai lokasi yang sering ditemui untuk menjelaskan tempat berlangsungnya suatu aktivitas.',
                'video_url' => 'https://youtu.be/pdIcF5Lvb08?si=owlbcze7Y35o-d_0',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Pola Kalimat Tanya & Tanya Kontekstual ("Apa", "Siapa", "Di mana")',
                'kategori' => 'Menengah',
                'deskripsi' => 'Modul 6: Percakapan Interaktif & Lokasi. Pelajari cara mengajukan pertanyaan menggunakan kata tanya kontekstual untuk membantu melakukan interaksi dua arah secara aktif.',
                'video_url' => 'https://www.youtube.com/watch?v=TkF7W2A2R8M',
                'created_at' => now(), 'updated_at' => now()
            ],

            // ── TINGKAT LANJUTAN (LEVEL 3) ──────────────────────────────────────
            [
                'judul' => 'Kalimat Sehari-hari dalam BISINDO',
                'kategori' => 'Susah',
                'deskripsi' => 'Modul 7: Membangun Kalimat dan Percakapan. Peserta mulai mempelajari bagaimana kosakata dan frasa digabungkan menjadi bentuk kalimat utuh yang lazim digunakan komunitas Tuli.',
                'video_url' => 'http://youtube.com/watch?v=NaafQwd0XEY',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Contoh Percakapan BISINDO',
                'kategori' => 'Susah',
                'deskripsi' => 'Modul 7: Membangun Kalimat dan Percakapan. Amati dan pelajari contoh percakapan langsung dalam konteks sehari-hari untuk memahami alur komunikasi alami.',
                'video_url' => 'https://youtu.be/5GzXxw4rOwU?si=UpaA9vL4l6yLm2RU',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Studi Kasus Vlog Keseharian Teman Tuli (Kecepatan Normal)',
                'kategori' => 'Susah',
                'deskripsi' => 'Modul 8: Aplikasi BISINDO dalam Situasi Nyata. Peserta berlatih memahami penggunaan BISINDO dalam situasi nyata melalui vlog kecepatan alami kreator Tuli.',
                'video_url' => 'https://youtu.be/s4W10a6OmCI?si=A8NSzBXKuXe7ncXr',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'judul' => 'Pemahaman Konteks Cerita & Edukasi Budaya Tuli',
                'kategori' => 'Susah',
                'deskripsi' => 'Modul 8: Aplikasi BISINDO dalam Situasi Nyata. Menangkap makna, konteks, serta pesan yang disampaikan melalui cerita dan konten edukatif visual yang lebih kompleks.',
                'video_url' => 'https://youtu.be/ipQKtULyDX8?si=kj7-lxvKbeUdJAGK',
                'created_at' => now(), 'updated_at' => now()
            ],
        ];

        DB::table('materis')->insert($materis);
    }
}