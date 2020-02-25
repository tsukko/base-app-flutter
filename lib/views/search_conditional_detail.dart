import 'package:flutter/material.dart';

class SearchConditionalDetail extends StatefulWidget {
  @override
  _SearchConditionalDetailState createState() =>
      _SearchConditionalDetailState();
}

class _SearchConditionalDetailState extends State<SearchConditionalDetail> {
//  String _type1 = '';
//  String _type2 = '';
  bool isCode = true;

//  bool _flag = false;
  List<bool> typesFlag = List<bool>.generate(16, (i) => false);

  void _handleCheckbox(bool e, int typeIndex) {
    setState(() {
//      _flag = e;
      typesFlag[typeIndex] = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('文書選択'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        child: RaisedButton(
                          child: Text('全チェック',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                          color: Colors.blue,
                          onPressed: () {
//                            for (final m in typesFlag) {
//                            }
                            for (var i = 0; i < typesFlag.length; i++) {
                              _handleCheckbox(true, i);
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        child: RaisedButton(
                          child: Text('全クリア',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                          color: Colors.blue,
                          onPressed: () {
                            for (var i = 0; i < typesFlag.length; i++) {
                              _handleCheckbox(false, i);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  CheckboxListTile(
                    title: const Text('添付文書'),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: typesFlag[0],
                    onChanged: (value) => _handleCheckbox(value, 0),
                  ),
                  CheckboxListTile(
                    title: const Text('患者向医薬品ガイド／ワクチン接種を受ける人へのガイド'),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: typesFlag[1],
                    onChanged: (value) => _handleCheckbox(value, 1),
                  ),
                  CheckboxListTile(
                    title: const Text('患者向医薬品ガイド／ワクチン接種を受ける人へのガイド'),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: typesFlag[2],
                    onChanged: (value) => _handleCheckbox(value, 2),
                  ),
                  CheckboxListTile(
                    title: const Text('インタビューフォーム'),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: typesFlag[3],
                    onChanged: (value) => _handleCheckbox(value, 3),
                  ),
                  CheckboxListTile(
                    title: const Text('医薬品リスク管理計画（RMP）'),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: typesFlag[4],
                    onChanged: (value) => _handleCheckbox(value, 4),
                  ),
                  CheckboxListTile(
                    title: const Text('改訂指示反映履歴および根拠症例'),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: typesFlag[5],
                    onChanged: (value) => _handleCheckbox(value, 5),
                  ),
                  CheckboxListTile(
                    title: const Text('審査報告書／再審査報告書／最適使用推進ガイドライン等'),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: typesFlag[6],
                    onChanged: (value) => _handleCheckbox(value, 6),
                  ),
                  CheckboxListTile(
                    title: const Text('くすりのしおり'),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: typesFlag[7],
                    onChanged: (value) => _handleCheckbox(value, 7),
                  ),
                  CheckboxListTile(
                    title: const Text('緊急安全性情報／安全性速報'),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: typesFlag[8],
                    onChanged: (value) => _handleCheckbox(value, 8),
                  ),
                  CheckboxListTile(
                    title: const Text('医薬品の適正使用等に関するお知らせ'),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: typesFlag[9],
                    onChanged: (value) => _handleCheckbox(value, 9),
                  ),
                  CheckboxListTile(
                    title: const Text('厚生労働省発表資料（医薬品関連）'),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: typesFlag[10],
                    onChanged: (value) => _handleCheckbox(value, 10),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity, // match_parent
                child: RaisedButton(
                  child: Text('検索',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  color: Colors.blue,
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(10.0),
//                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/search_result',
                        arguments: ModalRoute.of(context).settings.arguments);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
