import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/medicine.dart';
import '../util/api_parameter.dart';

class ViewPdf extends StatefulWidget {
  ViewPdf({this.medicine});

  final Medicine medicine;

  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  bool isInitialLoaded = false;
  String pdfUrl;

  @override
  void initState() {
    super.initState();
    pdfUrl = createLoadUrl(widget.medicine.url);
  }

  @override
  Widget build(BuildContext context) {
    WebViewController _controller;
    print('PdfScreen build :$pdfUrl');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show PDF'),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                print('PdfScreen refresh url: $pdfUrl');
                _controller.loadUrl(pdfUrl);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            margin: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(Icons.save_alt),
              onPressed: () {
                saveToDb();
              },
            ),
          ),
        ],
      ),
      body: WebView(
        initialUrl: pdfUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _controller = controller;
        },
      ),
//
//      Opacity(
//        opacity: isInitialLoaded ? 1 : 0,
//        child: WebView(
//          initialUrl: pdfUrl,
//          javascriptMode: JavascriptMode.unrestricted,
//          onWebViewCreated: (controller) {
//            _controller = controller;
//          },
//          onPageFinished: (url) {
//            if (!isInitialLoaded) {
//              setState(() => isInitialLoaded = true);
//            }
//          },
//        ),
//      ),
    );
  }

  Future<void> saveToDb() async {
//    final MedicineDatabaseProvider provider = MedicineDatabaseProvider();
//    final a = await provider.insertMedicine(widget.medicine);
//    setState(() {
//      showBasicDialog(context, 'D0003');
//      print('db count: $a');
//    });
  }
}
