import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerbangsekolah/Services/Auth.dart';
import 'package:gerbangsekolah/Services/Dio.dart';
import 'package:gerbangsekolah/Services/Jitsi.dart';
import 'package:provider/provider.dart';

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[Colors.blue, Colors.amber],
              begin: FractionalOffset(0.0, 1.0),
              end: FractionalOffset(1.0, 0.0),
              stops: <double>[0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Center(child: Consumer<Auth>(builder: (context, auth, _) {
          return Column(
            children: [
              SizedBox(height: 40),
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    baseUrl + 'images/profile/' + auth.user.profilePicture),
                radius: 70,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                auth.user.name,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Poppins"),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                  style: ElevatedButton.styleFrom( primary: Colors.amber,),
                  onPressed: () {
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                  child: Text('logout')),
              SizedBox(height: 50),
              Text("Kelas " + auth.grades[0].className, style: TextStyle(
                  fontFamily: 'WorkSansBold',
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
              ElevatedButton(
                onPressed: () {
                  joinMeeting(auth.user, auth.grades[0]);
                },
                child: Text("Masuk", style: TextStyle(
                  fontFamily: 'WorkSansBold',
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
              ),
            ],
          );
        })));
  }
}
