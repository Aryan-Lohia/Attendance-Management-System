import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:attendance_management/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:requests/requests.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 245, 224, 1),
      appBar: AppBar(
        title: Text(
          "Admin Panel",
          style: TextStyle(color: Colors.black, fontSize: 30, letterSpacing: 2),
        ),
        centerTitle: true,
        toolbarHeight: 100,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
                storage.deleteAll();
              },
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(166, 123, 91, 1))),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddTeacher()));
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Add Teacher"),
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Color.fromRGBO(166, 123, 91, 1))),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddStudent()));
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Add Student"),
            ),
          ),
        ],
      ),
    );
  }
}

class AddTeacher extends StatefulWidget {
  const AddTeacher({Key? key}) : super(key: key);

  @override
  State<AddTeacher> createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  TextEditingController name = TextEditingController();
  TextEditingController userId = TextEditingController();
  TextEditingController password = TextEditingController();
  bool showPass = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 245, 224, 1),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: Icon(Icons.keyboard_arrow_left,color: Colors.black,),onPressed: (){Navigator.pop(context);},),
        elevation: 0,
        toolbarHeight: 70,
        title: const Text(
          "Add Teacher",
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),

      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                const Text(
                  "Enter Teacher Details",
                  style: TextStyle(fontSize: 40),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text("Name")),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: userId,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text("User Id")),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                        child: TextFormField(
                          obscureText: !showPass,
                          controller: password,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Password")),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showPass = !showPass;
                            setState(() {});
                          },
                          icon: Icon(
                            showPass ? Icons.hide_source : Icons.remove_red_eye,
                            size: 40,
                          ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          if (name.value.text != "" &&
                              password.value.text != "" &&
                              userId.value.text != "") {
                            final res = await Requests.post(
                                "http://192.168.231.25:3001/admin/create",
                                body: {
                                  "userType": "faculty",
                                  "name": name.value.text,
                                  "password": password.value.text,
                                  "uid": userId.value.text
                                },
                                headers: {
                                  "Authorization":
                                      'Bearer ${await storage.read(key: "jwt")}',
                                });
                            if (res.statusCode == 201) {
                              final res1 = await Requests.post(
                                  "http://192.168.231.25:3001/admin/faculty",
                                  body: {
                                    "uid": userId.value.text
                                  },
                                  headers: {
                                    "Authorization":
                                        'Bearer ${await storage.read(key: "jwt")}',
                                  });
                              if (res1.statusCode == 201) {
                                Fluttertoast.showToast(
                                    msg: "Faculty Created Successfully");
                                Navigator.pop(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "User ID already Exists");
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "User ID already Exists");
                            }
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all( Color.fromRGBO(166, 123, 91, 1))
                  ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Submit",
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

//216x216px
class _AddStudentState extends State<AddStudent> {
  final ImagePicker picker = ImagePicker();
  File? imageFile;

  _getFromGallery() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
    );
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 500,
      maxHeight: 500,
    );
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController regn = TextEditingController();
  bool showPass = false;
  var semesters = [
    '1st',
    '2nd',
    '3rd',
    '4th',
    '5th',
    '6th',
    '7th',
    '8th',
  ];
  var sections = ['A', 'B', 'C'];
  var departments = ["CSE", "IT", "AI DS"];
  String semester = "1st";
  String department = "CSE";
  String section = "A";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 245, 224, 1),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: Icon(Icons.keyboard_arrow_left,color: Colors.black,),onPressed: (){Navigator.pop(context);},),
        elevation: 0,
        toolbarHeight: 70,
        title: const Text(
          "Add Student",
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const Text(
                  "Enter Student Details",
                  style: TextStyle(fontSize: 40),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.black,
                    backgroundImage: imageFile != null
                        ? FileImage(
                            imageFile!,
                          )
                        : null,
                    child: imageFile == null
                        ? IconButton(
                            icon: const Icon(Icons.upload),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => Dialog(
                                          child: Container(
                                        height: 100,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  _getFromCamera();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Camera")),
                                            const VerticalDivider(),
                                            TextButton(
                                                onPressed: () {
                                                  _getFromGallery();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Gallery")),
                                          ],
                                        ),
                                      )));
                            },
                          )
                        : Container(),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text("Name")),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: regn,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Regn No"),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                        child: TextFormField(
                          obscureText: !showPass,
                          controller: password,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Password")),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showPass = !showPass;
                            setState(() {});
                          },
                          icon: Icon(
                            showPass ? Icons.hide_source : Icons.remove_red_eye,
                            size: 40,
                          ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Semester: "),
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
                    const Text("Section: "),
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
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Department: "),
                    const SizedBox(
                      width: 40,
                    ),
                    DropdownButton(
                      value: department,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: departments.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          department = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (name.value.text != "" &&
                          password.value.text != "" &&
                          regn.value.text != "") {
                        final res = await Requests.post(
                            "http://192.168.231.25:3001/admin/create",
                            body: {
                              "userType": "student",
                              "name": name.value.text,
                              "password": password.value.text,
                              "uid": regn.value.text
                            },
                            headers: {
                              "Authorization":
                                  'Bearer ${await storage.read(key: "jwt")}',
                            });
                        if (res.statusCode == 201) {
                          final formData = FormData.fromMap({
                            'uid': regn.value.text,
                            'semester': semester,
                            "department": department,
                            "section": section,
                            'file': await MultipartFile.fromFile(
                                imageFile!.path,
                                filename: '${regn.value.text}.jpg'),
                          });
                          Dio dio = Dio();
                          final response = await dio.post(
                              "http://192.168.231.25:3001/admin/student",
                              data: formData,
                              options: Options(headers: {
                                "Authorization":
                                    'Bearer ${await storage.read(key: "jwt")}',
                              }));
                          if (response.statusCode == 201) {
                            Fluttertoast.showToast(
                                msg: "Student Created Successfully");
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                                msg: "User ID already Exists");
                          }
                        } else {
                          Fluttertoast.showToast(msg: "User ID already Exists");
                        }
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all( Color.fromRGBO(166, 123, 91, 1))
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("Submit"),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// name
// code
// sem
// dep
// sec
// faculty id

class AddSubject extends StatefulWidget {
  const AddSubject({Key? key}) : super(key: key);

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  TextEditingController name = TextEditingController();
  TextEditingController code = TextEditingController();
  var departments = ["CSE", "IT", "AI DS"];
  var semesters = [
    '1st',
    '2nd',
    '3rd',
    '4th',
    '5th',
    '6th',
    '7th',
    '8th',
  ];
  var sections = ['A', 'B', 'C'];
  String semester = "1st";
  String department = "CSE";
  String section = "A";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Subject"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Enter Subject Details",
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("Subject Name")),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: code,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("Subject Code")),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Semester: "),
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
                  const Text("Section: "),
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
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Department: "),
                  const SizedBox(
                    width: 40,
                  ),
                  DropdownButton(
                    value: department,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: departments.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        department = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (name.value.text != "" && code.value.text != "") {
                      final res = await Requests.post(
                          "http://192.168.231.25:3001/faculty/create",
                          body: {
                            "subject_name": name.value.text,
                            "subject_code": code.value.text,
                            "semester": semester,
                            'section': section,
                            'department': department,
                            'facultyId': jsonDecode(
                                (await storage.read(key: "details"))!)['_id'],
                            'uid': semester +
                                section +
                                department +
                                code.value.text
                          },
                          headers: {
                            "Authorization":
                                'Bearer ${await storage.read(key: "jwt")}',
                          });
                      if (res.statusCode == 201) {
                        Fluttertoast.showToast(msg: "Subject Added!");
                        Navigator.pop(context);
                      } else {
                        Fluttertoast.showToast(msg: "Subject Already Added");
                      }
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Submit"),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
