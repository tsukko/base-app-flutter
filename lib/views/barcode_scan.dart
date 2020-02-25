import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/medicine.dart';
import '../models/search_parameter.dart';
import '../repository/basic_api.dart';
import '../util/camera.dart';
import '../widget/camera_view.dart';
import '../widget/camera_view_overlay_shape.dart';

class BarcodeScan extends StatefulWidget {
  const BarcodeScan({
    Key key,
  }) : super(key: key);

  @override
  _BarcodeScanState createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<BarcodeScan> {
  String qrText = '';
  String flashState = Camera.flashOn;
  String cameraState = Camera.cameraFront;

//  QRViewController controller;
//  CameraController controller;

//  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  CameraController controller;
  static const platform = MethodChannel('com.tasogarei.test/camera');

  Future<void> getCameras() async {
    List<CameraDescription> cameras;
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);

    // バーコードデコードライブラリの初期化
//    await platform.invokeMethod('lib_init');
  }

  @override
  void initState() {
    super.initState();
    getCameras().then((_) {
      controller.initialize().then((_) {
        print('deb::controller.initialize');
        if (!mounted) {
          return;
        }

        controller.startImageStream((availableImage) {
//          print('deb::controller.startImageStream');
          _scanText(availableImage);
        });
        setState(() {});
      });
    });
  }

  Future<void> _scanText(CameraImage availableImage) async {
//    print("deb::_scanText: start. "
//        "height:${availableImage.height}, width:${availableImage.width}.");
    final String barcode = await platform.invokeMethod('camera', {
      // iOS、Android共通
      'bytes': availableImage.planes[0].bytes,
      // Android用
      'height': availableImage.height,
      'width': availableImage.width,
      // iOS用
      'bytesPerRow': availableImage.planes[0].bytesPerRow,
      'height0': availableImage.planes[0].height,
      'width0': availableImage.planes[0].width,
    });
    // await _showPdf(barcode);

    if (!mounted) {
      return;
    }
    setState(() {
//      print("deb::_scanText: setState");
      if (barcode.isNotEmpty) {
        if (controller != null && controller.value.isStreamingImages) {
          controller.stopImageStream();
        }
        qrText = barcode;
//        Fluttertoast.showToast(msg: "barcode: $barcode");

//        final resUrl = await BasicApi().debugPost(barcode);
//        Navigator.pushNamed(context, '/showpdf', arguments: resUrl);

      }
    });
  }

  Future<void> _showPdf(String barcode) async {
    var searchParam = SearchParameter(barcode, '', 1, 1);
    List<Medicine> medicines = await BasicApi().postWordSearch(searchParam);
    // TODO エラー処理
//    final resUrl = await BasicApi().postSearch(barcode);
    setState(() {
      Navigator.pushNamed(context, '/showpdf', arguments: medicines[0]);
    });
  }

  @override
  void dispose() {
    print('deb::dispose');
    if (controller != null && controller.value.isStreamingImages) {
      controller.stopImageStream();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('バーコード読み取り')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: CameraView(
//              key: qrKey,
//              onQRViewCreated: _onQRViewCreated,
              cameraController: controller,
              overlay: CameraViewOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.9,
              ),
            ),
            flex: 8,
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
//                  Text('This is the result of scan: $qrText'),
                  _row2(),
                ],
              ),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  Widget _row2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(8),
          child: RaisedButton(
            onPressed: () {
              if (controller != null && controller.value.isStreamingImages) {
                controller.stopImageStream();
              }
              _showPdf('(01)14987080100314');
            },
            child: const Text('test', style: TextStyle(fontSize: 20)),
          ),
        )
      ],
    );
  }
}
