<?php


// database/seeders/BaakSeeder.php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('users')->insert([
            'name' => 'baak',
            'nomor_ktp' => '1234567891234567',
            'nim' => '11111111',
            'role' => 'baak',
            'nomor_handphone' => '081234567899',
            'email' => 'baak@del.ac.id',
            'password' => bcrypt('baak123456'),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        DB::table('ruangan')->insert([
            'NamaRuangan' => 'AUD',
        ]);
        DB::table('ruangan')->insert([
            'NamaRuangan' => 'OT',
        ]);
        DB::table('ruangan')->insert([
            'NamaRuangan' => 'LDTE',
        ]);
        DB::table('ruangan')->insert([
            'NamaRuangan' => 'LSK',
        ]);
        DB::table('ruangan')->insert([
            'NamaRuangan' => 'LSD',
        ]);
        DB::table('ruangan')->insert([
            'NamaRuangan' => 'PJJ',
        ]);
        DB::table('ruangan')->insert([
            'NamaRuangan' => 'GD512',
        ]);
        DB::table('ruangan')->insert([
            'NamaRuangan' => 'GD712',
        ]);
        DB::table('ruangan')->insert([
            'NamaRuangan' => 'GD912',
        ]);
        DB::table('ruangan')->insert([
            'NamaRuangan' => 'GD513',
        ]);
        DB::table('ruangan')->insert([
            'NamaRuangan' => 'GD713',
        ]);
        DB::table('ruangan')->insert([
            'NamaRuangan' => 'GD913',
        ]);


        DB::table('baju')->insert([
            'ukuran' => 'S',
            'harga' => '100000',
        ]);
        DB::table('baju')->insert([
            'ukuran' => 'M',
            'harga' => '100000',
        ]);
        DB::table('baju')->insert([
            'ukuran' => 'L',
            'harga' => '100000',
        ]);
        DB::table('baju')->insert([
            'ukuran' => 'XL',
            'harga' => '100000',
        ]);
        DB::table('baju')->insert([
            'ukuran' => 'XXL',
            'harga' => '100000',
        ]);
        DB::table('baju')->insert([
            'ukuran' => 'XXXL',
            'harga' => '100000',
        ]);


    }
}