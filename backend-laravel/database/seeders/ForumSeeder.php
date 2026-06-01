<?php

   namespace Database\Seeders;

   use Illuminate\Database\Seeder;
   use Illuminate\Support\Facades\DB;

   class ForumSeeder extends Seeder
   {
       /**
        * Run the database seeds.
        */
       public function run(): void
       {
           DB::table('forums')->insert([
               [
                   'judul' => 'Tips hafal Abjad Isyarat dengan cepat?',
                   'konten' => 'Halo semuanya, ada tips gak buat ngafalin gerakan abjad A-Z biar gak gampang ketuker-tuker antara huruf M dan N? Makasih!',
                   'pembuat' => 'Naysila Renatania',
                   'created_at' => now(),
                   'updated_at' => now(),
               ],
               [
                   'judul' => 'Rekomendasi Komunitas Tuli di Surabaya',
                   'konten' => 'Teman-teman, ada yang tahu info komunitas atau tempat berkumpul teman tuli di daerah Surabaya untuk memperlancar praktik isyarat kita?',
                   'pembuat' => 'Aurel Zalsabilla',
                   'created_at' => now(),
                   'updated_at' => now(),
               ],
           ]);
       }
   }