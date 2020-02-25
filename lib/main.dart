import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'debug/debug_camera.dart';
import 'debug/debug_db.dart';
import 'debug/debug_farebase_db.dart';
import 'debug/debug_farebase_fcm.dart';
import 'models/medicine.dart';
import 'models/search_parameter.dart';
import 'util/custom_theme.dart';
import 'util/view_const.dart';
import 'views/barcode_scan.dart';
import 'views/favorite.dart';
import 'views/search_conditional.dart';
import 'views/search_conditional_detail.dart';
import 'views/search_result.dart';
import 'views/select_document.dart';
import 'views/top.dart';
import 'views/update_list.dart';
import 'views/view_pdf.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      home: _MyApp(),
      routes: <String, WidgetBuilder>{
        '/top': (context) => Top(),
        '/qrview': (context) => const BarcodeScan(),
        '/favorite': (context) => Favorite(),
        '/select_document': (context) => SelectDocument(),
        '/update_list': (context) => UpdateList(),
        '/search_conditional': (context) => SearchConditional(),
        '/search_conditional_detail': (context) => SearchConditionalDetail(),
        '/search_result': (context) => SearchResult(
            arguments:
                ModalRoute.of(context).settings.arguments as SearchParameter),
        '/showpdf': (context) => ViewPdf(
            medicine: ModalRoute.of(context).settings.arguments as Medicine),
        // 以降は、debug用。削除予定
        '/debug_camera': (context) => DebugCamera(),
        '/debug_db': (context) => DebugDb(),
        '/debug_fb_db': (context) => DebugFireBaseDb(),
        '/debug_fb_fcm': (context) => DebugFireBaseFcm(),
//        '/license': (BuildContext context) => new LicenseScreen(),
      },
    );
  }
}

class _MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<_MyApp> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 2,
        navigateAfterSeconds: Top(),
        title: Text(
          'Welcome In SplashScreen',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        image: Image.asset('assets/medical_medicine.png'),
        backgroundColor: ViewConst.splashBackgroundColor,
        styleTextUnderTheLoader: const TextStyle(),
        photoSize: 100,
        onClick: () => print('Flutter Egypt'),
        loaderColor: ViewConst.splashLoaderColor);
  }
}
