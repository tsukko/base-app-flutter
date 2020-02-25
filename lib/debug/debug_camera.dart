import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras;

class DebugCamera extends StatefulWidget {
  @override
  _DebugCameraState createState() => _DebugCameraState();
}

class _DebugCameraState extends State<DebugCamera> {
  var qrText = "";
  CameraController controller;

  Future<void> getCameras() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);
  }

  @override
  void initState() {
    super.initState();
    getCameras().then((_) {
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }

        controller.startImageStream((availableImage) {
//          controller.stopImageStream();
          _scanText(availableImage);
        });
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    if (controller != null && controller.value.isStreamingImages) {
      controller.stopImageStream();
    }
    super.dispose();
  }

  Future<String> takePicture() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/own_note';
    await Directory(dirPath).create(recursive: true);
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    final String filePath = '$dirPath/$timestamp.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.startImageStream((availableImage) {
//        controller.stopImageStream();
        _scanText(availableImage);
      });
    } on CameraException catch (e) {
      // エラー時の処理
      print('CameraException. e: ${e.toString()}');
      return null;
    }
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    } else {
      return Column(
        children: <Widget>[
          AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('result : $qrText', style: const TextStyle(fontSize: 18)),
              RaisedButton(
                child: Icon(
                  Icons.camera,
                  size: 30,
                ),
                onPressed: () async {
//                  var filePath = await takePicture();
                },
              ),
            ],
          ),
        ],
      );
    }
  }

  static const platform = MethodChannel('com.tasogarei.test/camera');

  Future<void> _scanText(CameraImage availableImage) async {
//    print("start _scanText. height:${availableImage.height}, "
//        "width:${availableImage.width}, format.group:${availableImage.format.group}.");
//
//    availableImage.planes.asMap()
//      ..forEach((index, plan) {
//        print("planes $index. height:${plan.height}, width:${plan.width},"
//            " bytesPerPixel:${plan.bytesPerPixel}, bytesPerRow:${plan.bytesPerRow},"
//            " length:${plan.bytes.length}, lengthInBytes:${plan.bytes.lengthInBytes},  ");
//      });

//    print("bytes    : ${availableImage.planes[0].bytes}");
//    print("bytes buf: ${availableImage.planes[0].bytes.buffer}");

//    var bytesList = availableImage.planes.map((plane) {
//      return plane.bytes;
//    }).toList();

    String barcode = await platform.invokeMethod('camera', {
      "bytes": availableImage.planes[0].bytes,
      "height": availableImage.height,
      "width": availableImage.width
    });
    if (!mounted) {
      return;
    }
    setState(() {
      if (barcode.isNotEmpty) {
        if (controller != null && controller.value.isStreamingImages) {
          controller.stopImageStream();
        }
        qrText = barcode;
        Fluttertoast.showToast(msg: "barcode: $barcode");
      }
    });
  }
}
