import 'package:flutter/material.dart';

import '../models/medicine.dart';
import '../models/search_parameter.dart';
import '../repository/basic_api.dart';
import '../widget/common_divider.dart';
import '../widget/overlay_loading_molecules.dart';

class SearchResult extends StatefulWidget {
  SearchResult({this.arguments});

  final SearchParameter arguments;

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  // TODO DBからデータ取得
  String count = '読込中';
  List<Medicine> medicineList;

  @override
  void initState() {
    super.initState();

    print('_SearchResultState initState');
    BasicApi().postWordSearch(widget.arguments).then((list) {
      if (!mounted) {
        return;
      }
      setState(() {
        medicineList = list;
        count = '件数：${medicineList.length} 件';
        print('_SearchResultState initState2');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('検索結果'),
      ),
      body: Column(
        children: <Widget>[
          Align(child: _header()),
          CommonDivider(),
          Expanded(child: _docList()),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Card(
            margin: const EdgeInsets.all(8),
            child: Container(
              margin: const EdgeInsets.all(12),
              child: Text('検索ワード：${widget.arguments.medicineWord}',
                  style: const TextStyle(fontSize: 16)),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Card(
            margin: const EdgeInsets.all(8),
            child: Container(
              margin: const EdgeInsets.all(12),
              child: Text('$count', style: const TextStyle(fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _docList() {
    return medicineList == null
        ? _loading()
        : medicineList.isEmpty ? _noData() : _resultList();
  }

  Widget _loading() {
    return OverlayLoadingMolecules(visible: medicineList == null);
  }

  Widget _noData() {
    return Container(
      alignment: Alignment.center,
      child: Text('検索結果0件'),
    );
  }

  Widget _resultList() {
    return ListView.builder(
      itemCount: medicineList.length,
      itemBuilder: (context, index) {
        final item = medicineList[index];
        return Column(
          children: <Widget>[
            ListTile(
              enabled: item.url.isNotEmpty,
              title: Text(item.medicineName),
              subtitle: Text(item.docType),
              onTap: () {
                Navigator.pushNamed(context, '/showpdf', arguments: item);
              },
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
