import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gerbangsekolah/Models/Assignment.dart';
import 'package:gerbangsekolah/Models/AssignmentFile.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:gerbangsekolah/Models/User.dart';
import 'package:gerbangsekolah/Services/Dio.dart';

class StudentAct extends ChangeNotifier {
  List<Assignment> _assignments = [];
  List<Assignment> get assignments => _assignments;

  List<User> _teachers = [];
  List<User> get teachers => _teachers;

  List<AssignmentFile> _assignmentFiles = [];
  List<AssignmentFile> get assignmentFiles => _assignmentFiles;

  getAssignment(String token) async {
    try {
      //get teacher
      Dio.Response response = await dio().get('student/get-teachers',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      try {
        this._teachers = (response.data as List)
            .map((index) => User.fromJson(index))
            .toList();
      } catch (e) {
        this._teachers.add(User.fromJson(response.data));
      }

      // get assignments of the class
      response = await dio().get('student/get-assignment',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      try {
        this._assignments = (response.data as List)
            .map((index) => Assignment.fromJson(index))
            .toList();
      } catch (e) {
        this._assignments.add(Assignment.fromJson(response.data));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Mungkin anda belum terhubung ke VPN");
    }
    getAssignmentFiles(token);
    notifyListeners();
  }

  getAssignmentFiles(String token) async {
    this._assignmentFiles = [];
    try {
      Dio.Response response = await dio().get('student/get-assignmentFiles',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      try {
        this._assignmentFiles = (response.data as List)
            .map((index) => AssignmentFile.fromJson(index))
            .toList();
      } catch (e) {
        assignmentFiles.add(AssignmentFile.fromJson(response.data));
      }
    }catch (e) {
      Fluttertoast.showToast(msg: "Mungkin anda belum terhubung ke VPN");
    }
    notifyListeners();
  }

  submitAssignment(String token,String note, int assignmentId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path.toString(),
            filename: file.name),
        "note": note,
        "assignmentId": assignmentId
      });

      try {
        await dio().post('student/submit-assignment',
            data: formData,
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        Fluttertoast.showToast(
            msg: "Success, silahkan refresh untuk melihat hasil pengumpulan");
      } catch (e) {
        Fluttertoast.showToast(msg: "Mungkin anda belum terhubung ke VPN");
      }
    } else {}
  }
}
