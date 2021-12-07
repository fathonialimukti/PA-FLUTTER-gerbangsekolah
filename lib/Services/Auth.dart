import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerbangsekolah/Models/Grade.dart';
import 'package:gerbangsekolah/Models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Dio.dart';

class Auth extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isTeacher = false;
  late User _user;
  late String _token;
  List<Grade> _grades = [];

  bool get authenticated => _isLoggedIn;
  User get user => _user;
  bool get isTeacher => _isTeacher;
  String get token => _token;
  List<Grade> get grades => _grades;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void login({required Map creds}) async {
    try {
      Dio.Response response = await dio().post('login', data: creds);

      String token = response.data['token'].toString();

      this.getData(token);

      Fluttertoast.showToast(
        msg: response.data['message'],
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Mungkin anda belum terhubung ke VPN',
      );
      print(e);
    }
  }

  void getData(String token) async {
    if (token == "Non-Authorized") {
      return;
    } else {
      try {
        Dio.Response response = await dio().get('profile',
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));

        this._user = User.fromJson(response.data);

        try {
          this._grades = (response.data['grades'] as List)
              .map((index) => Grade.fromJson(index))
              .toList();
        } catch (e) {
          this._grades.add(Grade.fromJson(response.data['grades']));
        }

        this._isTeacher = response.data['isTeacher'];

        this._isLoggedIn = true;
        this._token = token;

        SharedPreferences prefs = await _prefs;
        prefs.setString('token', token);

        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  void logout() async {
    try {
      Dio.Response response = await dio().get('logout',
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      Fluttertoast.showToast(msg: response.data['message']);
      cleanUp();
      notifyListeners();
    } catch (e) {}
  }

  void cleanUp() async {
    this._isLoggedIn = false;
    this._token = "Non-Authorized";
    this._grades = [];
    SharedPreferences prefs = await _prefs;
    await prefs.remove('token');
  }
}
