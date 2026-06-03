public function run(): void
{
    \Illuminate\Support\Facades\DB::table('quiz_scores')->insert([
        [
            'user_id' => 1,
            'level' => 'Beginner',
            'skor' => 90,
            'created_at' => now()->subHours(2),
            'updated_at' => now()->subHours(2),
        ],
        [
            'user_id' => 1,
            'level' => 'Intermediate',
            'skor' => 100,
            'created_at' => now(),
            'updated_at' => now(),
        ],
    ]);
}