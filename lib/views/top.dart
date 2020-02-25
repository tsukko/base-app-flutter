import 'package:flutter/material.dart';

import '../debug/debug_widget.dart';
import '../util/shared_preferences_util.dart';
import '../widget/menu.dart';

class Top extends StatefulWidget {
  @override
  _TopState createState() => _TopState();
}

class _TopState extends State<Top> {
  String nowStr;
  String loadStr;

  Future<void> _readData() async {
    loadStr = await SharedPreferencesUtil().lastDate();
    nowStr = await SharedPreferencesUtil().updateDate();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Screen'),
      ),
      drawer: Menu().build(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _header(),
          Column(
            children: <Widget>[
              _mainBody(),
              _mainDummyBody(),
            ],
          ),
          _footer(),
        ],
      ),
    );
  }

  Widget _header() {
    return Align(
      alignment: Alignment.topRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _nowDate(),
          _lastDate(),
        ],
      ),
      //pendingWidget('top area.', 120.0),
    );
  }

  Widget _nowDate() {
    return Container(
      child: Text('アクセス日時：$nowStr', style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _lastDate() {
    return Container(
//      margin: EdgeInsets.all(2.0),
      child: Text('最終更新日時：$loadStr', style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _footer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: pendingWidget('footer.', 42),
    );
  }

  Widget _mainBody() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: _scan(),
          ),
          Expanded(
            flex: 1,
            child: _search(),
          ),
        ],
      ),
    );
  }

  Widget _scan() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/qrview');
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(8),
              child: Icon(
                Icons.photo_camera,
                size: 42,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: const Text('バーコードを読み取り添付文書を検索する',
                  style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _search() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/search_conditional');
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(8),
              child: Icon(
                Icons.find_in_page,
                size: 42,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: const Text('検索パラメータを設定して文書を検索する',
                  style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainDummyBody() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: _dummyCard(),
          ),
          Expanded(
            flex: 1,
            child: _dummyCard(),
          ),
        ],
      ),
    );
  }

  Widget _dummyCard() {
    return InkWell(
//      onTap: () {
//        Navigator.pushNamed(context, '/search_conditional');
//      },
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(8),
              child: Icon(
                Icons.device_unknown,
                size: 42,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: const Text('ダミー', style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}
