import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gerbangsekolah/Models/Assignment.dart';
import 'package:gerbangsekolah/Models/AssignmentFile.dart';
import 'package:gerbangsekolah/Models/Grade.dart';
import 'package:gerbangsekolah/Services/Dio.dart';

class TeacherAct extends ChangeNotifier {
  List<Assignment> _assignments = [];
  List<Assignment> get assignments => _assignments;

  List<AssignmentFile> _assignmentFile = [];
  List<AssignmentFile> get assignmentFile => _assignmentFile;

  List<Grade> _grades = [];
  List<Grade> get grades => _grades;

  void updateVirtualClassroom(int id, String newLink, String token) async {
    try {
      Dio.Response response = await dio().post(
          'teacher/update-virtual-classroom',
          data: {
            'id': id,
            'virtual_classroom': newLink,
          },
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      Fluttertoast.showToast(msg: response.data['message']);
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Mungkin anda belum terhubung ke VPN');
      print(e);
    }
  }

  getAssignment(String token) async {
    this._assignmentFile = [];
    try {
      Dio.Response response = await dio().get('teacher/get-assignment',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));

      try {
        this._assignments = (response.data as List)
            .map((index) => Assignment.fromJson(index))
            .toList();
      } catch (e) {
        print(e);
        this._assignments.add(Assignment.fromJson(response.data));
      }
      notifyListeners();
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Mungkin anda belum terhubung ke VPN");
    }
  }

  getAssignmentFiles(String token, int assignmentId) async {
    try {
      Dio.Response response = await dio().get(
          'teacher/get-assignment-files/$assignmentId',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      try {
        this._assignmentFile = (response.data as List)
            .map((index) => AssignmentFile.fromJson(index))
            .toList();
      } catch (e) {
        assignmentFile.add(AssignmentFile.fromJson(response.data));
      }
      notifyListeners();
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Mungkin anda belum terhubung ke VPN");
    }
  }

  createAssignment(String token, Map data) async {
    try {
      if (data['title'] != "") {
        await dio().post('teacher/create-assignment',
            data: data,
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      } else {
        Fluttertoast.showToast(msg: "Title kosong");
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error");
    }
  }

  deleteAssignment(String token, Map data) async {
    try {
      Dio.Response response = await dio().post('teacher/delete-assignment',
          data: data,
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      Fluttertoast.showToast(msg: response.data['message']);
    } catch (e) {
      Fluttertoast.showToast(msg: "Mungkin anda belum terhubung ke VPN");
    }
  }

  scoringAssignment(String token, Map data) async {
    try {
      print(data.toString());
      Dio.Response response = await dio().post('teacher/scoring-assignment',
          data: data,
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      Fluttertoast.showToast(msg: response.data);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Mungkin anda belum terhubung ke VPN");
    }
  }
}
