import 'package:flutter/material.dart';

import 'common_divider.dart';
import 'common_divider2.dart';
import 'common_divider3.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'メニュー',
              style: TextStyle(color: Colors.white),
              //Theme.of(context).primaryTextTheme.title,
            ),
            decoration: BoxDecoration(
//              color: Theme.of(context).primaryColor,
              color: Colors.black87,
            ),
            margin: EdgeInsets.zero,
          ),
          CommonDivider3(),
          Container(
            color: Colors.grey[200],
            child: Column(
              children: <Widget>[
                ListTile(
                  selected: true,
                  leading: Icon(Icons.info_outline, color: Colors.blue),
                  title: Text('お知らせ', style: TextStyle(color: Colors.black)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/favorite');
                  },
                ),
                CommonDivider(),
                ListTile(
                  selected: true,
                  leading: Icon(Icons.favorite, color: Colors.green),
                  title: Text('お気に入り', style: TextStyle(color: Colors.black)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/favorite');
                  },
                ),
                CommonDivider2(),
                ListTile(
                  selected: true,
                  leading: Icon(Icons.settings, color: Colors.red),
                  title: Text('設定', style: TextStyle(color: Colors.black)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/favorite');
                  },
                ),
                CommonDivider(),
                ListTile(
                  selected: true,
                  leading: Icon(Icons.help_outline, color: Colors.cyan),
                  title:
                      Text('このアプリについて', style: TextStyle(color: Colors.black)),
                  onTap: () {
                    Navigator.pop(context);
                    showLicensePage(
                      context: context,
                      applicationName: 'applicationName',
                      applicationVersion: 'versionName',
                      applicationIcon: Image.asset(
                          'assets/medical_medicine.png',
                          scale: 3,
                          height: 100),
                      applicationLegalese: 'applicationLegalese',
                      // useRootNavigator: true,
                    );
                  },
                ),
                CommonDivider2(),
                ListTile(
                  selected: true,
                  leading: Icon(Icons.developer_mode, color: Colors.brown),
                  title:
                      Text('debug_db', style: TextStyle(color: Colors.black)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/debug_db');
                  },
                ),
                CommonDivider(),
                ListTile(
                  selected: true,
                  leading: Icon(Icons.developer_mode, color: Colors.brown),
                  title: Text('debug_firebase_db',
                      style: TextStyle(color: Colors.black)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/debug_fb_db');
                  },
                ),
                CommonDivider(),
                ListTile(
                  selected: true,
                  leading: Icon(Icons.developer_mode, color: Colors.brown),
                  title: Text('debug_firebase_fcm',
                      style: TextStyle(color: Colors.black)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/debug_fb_fcm');
                  },
                ),
                CommonDivider(),
                ListTile(
                  selected: true,
                  leading: Icon(Icons.developer_mode, color: Colors.brown),
                  title: Text('debug_camera',
                      style: TextStyle(color: Colors.black)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/debug_camera');
                  },
                ),
                CommonDivider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
