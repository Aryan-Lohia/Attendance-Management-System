import 'package:flutter/material.dart';
class ClassAttendance extends StatefulWidget {
  const ClassAttendance({Key? key}) : super(key: key);

  @override
  State<ClassAttendance> createState() => _ClassAttendanceState();
}

class _ClassAttendanceState extends State<ClassAttendance> {
  var semesters = [
    '1st',
    '2nd',
    '3rd',
    '4th',
    '5th'
  ];
  var sections=[
    'A',
    'B',
    'C'
  ];
  var subjects=[
    'Math',
    'CS'
  ];
  String semester = '1st';
  String section = 'A';
  String subject = 'Math';
  TextEditingController noController=TextEditingController(text: "1");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attendance"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Giving Attendance for "),
                Container(
                  width: 20,
                  child: TextField(
                    controller: noController,
                    keyboardType: TextInputType.number,
                    onChanged: (text){
                      setState(() {});
                    },
                  ),
                ),
                Text("Classes")
              ],
            ),
            Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              children:[
                DropdownButton(
                  value: semester,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: semesters.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      semester = newValue!;
                    });
                  },
                ),
                DropdownButton(
                  value: section,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: sections.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      section = newValue!;
                    });
                  },
                ),
                DropdownButton(
                  value: subject,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: subjects.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      subject = newValue!;
                    });
                  },
                ),
              ],),
            Container(
              height: 500,
              child: ListView.builder(itemCount: 50,
                  itemBuilder: (context,index){
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      color: Colors.cyanAccent.shade100,
                      child: Row(
                          children:[
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("lorem ipsum"),
                            ),
                            Spacer(),
                            IconButton(onPressed: (){}, icon: Icon(Icons.remove,size: 30,)),
                            Text(noController.value.text),
                            IconButton(onPressed: (){}, icon: Icon(Icons.add,size: 30,)),
                            SizedBox(width: 30,)
                          ]),
                    );
                  }),
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){}, child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Submit"),
            ))

          ],
        ),
      ),
    );
  }
}
