import 'package:flutter/material.dart';

class DebugDb extends StatefulWidget {
  @override
  _DebugDbState createState() => _DebugDbState();
}

class _DebugDbState extends State<DebugDb> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
//  String qrText = '';
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("debug_db2"),
//      ),
//      body: Column(
//        children: <Widget>[
//          Text('data: $qrText'),
//          RaisedButton(
//            child: Text("instert",
//                style: TextStyle(fontSize: 18, color: Colors.white)),
//            color: Colors.blue,
//            onPressed: () async {
//              final res = await addMedicine();
//
//              setState(() {
//                print("res: $res");
//                qrText = res.toString();
//              });
//            },
//          ),
//          RaisedButton(
//            child: Text("get all ",
//                style: TextStyle(fontSize: 18, color: Colors.white)),
//            color: Colors.blue,
//            onPressed: () async {
//              List<Medicine> aaa =
//                  await MedicineDatabaseProvider().getMedicineAll();
//              setState(() {
//                print("getMedicineAll: $aaa");
//                qrText = aaa[0].medicineName + aaa[1].medicineName;
//              });
//            },
//          ),
//          RaisedButton(
//            child: Text("get 1",
//                style: TextStyle(fontSize: 18, color: Colors.white)),
//            color: Colors.blue,
//            onPressed: () async {
//              Medicine data = await MedicineDatabaseProvider().getMedicine(1);
//              setState(() {
//                qrText = data.medicineName;
//              });
//            },
//          ),
//          RaisedButton(
//            child: Text("delete",
//                style: TextStyle(fontSize: 18, color: Colors.white)),
//            color: Colors.blue,
//            onPressed: () {},
//          ),
//        ],
//      ),
//    );
//  }
//
//  Future<int> addMedicine() async {
//    // debuggg
//    await initializeDateFormatting('ja_JP');
//    final formatter = DateFormat('yyyy/MM/dd(E) HH:mm', 'ja_JP');
//    int timestamp = DateTime.now().millisecondsSinceEpoch;
//    DateTime dateTimeNow = DateTime.fromMillisecondsSinceEpoch(timestamp);
//    var formattedNow = formatter.format(dateTimeNow);
//    String updateDate = formattedNow;
//
//    Medicine dummyData = Medicine(
//        '(01)1498708010031',
//        'テスト $updateDate',
//        '添付文書',
//        '/PmdaSearch/iyakuDetail/ResultDataSetPDF/780075_1124023F1118_1_04',
//        true);
//    final MedicineDatabaseProvider provider = MedicineDatabaseProvider();
//    return await provider.insertMedicine(dummyData);
//  }
}
