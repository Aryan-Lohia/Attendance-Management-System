import 'package:flutter/material.dart';
class ReviewAttendance extends StatelessWidget {
  const ReviewAttendance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    );
  }
}
