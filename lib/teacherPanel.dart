import 'dart:convert';

import 'package:attendance_management/editattendance.dart';
import 'package:attendance_management/record.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:requests/requests.dart';

import 'admin.dart';
import 'global.dart';

class TeacherPanel extends StatefulWidget {
  const TeacherPanel({Key? key}) : super(key: key);

  @override
  State<TeacherPanel> createState() => _TeacherPanelState();
}

class _TeacherPanelState extends State<TeacherPanel> {
  List<Widget> subjects = [];
  late List<CameraDescription> _cameras;
  late CameraController controller;
  bool isLoading = true;
  bool isLoadingSub = true;

  void initCameras() async {
    PermissionStatus status;
    status = await Permission.camera.request();
    while (!status.isGranted) {
      status = await Permission.camera.request();
    }
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.medium,
        enableAudio: false);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initCameras();
    getSubjects(context);
  }

  Future<void> getSubjects(BuildContext context) async {
    setState(() {
      isLoadingSub=true;
    });
    final res = await Requests.get(
        "http://192.168.231.25:3001/faculty/subjects/${jsonDecode((await storage.read(key: "details"))!)['_id']}",
        headers: {
          "Authorization": 'Bearer ${await storage.read(key: "jwt")}',
        });
    if (res.statusCode == 200) {
      subjects = [];
      List subs = jsonDecode(res.body)["subjects"];
      for (var i in subs) {
        print(i);
        subjects.add(Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          height: 130,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 228, 196, 1),
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(i["subject_name"].toString().toUpperCase(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: 10,
                  ),
                  Text(i["subject_code"].toString().toUpperCase(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/2.5,

                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Row(
                        children: [
                          Text("Sem: ${i['semester']}"),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Dept: ${i['department']}"),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Sec: ${i['section']}"),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color.fromRGBO(193, 154, 107, 1))
                    ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Record(controller: controller,subId: i['_id'],)));
                      },
                      child: Text("Take Attendance",)),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color.fromRGBO(193, 154, 107, 1))
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>EditAttendance(dept:i['department'] ,sec:i['section'] ,sem:i['semester'],sub:i["subject_name"],code:i['subject_code'])));
                      },
                      child: Text("Edit Attendance")),
                ],
              ),
            ],
          ),
        ));
      }
      setState(() {
        isLoadingSub = false;
      });
    } else {
      Fluttertoast.showToast(msg: "Check Connection and Try Again!");
      isLoadingSub = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 245, 224, 1),
        floatingActionButton: CircleAvatar(
          backgroundColor: Color.fromRGBO(193, 154, 107, 1),
            radius: 35,
            child: IconButton(
              color: Colors.white,

              icon: Icon(Icons.add),onPressed: () async { await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddSubject()));
            getSubjects(context);},)),
          appBar: AppBar(
            title: Text("Subjects",style: TextStyle(color: Colors.black,fontSize: 30,letterSpacing: 2),),
            centerTitle: true,
            toolbarHeight: 100,
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            actions: [IconButton(onPressed: (){
              Navigator.pop(context);
              storage.deleteAll();
            }, icon: Icon(Icons.logout,color: Colors.black,))],
          ),
          body: isLoading || isLoadingSub
              ? Center(
            child: CircularProgressIndicator(),
          )
              : SingleChildScrollView(
            padding: EdgeInsets.only(top: 0,bottom: 50),
            child: Column(
              children: [
                subjects.length == 0
                    ? Center(child: Text("No Subjects Found"))
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      subjects,
                )
              ],
            ),
          )),
    );
  }
}
