import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gerbangsekolah/Models/Assignment.dart';
import 'package:gerbangsekolah/Models/AssignmentFile.dart';
import 'package:gerbangsekolah/Services/Auth.dart';
import 'package:gerbangsekolah/Services/Dio.dart';
import 'package:gerbangsekolah/Services/TeacherAct.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TeacherAssignment extends StatefulWidget {
  @override
  _TeacherAssignmentState createState() => _TeacherAssignmentState();
}

class _TeacherAssignmentState extends State<TeacherAssignment> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _scoreController = TextEditingController();
  static RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  listAssignment(List<Assignment> assignments, int id) {
    List<Widget> list = [];
    assignments.forEach((assignment) {
      print(assignment.title);
      list.add(Text(assignment.title));
    });
    return list;
  }

  @override
  void initState() {
    super.initState();
    Provider.of<TeacherAct>(context, listen: false)
        .getAssignment(Provider.of<Auth>(context, listen: false).token);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[Colors.blue, Colors.amber],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.5),
              stops: <double>[0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
      child: Center(child: Consumer2<Auth, TeacherAct>(
        builder: (context, Auth auth, TeacherAct teacherAct, _) {
          return Column(
            children: [
              Container(
                height: 100,
                child: Center(
                  child: Text("Halaman Penugasan", style:TextStyle(
                    fontFamily: 'WorkSansBold',
                    fontSize: 20.0))
                ),
              ),
              Expanded(
                child: SmartRefresher(
                  enablePullDown: true,
                  header: WaterDropHeader( waterDropColor: (Colors.blue[700])!, ),
                  onRefresh: () {
                    teacherAct.getAssignment(auth.token);
                    _refreshController.refreshCompleted();
                  },
                  controller: _refreshController,
                  child: ListView.builder(
                    itemCount: auth.grades.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.amber[50],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(auth.grades[index].className, style: TextStyle(
                              fontFamily: 'WorkSansBold',
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                            Column(
                              children: [
                                // Create Assignment
                                InkWell(
                                  child: Container(
                                    height: 50,
                                    width: 100,
                                    child: Card(
                                      color: Colors.greenAccent,
                                      child: Center(
                                        child: Text("+", style: TextStyle(
                                            fontFamily: 'WorkSansBold',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ))),
                                    ),
                                  ),
                                  onTap: () async {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible:false, // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text( auth.grades[index].className, style: TextStyle(
                                            fontFamily: 'WorkSansBold',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,)),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                TextFormField(
                                                  controller:
                                                      _titleController,
                                                  decoration: InputDecoration(
                                                    hintText: "Title",
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter some text';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                TextFormField(
                                                  controller:
                                                      _descriptionController,
                                                  decoration: InputDecoration(
                                                    hintText: "Description",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Batalkan',
                                                  style: TextStyle(color: Colors.red)),
                                              onPressed: () {
                                                _titleController.text = "";
                                                _descriptionController.text =
                                                    "";
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Terapkan'),
                                              onPressed: () {
                                                Map creds = {
                                                  'title':
                                                      _titleController.text,
                                                  'description':
                                                      _descriptionController
                                                          .text,
                                                  'gradeId':
                                                      auth.grades[index].id,
                                                };
                                                teacherAct.createAssignment( auth.token, creds);
                                                _titleController.text = "";
                                                _descriptionController.text = "";
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                // List of an assignment
                                for (Assignment assignment in teacherAct.assignments)
                                  if (assignment.gradeId == auth.grades[index].id)
                                    InkWell(
                                      child: Container(
                                        height: 50,
                                        width: 100,
                                        child: Card(
                                          color: Colors.blue[300],
                                          child: Center(
                                              child: Text(assignment.title, style: TextStyle(
                                            fontFamily: 'WorkSansMedium',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,))),
                                        ),
                                      ),
                                      // show modal bottom shit
                                      onTap: () async {
                                        await teacherAct.getAssignmentFiles(auth.token, assignment.id);
                                        showCupertinoModalBottomSheet(
                                          context: context,
                                          builder: (context) => Scaffold(
                                            body: Consumer<TeacherAct>(
                                              builder: (context,TeacherAct teacherAct,_) {
                                                return Column(
                                                  children: [
                                                    for (AssignmentFile assignmentfile
                                                        in teacherAct.assignmentFile)
                                                      Slidable(
                                                        actionPane:
                                                            SlidableDrawerActionPane(),
                                                        actionExtentRatio: 0.25,
                                                        child: ListTile(
                                                          title: Text(assignmentfile.studentName, style: TextStyle(
                                                            fontFamily: 'WorkSansMediun',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 15,)),
                                                          subtitle: assignmentfile.file == null
                                                              ? Text('Belum mengumpulkan')
                                                              : Text(assignmentfile.note ==null
                                                                  ? "Sudah mengumpulkan"
                                                                  : assignmentfile.note.toString()),
                                                        ),
                                                        actions: <Widget>[
                                                          IconSlideAction(
                                                              caption: 'Tampilkan',
                                                              color: Colors.blue,
                                                              icon: Icons.panorama_fish_eye,
                                                              onTap: () async {
                                                                if(assignmentfile.file != null)
                                                                  showCupertinoModalBottomSheet(
                                                                  elevation:1.0,
                                                                  context:context,
                                                                  builder: (context) => Container(
                                                                    child:Column(
                                                                      children: [
                                                                        Text(assignmentfile.file.toString(),
                                                                          style: TextStyle(
                                                                            fontFamily: 'WorkSansMedium',
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 20,)),
                                                                        Expanded(child: SfPdfViewer.network(baseUrl + 'assignment/${assignmentfile.file}')),
                                                                      ]
                                                                    )
                                                                  )
                                                                );
                                                                else Fluttertoast.showToast(msg: "Siswa belum mengumpulkan");
                                                              }),
                                                          IconSlideAction(
                                                            caption: assignmentfile.score == null
                                                                ? 'Nilai'
                                                                : 'Nilai : ${assignmentfile.score}',
                                                            color: Colors.indigo,
                                                            icon: Icons.score,
                                                            onTap: assignmentfile.file == null
                                                                ? () {}
                                                                : () async {
                                                                    showDialog<void>(
                                                                      context: context,
                                                                      barrierDismissible: false, // user must tap button!
                                                                      builder: (BuildContext context) {
                                                                        return AlertDialog(
                                                                          title: Text(auth.grades[index].className),
                                                                          content: SingleChildScrollView(
                                                                            child: ListBody(
                                                                              children: <Widget>[
                                                                                TextField(
                                                                                  controller: _scoreController,
                                                                                  decoration: new InputDecoration(labelText: "Masukkan Nilai"),
                                                                                  keyboardType: TextInputType.number,
                                                                                  inputFormatters: <TextInputFormatter>[
                                                                                    FilteringTextInputFormatter.digitsOnly
                                                                                  ], // Only numbers can be entered
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          actions: <
                                                                              Widget>[
                                                                            TextButton(
                                                                              child: Text('Batal', style: TextStyle(color: Colors.red)),
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                            ),
                                                                            TextButton(
                                                                              child: Text('Terapkan'),
                                                                              onPressed: () {
                                                                                Map data = {
                                                                                  'assignmentFileId': assignmentfile.id,
                                                                                  'score': _scoreController.text,
                                                                                };
                                                                                teacherAct.scoringAssignment(auth.token, data);
                                                                                _scoreController.text = "";
                                                                                teacherAct.getAssignmentFiles(auth.token, assignment.id);
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                );
                                            }),
                                          ),
                                        );
                                      },
                                      onLongPress: () async {
                                        showDialog<void>(
                                            context: context,
                                            barrierDismissible:
                                                false, // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Hapus tugas " + assignment.title + " dari " + auth.grades[index].className),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Batalkan', style: TextStyle(color:Colors.blue)),
                                                    onPressed: () {Navigator.of(context).pop();},
                                                  ),
                                                  TextButton(
                                                    child: Text(
                                                      'Hapus',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    onPressed: () {
                                                      Map creds = {
                                                        'id': assignment.id,
                                                      };
                                                      teacherAct
                                                          .deleteAssignment(
                                                              auth.token,
                                                              creds);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  )),
              ),
            ],
          );
      })));
  }
}
