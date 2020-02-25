import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    Key key,
    @required this.cameraController,
    this.overlay,
  }) : super(key: key);

  final CameraController cameraController;

  final ShapeBorder overlay;

  @override
  State<StatefulWidget> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (widget.cameraController != null &&
                widget.cameraController.value.isInitialized)
            ? CameraPreview(widget.cameraController)
            : Container(),
//        AspectRatio(
//            aspectRatio: widget.cameraController.value.aspectRatio,
//            child: CameraPreview(widget.cameraController)),
        widget.overlay != null
            ? Container(
                decoration: ShapeDecoration(
                  shape: widget.overlay,
                ),
              )
            : Container(),
      ],
    );
  }
}
