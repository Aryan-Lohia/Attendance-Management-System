import 'dart:convert';

import 'package:attendance_management/attendancesheet.dart';
import 'package:attendance_management/reviewAttendance.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';

import 'global.dart';

class StudentPanel extends StatefulWidget {
  const StudentPanel({Key? key}) : super(key: key);

  @override
  State<StudentPanel> createState() => _StudentPanelState();
}

class _StudentPanelState extends State<StudentPanel> {
  bool isLoading=true;
  Map details={};
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData()
  async {
    setState(() {
      isLoading=true;
    });
    final res = await Requests.get(
        "http://192.168.231.25:3001/student/profile",
        headers: {
          "Authorization": 'Bearer ${await storage.read(key: "jwt")}',
        });
    if(res.statusCode==200)
      {
        details=jsonDecode(res.body);
        print(details);
      }
    setState(() {
      isLoading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 245, 224, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
      body: isLoading?Center(child: CircularProgressIndicator(),): Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 200,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            details['user']['name'],
                            style: TextStyle(letterSpacing: 2, fontSize: 10),
                          ),
                          Text(
                            details['user']['uid'],
                            style: TextStyle(letterSpacing: 2, fontSize: 8),
                          ),
                          SizedBox(
                            height: 15,
                            width: 100,
                          ),
                          Text(
                            "${details['student']['department']} -2025",
                            style: TextStyle(letterSpacing: 2, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      "backend/attendance/server/${details['student']['image']}",
                    ),
                    backgroundColor: Colors.white,
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AttendanceSheet(subjects: details['subjects'],attendance: details['attendance'],)));
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromRGBO(166, 123, 91, 1),
                    ),
                    width: MediaQuery.of(context).size.width /1.1,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Text(
                            "Check\nAttendance",
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                        ),

                        Image.asset('assets/1.png')
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout,size: 30,),
                SizedBox(width: 15,),
                const Text("Log Out",style: TextStyle(fontSize: 20),),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              storage.deleteAll();
            },
          )
        ],
      ),
    );
  }
}
