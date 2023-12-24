import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';

import 'global.dart';

class EditAttendance extends StatefulWidget {
  final sem;
  final sec;
  final dept;
  final sub;
  final code;

  const EditAttendance(
      {Key? key,
      required this.sem,
      required this.sec,
      required this.dept,
      required this.sub,
      required this.code})
      : super(key: key);

  @override
  State<EditAttendance> createState() => _EditAttendanceState();
}

class _EditAttendanceState extends State<EditAttendance> {
  List studentList = [];
  List attendanceList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final res = await Requests.get(
        "http://192.168.231.25:3001/faculty/students/${widget.sem + widget.sec + widget.dept + widget.code}",
        headers: {
          "Authorization": 'Bearer ${await storage.read(key: "jwt")}',
        });
    List k = jsonDecode(res.body)['studentList'];
    print(k.sublist(0,(k.length/2).toInt()));
    for (var i in k.sublist(0,(k.length/2).toInt()))
        {
          attendanceList.add(i['attended']);
        }
    studentList = k.sublist((k.length / 2).toInt());
    setState(() {
      isLoading = false;
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
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Edit",
              style: TextStyle(
                  color: Colors.black, fontSize: 30, letterSpacing: 2),
            ),
          ),
          centerTitle: true,
          actions: [Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: (){
              Navigator.pop(context);
              Fluttertoast.showToast(msg: "Attendance Updated!");
            }, icon: Icon(Icons.check_rounded,color: Colors.black,size: 30,)),
          )],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 60,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.search)),
                          Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width - 150,
                            child: Center(
                              child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${widget.code} ${widget.sub} ",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 2),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.share))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "Name",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Container(
                      height: 517,
                      child: ListView.builder(
                          itemCount: studentList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              color: index % 2 == 0
                                  ? Color.fromRGBO(193, 154, 107, 1)
                                  : Color.fromRGBO(245, 245, 220, 1),
                              child: Row(children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(studentList[index]['name']),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(studentList[index]['uid']),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {attendanceList[index]--;
                                            setState(() {

                                            });},
                                            icon: Icon(
                                              Icons.remove,
                                              size: 30,
                                            )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(attendanceList[index].toString()),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        IconButton(
                                            onPressed: () {attendanceList[index]++;
                                              setState(() {

                                              });
                                              },
                                            icon: Icon(
                                              Icons.add,
                                              size: 30,
                                            )),
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                            );
                          }),
                    ),
                  ],
                ),
              ));
  }
}
