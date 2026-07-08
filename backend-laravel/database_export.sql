-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: db_isyaratkita_pmob
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forums`
--

DROP TABLE IF EXISTS `forums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forums` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `judul` varchar(255) NOT NULL,
  `konten` text NOT NULL,
  `pembuat` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forums`
--

LOCK TABLES `forums` WRITE;
/*!40000 ALTER TABLE `forums` DISABLE KEYS */;
INSERT INTO `forums` VALUES (1,'Tips hafal Abjad Isyarat dengan cepat?','Halo semuanya, ada tips gak buat ngafalin gerakan abjad A-Z biar gak gampang ketuker-tuker antara huruf M dan N? Makasih!','Naysila Renatania','2026-06-12 20:15:21','2026-06-12 20:15:21'),(2,'Rekomendasi Komunitas Tuli di Surabaya','Teman-teman, ada yang tahu info komunitas atau tempat berkumpul teman tuli di daerah Surabaya untuk memperlancar praktik isyarat kita?','Aurel Zalsabilla','2026-06-12 20:15:21','2026-06-12 20:15:21');
/*!40000 ALTER TABLE `forums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guru`
--

DROP TABLE IF EXISTS `guru`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guru` (
  `guru_id` char(5) NOT NULL,
  `nama_guru` varchar(100) NOT NULL,
  `email_guru` varchar(100) NOT NULL,
  `password_guru` varchar(255) NOT NULL,
  `foto_profil_guru` varchar(255) DEFAULT NULL,
  `sertifikasi` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`guru_id`),
  UNIQUE KEY `guru_email_guru_unique` (`email_guru`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guru`
--

LOCK TABLES `guru` WRITE;
/*!40000 ALTER TABLE `guru` DISABLE KEYS */;
INSERT INTO `guru` VALUES ('1','Guru BISINDO','guru@gmail.com','$2y$12$PlgrVaZbXihGPkFAcWKuTeCtOscxps3sLqu.fRe8Vg6va7uMAqInS',NULL,NULL,'2026-06-12 20:29:20','2026-06-12 20:29:20');
/*!40000 ALTER TABLE `guru` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `materis`
--

DROP TABLE IF EXISTS `materis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `materis` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `judul` varchar(255) NOT NULL,
  `kategori` varchar(255) NOT NULL,
  `deskripsi` text NOT NULL,
  `video_url` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `guru_id` varchar(10) DEFAULT 'G0001',
  `nama_modul` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materis`
--

LOCK TABLES `materis` WRITE;
/*!40000 ALTER TABLE `materis` DISABLE KEYS */;
INSERT INTO `materis` VALUES (1,'Budaya Tuli & Etika Memanggil Teman Tuli (melambai/menepuk pundak lembut)','Dasar','Modul 1: Orientasi Dunia Tuli & Fingerspelling. Pelajari dasar-dasar budaya Tuli, cara pandang komunitas Tuli terhadap komunikasi visual, serta etika yang tepat saat berinteraksi dengan teman Tuli.','https://youtu.be/oRLVz5I2l6o','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001','Modul 1: Orientasi & Fingerspelling'),(2,'Isyarat Abjad BISINDO A–M (Menggunakan dua tangan sesuai pakem asli)','Dasar','Modul 1: Orientasi Dunia Tuli & Fingerspelling. Peserta diperkenalkan dengan huruf-huruf alfabet BISINDO A hingga M menggunakan sistem fingerspelling dua tangan.','https://youtu.be/Py6Ch1vBvL0','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001','Modul 1: Orientasi & Fingerspelling'),(3,'Isyarat Abjad BISINDO N–Z (Menggunakan dua tangan)','Dasar','Modul 1: Orientasi Dunia Tuli & Fingerspelling. Lanjutan pembelajaran fingerspelling huruf N hingga Z. Setelah menyelesaikan materi ini, peserta dapat mengeja alfabet BISINDO secara lengkap.','https://youtu.be/4DZnZv3weBw','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001','Modul 1: Orientasi & Fingerspelling'),(4,'Isyarat Angka Satuan & Puluhan (1–50)','Dasar','Modul 2: Angka Dasar & Keterangan Waktu. Pelajari cara mengisyaratkan angka satuan dan puluhan dalam BISINDO. Memahami penggunaan angka dalam konteks sehari-hari seperti usia, jumlah, maupun waktu.','https://youtu.be/h681dhezQyw?si=MW0v9LzRmRamzYm5','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001','Modul 2: Angka & Keterangan Waktu'),(5,'Isyarat Nama-Nama Hari (Senin–Minggu)','Dasar','Modul 2: Angka Dasar & Keterangan Waktu. Peserta mempelajari kosakata hari dalam satu minggu menggunakan BISINDO sebagai dasar menyusun informasi aktivitas harian.','https://youtu.be/9A8sVFdMxcA?si=XGhNk3JP3IVGnttS','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001','Modul 2: Angka & Keterangan Waktu'),(6,'Isyarat Keterangan Waktu Harian (Hari ini, Besok, Kemarin, Tadi)','Dasar','Modul 2: Angka Dasar & Keterangan Waktu. Kenali berbagai keterangan waktu yang sering digunakan dalam percakapan sehari-hari untuk memahami konsep waktu dalam komunikasi visual.','https://youtu.be/pJofzmnodDc?si=kJp1ZwhQZYnmmU11','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001','Modul 2: Angka & Keterangan Waktu'),(7,'Salam & Sapaan Dasar (\"Halo\", \"Selamat Pagi\", \"Terima Kasih\", \"Maaf\")','Dasar','Modul 3: Sapaan & Perkenalan Diri. Pelajari berbagai ungkapan sopan santun yang umum digunakan dalam percakapan sebagai langkah awal membangun komunikasi yang ramah.','https://youtu.be/xnxydJPDD1M?si=pRl8lFNoYLuABG5Q','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001','Modul 3: Sapaan & Perkenalan'),(8,'Frasa Perkenalan Diri (\"Nama saya...\", \"Umur saya...\", \"Saya tinggal di...\")','Dasar','Modul 3: Sapaan & Perkenalan Diri. Peserta akan belajar memperkenalkan diri menggunakan BISINDO, termasuk menyebutkan nama, usia, dan tempat tinggal secara sederhana.','https://youtu.be/tldOiBC_TwM?si=DqcPYVzCN5MDXVrT','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001','Modul 3: Sapaan & Perkenalan'),(9,'Kata Ganti Orang','Dasar','Modul 4: Kosakata Dasar Kehidupan Sehari-hari. Pelajari penggunaan kata ganti orang seperti saya, kamu, dan dia dalam BISINDO untuk merujuk persona dalam percakapan.','https://youtu.be/KAX855yUJs0?si=kNYtMWWij1tzubtQ','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001','Modul 4: Kosakata Kehidupan Sehari-hari'),(10,'Kata Sifat Hati & Fisik','Dasar','Modul 4: Kosakata Dasar Kehidupan Sehari-hari. Peserta mempelajari kosakata yang menggambarkan perasaan maupun kondisi fisik, sehingga dapat mengungkapkan keadaan diri.','https://youtu.be/uOaUk4D52oQ?si=NA4K7C1hh90ztU9V','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001','Modul 4: Kosakata Kehidupan Sehari-hari'),(11,'Kata Kerja Dasar','Dasar','Modul 4: Kosakata Dasar Kehidupan Sehari-hari. Kenali berbagai kata kerja dasar yang sering digunakan dalam aktivitas sehari-hari sebagai bekal penting membentuk kalimat.','https://youtu.be/NEnBXwS9K5U?si=VpNcyCUiPBauJfza','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001','Modul 4: Kosakata Kehidupan Sehari-hari'),(12,'Isyarat Emosi Dasar & Kata Sifat (\"Marah\", \"Malu\", \"Sabar\")','Menengah','Modul 4: Ekspresi, Emosi, & Kata Sifat. Pelajari berbagai ekspresi emosi seperti marah, malu, dan sabar beserta penggunaannya agar penyampaian perasaan menjadi lebih ekspresif.','https://youtu.be/lio9OmhZa5I?si=0p6WzH0zBZl2S02z','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001','Modul 4: Kosakata Kehidupan Sehari-hari'),(13,'Sinkronisasi Gerakan Tangan dengan Ekspresi Wajah (Non-Manual Markers)','Menengah','Modul 4: Ekspresi, Emosi, & Kata Sifat. Memahami peran penting mimik wajah dan ekspresi non-manual markers dalam memperjelas makna suatu isyarat BISINDO.','https://youtu.be/E6Fvre5BHqI?si=xfYX-CD4AmjuozwW','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001','Modul 4: Kosakata Kehidupan Sehari-hari'),(14,'Anggota Keluarga','Menengah','Modul 5: Lingkungan Keluarga & Aktivitas Harian. Peserta mempelajari kosakata anggota keluarga yang umum digunakan untuk menceritakan atau memperkenalkan lingkungan keluarga.','https://youtu.be/4icuKB1w5Z0?si=OH6tV3SSa1ACwLy7','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001',NULL),(15,'Kata Kerja Rutinitas (\"Makan\", \"Minum\")','Menengah','Modul 5: Lingkungan Keluarga & Aktivitas Harian. Pelajari kata kerja yang berkaitan dengan aktivitas rutin sehari-hari seperti makan dan minum untuk membentuk informasi aktivitas pribadi.','https://youtu.be/2aoK924M5s8?si=sOR6wAL1dDQ2N-BH','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001',NULL),(16,'Menyusun Frasa Sederhana','Menengah','Modul 5: Lingkungan Keluarga & Aktivitas Harian. Gabungkan kosakata yang telah dipelajari menjadi frasa sederhana bermakna sebagai jembatan menuju kemampuan berkomunikasi.','https://youtu.be/arAzoJ5aFZ4?si=ObJU6dWBiOwPBu6N','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001',NULL),(17,'Kosakata Tempat (\"Rumah\", \"Sekolah\", \"Kantor\")','Menengah','Modul 6: Percakapan Interaktif & Lokasi. Peserta mempelajari berbagai lokasi yang sering ditemui untuk menjelaskan tempat berlangsungnya suatu aktivitas.','https://youtu.be/pdIcF5Lvb08?si=owlbcze7Y35o-d_0','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001',NULL),(18,'Pola Kalimat Tanya & Tanya Kontekstual (\"Apa\", \"Siapa\", \"Di mana\")','Menengah','Modul 6: Percakapan Interaktif & Lokasi. Pelajari cara mengajukan pertanyaan menggunakan kata tanya kontekstual untuk membantu melakukan interaksi dua arah secara aktif.','https://www.youtube.com/watch?v=TkF7W2A2R8M','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001',NULL),(19,'Kalimat Sehari-hari dalam BISINDO','Susah','Modul 7: Membangun Kalimat dan Percakapan. Peserta mulai mempelajari bagaimana kosakata dan frasa digabungkan menjadi bentuk kalimat utuh yang lazim digunakan komunitas Tuli.','http://youtube.com/watch?v=NaafQwd0XEY','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001',NULL),(20,'Contoh Percakapan BISINDO','Susah','Modul 7: Membangun Kalimat dan Percakapan. Amati dan pelajari contoh percakapan langsung dalam konteks sehari-hari untuk memahami alur komunikasi alami.','https://youtu.be/5GzXxw4rOwU?si=UpaA9vL4l6yLm2RU','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001',NULL),(21,'Studi Kasus Vlog Keseharian Teman Tuli (Kecepatan Normal)','Susah','Modul 8: Aplikasi BISINDO dalam Situasi Nyata. Peserta berlatih memahami penggunaan BISINDO dalam situasi nyata melalui vlog kecepatan alami kreator Tuli.','https://youtu.be/s4W10a6OmCI?si=A8NSzBXKuXe7ncXr','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001',NULL),(22,'Pemahaman Konteks Cerita & Edukasi Budaya Tuli','Susah','Modul 8: Aplikasi BISINDO dalam Situasi Nyata. Menangkap makna, konteks, serta pesan yang disampaikan melalui cerita dan konten edukatif visual yang lebih kompleks.','https://youtu.be/ipQKtULyDX8?si=kj7-lxvKbeUdJAGK','2026-06-12 20:15:21','2026-06-12 20:15:21','G0001',NULL);
/*!40000 ALTER TABLE `materis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2026_05_24_120231_create_payments_table',1),(5,'2026_05_24_120237_create_transactions_table',1),(6,'2026_06_01_040553_create_murid_table',1),(7,'2026_06_01_040657_create_guru_table',1),(8,'2026_06_01_095042_create_materis_table',1),(9,'2026_06_01_100824_create_forums_table',1),(10,'2026_06_02_025351_create_quizzes_table',1),(11,'2026_06_02_030142_create_packages_table',1),(12,'2026_06_03_004158_create_quiz_scores_table',1),(13,'2026_06_03_012950_create_user_subscriptions_table',1),(14,'2026_06_03_013040_create_user_progress_table',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `murid`
--

DROP TABLE IF EXISTS `murid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `murid` (
  `murid_id` char(5) NOT NULL,
  `nama_murid` varchar(100) NOT NULL,
  `email_murid` varchar(100) NOT NULL,
  `password_murid` varchar(255) NOT NULL,
  `foto_profil_murid` varchar(255) DEFAULT NULL,
  `tanggal_lahir` date NOT NULL,
  `tanggal_daftar` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`murid_id`),
  UNIQUE KEY `murid_email_murid_unique` (`email_murid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `murid`
--

LOCK TABLES `murid` WRITE;
/*!40000 ALTER TABLE `murid` DISABLE KEYS */;
INSERT INTO `murid` VALUES ('1','Naysila','naysila@gmail.com','$2y$12$4oSD.TGAbQQwvaxvUQVhy.U/.cJhYn.UayCmYYER5Zz6d3aWOwk6q',NULL,'2003-01-01','2026-06-12 20:28:52','2026-06-12 20:28:52','2026-06-12 20:28:52');
/*!40000 ALTER TABLE `murid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packages`
--

DROP TABLE IF EXISTS `packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nama_paket` varchar(255) NOT NULL,
  `harga` int(11) NOT NULL,
  `deskripsi` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packages`
--

LOCK TABLES `packages` WRITE;
/*!40000 ALTER TABLE `packages` DISABLE KEYS */;
INSERT INTO `packages` VALUES (1,'Paket Isyarat Bulanan',30000,'Akses penuh seluruh materi video abjad & forum diskusi selama 1 bulan.','2026-06-12 20:15:21','2026-06-12 20:15:21'),(2,'Paket Isyarat Tahunan',249000,'Akses penuh seluruh materi, kuis eksklusif, sertifikat digital selama 1 tahun.','2026-06-12 20:15:21','2026-06-12 20:15:21');
/*!40000 ALTER TABLE `packages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `payment_method` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `qris_code` varchar(255) DEFAULT NULL,
  `card_holder` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz_scores`
--

DROP TABLE IF EXISTS `quiz_scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quiz_scores` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `level` varchar(255) NOT NULL,
  `skor` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz_scores`
--

LOCK TABLES `quiz_scores` WRITE;
/*!40000 ALTER TABLE `quiz_scores` DISABLE KEYS */;
INSERT INTO `quiz_scores` VALUES (1,1,'Beginner',90,'2026-06-12 18:15:21','2026-06-12 18:15:21'),(2,1,'Intermediate',100,'2026-06-12 20:15:21','2026-06-12 20:15:21');
/*!40000 ALTER TABLE `quiz_scores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quizzes`
--

DROP TABLE IF EXISTS `quizzes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quizzes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pertanyaan` varchar(255) NOT NULL,
  `opsi_a` varchar(255) NOT NULL,
  `opsi_b` varchar(255) NOT NULL,
  `opsi_c` varchar(255) NOT NULL,
  `opsi_d` varchar(255) NOT NULL,
  `jawaban_benar` char(1) NOT NULL,
  `level` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quizzes`
--

LOCK TABLES `quizzes` WRITE;
/*!40000 ALTER TABLE `quizzes` DISABLE KEYS */;
INSERT INTO `quizzes` VALUES (1,'Manakah simbol gerakan tangan yang melambangkan huruf \"A\" dalam BISINDO?','Mengepalkan tangan dengan jempol berdiri di samping','Membentuk lingkaran dengan telunjuk dan jempol','Membuka kelima jari tegak ke atas','Menyilangkan jari telunjuk dan jari tengah','A','Beginner','2026-06-12 20:15:21','2026-06-12 20:15:21'),(2,'Jika ingin mengisyaratkan angka \"5\" dasar, berapa jumlah jari yang harus dibuka?','2 Jari','3 Jari','4 Jari','5 Jari (Telapak tangan terbuka)','D','Beginner','2026-06-12 20:15:21','2026-06-12 20:15:21');
/*!40000 ALTER TABLE `quizzes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('3eYG9user1C94brGvXG3TXwNs0IoBoo1HqhAjvRM',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiOHk1S25IQ1Q4ZlNpWENhMGtzcm9RbnQwMFl5TTl1cGwzNlZ2ekU3aCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NTI6Imh0dHA6Ly9sdXRoZXItbm9ucmVwYXlhYmxlLXVuZ3VpbHRpbHkubmdyb2stZnJlZS5kZXYiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1783493963),('jb25qRKyT3L4MiH3lIKIiOtBu31UMHnAM2Cw9rxR',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.127.0 Chrome/148.0.7778.97 Electron/42.2.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiN3l6eHhTZGt6WUlsbWpRVzZhdjZGMnp6aXBkNzJkbW9PRlZ3bE5FNCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==',1783492393),('RliLRNbEaSxhr7zAE7JmxGwdsdYxe3CXFIG3ze53',NULL,'127.0.0.1','curl/8.20.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiTnF0OGdwbkhYRFRTN2NkN1hVdXVtTHh1MEdEdXN4VVZmSW43cUFwSCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==',1783493652);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transactions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `package_id` int(11) NOT NULL,
  `total_harga` int(11) NOT NULL,
  `metode_pembayaran` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (1,1,1,30000,'QRIS','success','2026-06-10 20:15:21','2026-06-10 20:15:21');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_progress`
--

DROP TABLE IF EXISTS `user_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_progress` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `materi_id` bigint(20) unsigned NOT NULL,
  `is_completed` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_progress_user_id_foreign` (`user_id`),
  KEY `user_progress_materi_id_foreign` (`materi_id`),
  CONSTRAINT `user_progress_materi_id_foreign` FOREIGN KEY (`materi_id`) REFERENCES `materis` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_progress_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_progress`
--

LOCK TABLES `user_progress` WRITE;
/*!40000 ALTER TABLE `user_progress` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_progress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_subscriptions`
--

DROP TABLE IF EXISTS `user_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_subscriptions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `package_id` bigint(20) unsigned NOT NULL,
  `starts_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` datetime DEFAULT NULL,
  `status` enum('active','expired') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_subscriptions_user_id_foreign` (`user_id`),
  KEY `user_subscriptions_package_id_foreign` (`package_id`),
  CONSTRAINT `user_subscriptions_package_id_foreign` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_subscriptions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_subscriptions`
--

LOCK TABLES `user_subscriptions` WRITE;
/*!40000 ALTER TABLE `user_subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin','admin@gmail.com',NULL,'$2y$12$GPSqJw.2KJRHgDhp69mub.1fKrA7TEfif.jrxwwaEm8M1oVZU.8XS',NULL,'2026-06-12 20:30:19','2026-06-12 20:30:19');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-08 16:03:00
