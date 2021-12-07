import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerbangsekolah/Models/Assignment.dart';
import 'package:gerbangsekolah/Models/AssignmentFile.dart';
import 'package:gerbangsekolah/Services/Auth.dart';
import 'package:gerbangsekolah/Services/Dio.dart';
import 'package:gerbangsekolah/Services/StudentAct.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class StudentAssignment extends StatefulWidget {
  @override
  _StudentAssignmentState createState() => _StudentAssignmentState();
}

class _StudentAssignmentState extends State<StudentAssignment> {
  static RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<StudentAct>(context, listen: false)
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
      child: Center(child: Consumer2<Auth, StudentAct>(
        builder: (context, Auth auth, StudentAct studentAct, _) {
          return Column(
            children: [
              Container(
                height: 100,
                child: Center(
                  child: Text("Halaman Penugasan",
                    style: TextStyle(
                      fontFamily: 'WorkSansBold',
                      fontSize: 20.0)),
                ),
              ),
              Expanded(
                child: SmartRefresher(
                    enablePullDown: true,
                    header: WaterDropHeader(
                      waterDropColor: (Colors.blue[700])!,
                    ),
                    onRefresh: () {
                      studentAct.getAssignment(auth.token);
                      _refreshController.refreshCompleted();
                    },
                    controller: _refreshController,
                    child: ListView.builder(
                      //list of teachers
                      itemCount: studentAct.teachers.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.amber[50],
                          child: Column(
                            children: [
                              SizedBox(height: 10,),
                              Text(studentAct.teachers[index].name,
                                  style: TextStyle(
                                    fontFamily: 'WorkSansBold',
                                    fontSize: 20.0)
                                  ),
                              SizedBox(height: 10,),
                              Column(
                                children: [
                                  // List of assignment
                                  SizedBox(height: 10,),
                                  for (Assignment assignment in studentAct.assignments)
                                    if (assignment.teacherId == studentAct.teachers[index].id)
                                      InkWell(
                                        child: Container(
                                          height: 75,
                                          child: Card(
                                            shape: new RoundedRectangleBorder(
                                              side: new BorderSide(
                                                  color: Colors.blue,
                                                  width: 2.0),
                                              borderRadius: BorderRadius.circular(4.0)
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only( left: 10),
                                                  width: 175,
                                                  child: Text(assignment.title, style: 
                                                    TextStyle(
                                                      fontFamily: 'WorkSansMedium',
                                                      fontSize: 15.0)
                                                      )
                                                ),
                                                SizedBox( width: 20, ),
                                                Container(
                                                  child: Text(
                                                    assignment.description == null
                                                        ? ''
                                                        : assignment.description.toString(),
                                                    style: TextStyle(
                                                      fontFamily: 'WorkSansSemiBold',
                                                      fontSize: 17.0),
                                                  )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          showCupertinoModalBottomSheet(
                                            context: context,
                                            builder: (context) => Scaffold(
                                              body: Column(
                                                children: [
                                                  for (AssignmentFile assignmentFile in studentAct.assignmentFiles)
                                                    if (assignmentFile.assignmentId == assignment.id)
                                                      Container(
                                                        padding: EdgeInsets.only( top: 50, left: 10, right: 10),
                                                        child: Column(
                                                          children: [
                                                            Text(assignment.title, style:TextStyle(
                                                              fontFamily: 'WorkSansBold',
                                                              fontSize: 20.0),),
                                                            Text(assignment.description == null ? '' : assignment.description.toString(),style:TextStyle(
                                                              fontFamily: 'WorkSansMedium',
                                                              fontSize: 15.0),),
                                                            SizedBox( height: 20),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                assignmentFile.file == null
                                                                    ? Text("Belum mengumpulkan")
                                                                    : assignmentFile.score == null
                                                                        ? Text("Belum dinilai")
                                                                        : Text("Nilai : " + assignmentFile.score.toString()),
                                                                ElevatedButton(
                                                                  onPressed: () async {
                                                                    showDialog<void>( context:context, barrierDismissible:false, builder:(BuildContext context) {
                                                                      return AlertDialog(
                                                                        title: Text("Pengumpulan tugas"),
                                                                        content: SingleChildScrollView(
                                                                          child: ListBody(
                                                                            children: <Widget>[
                                                                              TextFormField(
                                                                                controller: _noteController,
                                                                                decoration: InputDecoration(hintText: "Catatan",
                                                                                ),
                                                                                validator: (value) {
                                                                                  if (value == null || value.isEmpty) {return 'Please enter some text';}
                                                                                  return null;
                                                                                },
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        actions: <Widget>[
                                                                          TextButton(
                                                                            child: Text('Batalkan', style: TextStyle(color: Colors.red)),
                                                                            onPressed: () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                          TextButton(
                                                                            child: Text('Terapkan'),
                                                                            onPressed: () {
                                                                              studentAct.submitAssignment(auth.token, _noteController.text, assignment.id);
                                                                              studentAct.getAssignmentFiles(auth.token);
                                                                              _noteController.text = '';
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },);
                                                                  },
                                                                  child: Icon(Icons.upload_file),
                                                                  style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Colors.green)),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 10),
                                                          ],
                                                        ),
                                                      ),

                                                  
                                                  for (AssignmentFile assignmentFile in studentAct.assignmentFiles)
                                                    if (assignmentFile.assignmentId == assignment.id && assignmentFile.file != null)
                                                      Expanded(
                                                        child: SfPdfViewer.network(baseUrl + 'assignment/${assignmentFile.file}'))
                                                ],
                                              )));
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
        }
      ))
    );
  }
}
