import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerbangsekolah/Services/Auth.dart';
import 'package:gerbangsekolah/Services/Dio.dart';
import 'package:gerbangsekolah/Services/Jitsi.dart';
import 'package:gerbangsekolah/Services/TeacherAct.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TeacherDashboard extends StatefulWidget {
  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  static TextEditingController _newLinkController = new TextEditingController();
  static RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
        child: Center(child: Consumer2<Auth, TeacherAct>(
            builder: (context, Auth auth, TeacherAct teacherAct, _) {
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
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber,
                  ),
                  onPressed: () {
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                  child: Text('logout')),
              Expanded(
                child: SmartRefresher(
                  enablePullDown: true,
                  header: WaterDropHeader(
                    waterDropColor: (Colors.blue[200])!,
                  ),
                  onRefresh: () {
                    auth.getData(auth.token);
                    _refreshController.refreshCompleted();
                  },
                  controller: _refreshController,
                  child: ListView.builder(
                    itemCount: auth.grades.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Container(
                          height: 100,
                          child: Card(
                            color: Colors.amber[50],
                            elevation: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        auth.grades[index].className,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        auth.grades[index].classDescription == null
                                            ? ""
                                            : auth.grades[index].classDescription.toString(),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 30),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      joinMeeting(
                                          auth.user, auth.grades[index]);
                                    },
                                    child: Text("Masuk"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () async {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(auth.grades[index].className),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(auth.grades[index].virtualClassroom
                                          .toString()),
                                      TextField(
                                        controller: _newLinkController,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Batalkan',
                                        style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Terapkan'),
                                    onPressed: () {
                                      teacherAct.updateVirtualClassroom(
                                          auth.grades[index].id,
                                          _newLinkController.text,
                                          auth.token);
                                      _newLinkController.text = "";
                                      auth.getData(auth.token);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        })));
  }
}
