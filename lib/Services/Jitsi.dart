import 'package:fluttertoast/fluttertoast.dart';
import 'package:gerbangsekolah/Models/Grade.dart';
import 'package:gerbangsekolah/Models/User.dart';
import 'package:gerbangsekolah/Services/Dio.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:url_launcher/url_launcher.dart';

joinMeeting(User user, Grade grade) async {
  if (grade.virtualClassroom!.contains(meetUrl)) {
    try {
      String room = grade.virtualClassroom!.substring(41);
      String avatar = baseUrl + "images/profile/" + user.profilePicture;
      var options = JitsiMeetingOptions(room: room)
        ..serverURL = meetUrl
        ..userDisplayName = user.name
        ..userEmail = user.email
        ..userAvatarURL = avatar
        ..audioMuted = true
        ..videoMuted = true;

      await JitsiMeet.joinMeeting(options);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: " + e.toString());
    }
  } else {
    try {
      await launch(grade.virtualClassroom.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: "Link Tidak Benar");
    }
  }
}
