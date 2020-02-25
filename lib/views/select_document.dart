import 'package:flutter/material.dart';

import '../debug/debug_data.dart';
import '../widget/common_divider.dart';

class SelectDocument extends StatefulWidget {
  @override
  _SelectDocumentState createState() => _SelectDocumentState();
}

class _SelectDocumentState extends State<SelectDocument> {
  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context).settings.arguments as int;
    final item = sampleData[index];

    return Scaffold(
      appBar: AppBar(
        title: const Text('文書選択'),
      ),
      body: Column(
        children: <Widget>[
          Align(
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Text('医薬品名：${item.medicineName}',
                    style: const TextStyle(fontSize: 18)),
              ),
            ),
          ),
          CommonDivider(),
          Expanded(
            child: list(),
          )
        ],
      ),
    );
  }

  Widget list() {
    return ListView.builder(
      itemCount: docData.length,
      itemBuilder: (context, index) {
        final item = docData[index];
        return ListTile(
          leading: const Icon(Icons.star),
          title: Text(item),
//          subtitle: Text(item),
          onTap: () {
//            Navigator.pushNamed(context, '/showpdf');
          },
        );
      },
    );
  }
}
