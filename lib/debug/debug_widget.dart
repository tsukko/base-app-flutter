import 'package:flutter/material.dart';

// 開発デバッグ用のWidget置き場
// ペンディングの箇所を表現するWidget
Widget pendingWidget(String message, double pendingHeight) {
  return SizedBox(
    height: pendingHeight,
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        const Placeholder(),
        Text(message, style: const TextStyle(fontSize: 24)),
      ],
    ),
  );
}

// デバッグ用カメラを起動するボタン
// 各ネイティブ側のカメラビューを起動させる
Widget debugCamera(BuildContext context) {
  return RaisedButton(
    child: const Text('debug camera'),
    color: Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    onPressed: () {
      Navigator.pushNamed(context, '/debug_camera');
    },
  );
}
