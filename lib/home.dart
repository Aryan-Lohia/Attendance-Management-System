import 'dart:convert';
import 'dart:ui';
import 'package:attendance_management/admin.dart';
import 'package:attendance_management/studentPanel.dart';
import 'package:attendance_management/teacherPanel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';

import 'global.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<String?> attemptLogIn(String uid, String password) async {
    var res = await Requests.post(
        "http://192.168.231.25:3001/auth/login",
        body: {
          "uid": uid,
          "password": password
        }
    );
    if(res.statusCode == 200) return res.body;
    return null;
  }

  TextEditingController user=TextEditingController();
  TextEditingController pass=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.png"),fit: BoxFit.cover
            )
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100,),
                Center(child: Container(
                  height: 100,
                  width: 100,
                  child:Image.asset("assets/logo.png"),)),
                Center(child: Text("LOGIN",style: TextStyle(fontSize: 30,fontWeight:FontWeight.w200,letterSpacing: 2),)),
                SizedBox(height: 30,),
                Container(

                  child: Form(child: Column(
                    children: [
                      TextFormField(
                        controller: user,
                        decoration: InputDecoration(
                          label: Text("User Id"),
                          labelStyle: TextStyle(color: Colors.black),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                          ),
                            border: UnderlineInputBorder()

                        ),
                      ),
                      SizedBox(height: 25,),
                      TextFormField(
                        controller: pass,
                        decoration: InputDecoration(
                          label: Text("Password"),
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)
                            ),
                            border: UnderlineInputBorder()

                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Spacer(),
                          TextButton(
                            onPressed: (){
                              Fluttertoast.showToast(msg: "Will be added soon!");
                            },
                            child: Text("Forgot Password?"),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      ElevatedButton(onPressed: login,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color.fromRGBO(193, 154, 107, 1))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: const Text(
                        "Submit",
                        style: TextStyle(color:Colors.black,fontWeight:FontWeight.normal,fontSize: 18),
                      ),
                          ))
                    ],
                  )),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
  void login()async
  {
    String? a=await attemptLogIn(user.value.text, pass.value.text);
    if(a!=null){
      Map details=(jsonDecode(a));
      await storage.write(key: "jwt", value:details['data']['token']);
      await storage.write(key: "details", value: jsonEncode(details['data']['user']));
      if(details['data']['user']['user_type']=="student")
        {
          Navigator.push(context,MaterialPageRoute(builder: (context)=>StudentPanel()));
        }
      else if(details['data']['user']['user_type']=="admin")
        {
          Navigator.push(context,MaterialPageRoute(builder: (context)=>AdminPanel()));
        }
      else
        {
          Navigator.push(context,MaterialPageRoute(builder: (context)=>TeacherPanel()));
        }
    }
    }
}
