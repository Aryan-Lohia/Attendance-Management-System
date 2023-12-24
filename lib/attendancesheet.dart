import 'package:flutter/material.dart';

class AttendanceSheet extends StatefulWidget {
  final List subjects;
  final List attendance;
  const AttendanceSheet({Key? key,required this.subjects,required this.attendance}) : super(key: key);

  @override
  State<AttendanceSheet> createState() => _AttendanceSheetState();
}

class _AttendanceSheetState extends State<AttendanceSheet> {
  @override
  Widget build(BuildContext context) {
    print(widget.subjects);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "Attendance",
            style: TextStyle(
                color: Colors.black, fontSize: 30, letterSpacing: 2),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,size: 50, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color.fromRGBO(255, 245, 224, 1),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 30),
        itemBuilder: (context,index){
        return Container(
          height:100 ,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color:Color.fromRGBO(193, 154, 107, 1)
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.subjects[index]["subject_code"],style: TextStyle(color: Colors.white),),
                  SizedBox(height: 10,),
                  Text(widget.subjects[index]["subject_name"],style: TextStyle(color: Colors.white,fontSize: 18),),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Text("${widget.subjects[index]["classesTaken"]!=0?widget.attendance[index]*100/widget.subjects[index]["classesTaken"]:100}%",style: TextStyle(color: Colors.white,fontSize: 25)),
                  VerticalDivider(color: Colors.white,width: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.attendance[index].toString(),style: TextStyle(color: Colors.white)),
                      Text("------",style: TextStyle(color: Colors.white,letterSpacing: -2,height: 1)),
                      Text(widget.subjects[index]["classesTaken"].toString(),style: TextStyle(color: Colors.white)),
                    ],
                  )
                ],
              )
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        );
      },itemCount: widget.subjects.length,),
    );
  }
}
