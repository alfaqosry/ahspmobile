import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:ahsp2/models/user.dart';
import 'dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedin = false;
  User? _user;
  String? _token;
  final storage = new FlutterSecureStorage();

  bool get authenticated => _isLoggedin;
  User? get user => _user;
  bool get isLoading => _isLoading;

  void login({required Map creds}) async {
    this._isLoading = true;
    notifyListeners();
    print(creds);
    try {
      Dio.Response response = await dio().post('/auth/login', data: creds);
      print(response.data.toString());

      String token = response.data.toString();
      this.tryToken(token: token);
      _isLoggedin = true;
      notifyListeners();
    } catch (e) {
      print('eror');
      print(e);
    }
    this._isLoading = false;
    notifyListeners();
  }

  void tryToken({required String token}) async {
    if (token == null) {
      return;
    } else {
      try {
        print(token);
        Dio.Response response = await dio().get('/user',
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        this._isLoggedin = true;
        this._token = token;
        this._user = User.fromJson(response.data);
        this.storeToken(token, user!.id);
        notifyListeners();
        print(_user);
      } catch (e) {
        print('erorr');
        print(e);
      }
    }
  }

  void storeToken(String token, int userid) async {
    this.storage.write(key: 'token', value: token);
    this.storage.write(key: 'userid', value: userid.toString());
  }

  void logout() async {
    try {
      Dio.Response response = await dio().get('/user/revoke',
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      cleanUp();

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void cleanUp() async {
    this._user = null;
    this._isLoggedin = false;
    this._token = null;
    await storage.delete(key: 'token');
    await storage.delete(key: 'userid');
  }
}
