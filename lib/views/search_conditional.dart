import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../debug/condition1.dart';
import '../models/search_parameter.dart';
import '../widget/dialog.dart';

class SearchConditional extends StatefulWidget {
  @override
  _SearchConditionalState createState() => _SearchConditionalState();
}

class _SearchConditionalState extends State<SearchConditional> {
  String _type = '';

//  String _type1 = '';
//  String _type2 = '';
  bool isCode = true;

  String _gsText = '';
  String _prText = 'カフェイン';

  final _textEditGs1Controller = TextEditingController();
  final _textEditProductController = TextEditingController(text: 'カフェイン');

  void _handleRadio(String e) => setState(() {
        _type = e;
        isCode = !isCode;
      });

  @override
  void initState() {
    super.initState();
    _textEditGs1Controller.addListener(_printLatestValue);
    _textEditProductController.addListener(_printLatestValue);

    setState(() {
      _type = 'thumb_up';
//      _type1 = '0';
//      _type2 = '0';
    });
  }

  @override
  void dispose() {
    _textEditGs1Controller.dispose();
    _textEditProductController.dispose();
    super.dispose();
  }

  void _handleGsText(String e) {
    setState(() {
      _gsText = e;
    });
  }

  void _handlePrText(String e) {
    setState(() {
      _prText = e;
    });
  }

  void _printLatestValue() {
    print('入力状況: ${_textEditGs1Controller.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('条件検索'),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: () {
                //TODO 検索条件の削除
                showBasicDialog(context, 'D0001');
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            margin: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(Icons.save_alt),
              onPressed: () {
                //TODO 検索条件の保存
                showBasicDialog(context, 'D0002');
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile(
                    secondary: Image.asset('assets/barcode.png', scale: 8),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('GS1 codeでの検索'),
                    value: 'thumb_up',
                    groupValue: _type,
                    onChanged: _handleRadio,
                  ),
                  isCode ? cardGs1Code() : Container(),
                  RadioListTile(
                    secondary: Image.asset('assets/medicine1.png', scale: 8),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('医薬品名での検索'),
                    value: 'favorite',
                    groupValue: _type,
                    onChanged: _handleRadio,
                  ),
                  isCode ? Container() : cardName(),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity, // match_parent
                child: RaisedButton(
                  child: const Text('検索',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    var searchParam = SearchParameter(_gsText, _prText, 1, 1);
                    Navigator.pushNamed(context, '/search_conditional_detail',
                        arguments: searchParam);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardGs1Code() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: TextField(
          controller: _textEditGs1Controller,
          maxLength: 16,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: 'GS1 コードを入力ください',
            labelText: 'GS1 Code',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly,
          ],
          onChanged: _handleGsText,
        ),
      ),
    );
  }

  Widget cardName() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: TextField(
              controller: _textEditProductController,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: '医薬品名を入力ください',
                labelText: '医薬品名',
              ),
              onChanged: _handlePrText,
            ),
          ),
          DebugCondition(),
        ],
      ),
    );
  }
}
