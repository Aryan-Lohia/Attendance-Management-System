import 'dart:io';

import 'package:attendance_management/classAttendance.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import 'global.dart';

class Record extends StatefulWidget {
  final CameraController controller;
  final subId;

  const Record({Key? key, required this.controller,required this.subId}) : super(key: key);

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {
  bool isRecording = false;
  VideoPlayerController? controller;

  XFile? file;
  @override
  void dispose()
  {
    super.dispose();
    controller?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton:  file==null?isRecording
          ? IconButton(
          onPressed: () async {
            file = await widget.controller.stopVideoRecording();
            isRecording = false;
            controller=VideoPlayerController.file(File(file!.path));
            controller!.initialize().then((value)  {
            controller!.setLooping(true);
            setState(() {});
            controller!.play();
            });
          },
          icon: const Icon(
            Icons.stop,
            color: Colors.white,
            size: 50,
          ))
          : IconButton(
          onPressed: () async {
            await widget.controller.startVideoRecording();
            isRecording = true;
            setState(() {});
          },
          icon: Icon(
            Icons.camera,
            color: Colors.white,
            size: 50,
          )):Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: file == null?
          CameraPreview(widget.controller)
      :controller!.value.isInitialized
          ? Column(
            children: [
              AspectRatio(
        aspectRatio: 9/16,
        child: VideoPlayer(controller!),
      ),
              //name:subject uid
              //file:filename
              InkWell(
                onTap: () async {
                  Dio dio=Dio();
                  Directory path=await getTemporaryDirectory();
                  File f=File(path.path+widget.subId+".mp4");
                      f.writeAsBytesSync(await file!.readAsBytes());
                  FormData data=FormData.fromMap({
                    'name':widget.subId+".mp4",
                    'file': await MultipartFile.fromFile(
                        f.path,
                        filename: '${widget.subId+".mp4"}'),
                  });
                  dio.post("http://192.168.231.25:3001/faculty/upload/",
                  data: data,
                    options: Options(
                      headers:  {
                        "Authorization":
                        'Bearer ${await storage.read(key: "jwt")}',
                      }
                    )
                  );
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: "Attendance Updated");
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.navigate_next),
                ),
              )
            ],
          )
          : Container(),
    );
  }
}
