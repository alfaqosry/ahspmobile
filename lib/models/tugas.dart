import 'dart:convert';

class Tugas {
  String projek;
  String tahun;
  String status;
  int id;

  Tugas(
      {this.projek = "", this.tahun = "", this.status = "", required this.id});

  Tugas.fromJson(Map<String, dynamic> json)
      : projek = json['projek'],
        tahun = json['tahun'],
        status = json['status'],
        id = json['id'];
}

class HargaBahan {
  String bahan;
  // int satuan_id;
  // int jenis_bahan_id;
  int harga;
  int id_bahan;

  HargaBahan(
      {this.bahan = "",
      this.id_bahan = 0,
      // this.satuan_id = 0,
      // this.jenis_bahan_id = 0,
      this.harga = 0});
  HargaBahan.fromJson(Map<String, dynamic> json)
      : id_bahan = json['id_bahan'],
        bahan = json['bahan'],
        // satuan_id = json['satuan_id'],
        // jenis_bahan_id = json['jenis_bahan_id'],

        harga = json['harga'] == null ? 0 : json['harga'];
}
