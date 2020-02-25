import 'package:flutter/material.dart';

class SearchConditional extends StatefulWidget {
  @override
  _SearchConditionalState createState() => _SearchConditionalState();
}

class PlaceItem {
  PlaceItem(this.isExpanded, this.name, this.image);

  bool isExpanded;
  String name;
  String image;
}

ExpansionPanel _createPanel(PlaceItem place) {
  return ExpansionPanel(
    headerBuilder: (context, isExpanded) {
      return Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.image),
            ),
            Text(
              place.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      );
    },
    body: Text(
      place.name,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    isExpanded: place.isExpanded,
  );
}

class _SearchConditionalState extends State<SearchConditional> {
  final _placeList = List<PlaceItem>();

  @override
  void initState() {
    _placeList
      ..add(
        PlaceItem(false, 'Huntington Beach', 'barcode.jpg'),
      )
      ..add(
        PlaceItem(false, 'The Hat', 'the-hat.jpg'),
      )
      ..add(
        PlaceItem(false, 'Shake Shack', 'shake-shack.jpg'),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('California'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            ExpansionPanelList(
              expansionCallback: (index, isExpanded) {
                setState(() {
                  _placeList[index].isExpanded = !_placeList[index].isExpanded;
                });
              },
              children: _placeList.map(_createPanel).toList(),
            )
          ],
        ),
      ),
    );
  }
}
