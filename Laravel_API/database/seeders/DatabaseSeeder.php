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
