import 'package:flutter/material.dart';

import '../debug/debug_data.dart';
import '../util/api_parameter.dart';

class UpdateList extends StatefulWidget {
  @override
  _UpdateListState createState() => _UpdateListState();
}

class _UpdateListState extends State<UpdateList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('更新一覧'),
      ),
      body: ListView.builder(
        itemCount: sampleData.length,
        itemBuilder: (context, index) {
          final item = sampleData[index];
          return Dismissible(
            // Each Dismissible must contain a Key. Keys allow Flutter to
            // uniquely identify widgets.
            key: Key(item.gs1code),
            // Provide a function that tells the app
            // what to do after an item has been swiped away.
            onDismissed: (direction) {
              // Remove the item from the data source.
              setState(() {
                sampleData.removeAt(index);
              });

              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('$item dismissed')));
            },
            // Show a red background as the item is swiped away.
            background: Container(color: Colors.red),
            child: ListTile(
              leading: const Icon(Icons.attach_file),
              title: Text(sampleData[index].medicineName),
              subtitle: Text(sampleData[index].gs1code),
              onTap: () {
                Navigator.pushNamed(context, '/showpdf',
                    arguments: addBaseUrl(sampleData[index].url));
              },
            ),
          );
        },
      ),
    );
  }
}
