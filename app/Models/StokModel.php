<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasOne;

class StokModel extends Model
{
    use HasFactory;

    protected $table = 'stok';
    protected $primaryKey = 'id_stok';
    protected $fillable = ['id_stok','id_barang','jumlah_barang'];

    public function stok():HasOne
    {
        return $this->hasOne(StokModel::class,'id_barang','id_barang');
    }

}
