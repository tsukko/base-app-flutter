import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//
// 全面表示のローディング
//
class OverlayLoadingMolecules extends StatelessWidget {
  OverlayLoadingMolecules({@required this.visible});

  //表示状態
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return visible
        ? Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
              ],
            ),
          )
        : Container();
  }
}
