import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ahsp2/models/tugas.dart';
import 'dio.dart';
import 'package:dio/dio.dart' as Dio;

class TugasProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Tugas> _tugas = [];
  List<HargaBahan> _harga = [];

  List<HargaBahan> get harga => _harga;
  List<Tugas> get tugas => _tugas;
  bool get isLoading => _isLoading;

  void getTugas(int id) async {
    this._isLoading = true;
    notifyListeners();
    try {
      Dio.Response response = await dio().get('/tugas/$id');

      print(jsonEncode(response.data));

      this._tugas = List.from(response.data)
          .map((e) => Tugas.fromJson(e))
          .toList() as List<Tugas>;

      print('eror');
      print(_tugas);
      notifyListeners();
    } catch (e) {
      print(e);
    }
    this._isLoading = false;
    notifyListeners();
  }

  void getHargaBahan(int id) async {
    this._isLoading = true;
    notifyListeners();

    try {
      Dio.Response response = await dio().get('/getharga/$id');
      print(jsonEncode(response.data));
      this._harga = List.from(response.data)
          .map((e) => HargaBahan.fromJson(e))
          .toList() as List<HargaBahan>;

      print(_harga);
      notifyListeners();
    } catch (e) {
      print(e);
    }
    this._isLoading = false;
    notifyListeners();
  }

  void storeHarga({required Map creds}) async {
    this._isLoading = true;
    notifyListeners();
    print(creds);
    try {
      Dio.Response response = await dio().post('/storeharga', data: creds);
      print(response.data.toString());
    } catch (e) {
      print('eror');
      print(e);
    }
    this._isLoading = false;
    notifyListeners();
  }
}
