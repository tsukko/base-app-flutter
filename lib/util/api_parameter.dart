import 'dart:io';

import '../models/search_parameter.dart';

//    var scheme = "https://";
//    var host = "www";
//    var domain = "pmda.go.jp";
const baseUrl = 'https://www.pmda.go.jp';
const searchDir = '/PmdaSearch/iyakuSearch/';

Map<String, String> baseBody = {
  // 必須パラメータ
  'ListRows': '10',
  'dispColumnsList[0]': '1',
  'updateDocFrDt': '',
  'updateDocToDt': '',
  'howtoRdSearchSel': 'or',
  'relationDoc1Word': '',
  'relationDoc1FrDt': '',
  'relationDoc1ToDt': '',
  'relationDoc2Word': '',
  'relationDoc2FrDt': '',
  'relationDoc2ToDt': '',
  'relationDoc3Word': '',
  'relationDoc3FrDt': '',
  'relationDoc3ToDt': '',
  'btnA.x': '0',
  'btnA.y': '',

  // gs1code検索用
  'gs1code': '',
  // 医薬品名検索用
//      'nameWord': 'カフェイン',
//      'iyakuHowtoNameSearchRadioValue': '1',
//      'howtoMatchRadioValue': '1',

  // 任意パラメータ
  'dispColumnsList[1]': '2',
  'dispColumnsList[2]': '3',
  'dispColumnsList[3]': '23',
  'dispColumnsList[4]': '4',
  'dispColumnsList[5]': '11',
  'dispColumnsList[6]': '5',
  'dispColumnsList[7]': '10',
  'dispColumnsList[8]': '13',
  'dispColumnsList[9]': '15',
  'dispColumnsList[10]': '17',
  'dispColumnsList[11]': '8',
  'dispColumnsList[12]': '18',
  'dispColumnsList[13]': '19',
  'dispColumnsList[14]': '22',
  'dispColumnsList[15]': '9',
};

const Map<String, String> hdr = {
  'Accept':
      'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
  'Accept-Encoding': 'gzip, deflate, br',
  'Accept-Language': 'ja,en-US;q=0.9,en;q=0.8',
  'Connection': 'keep-alive',
  'Content-Type': 'application/x-www-form-urlencoded',
  'Host': 'www.pmda.go.jp',
};

String addBaseUrl(String pathUrl) {
  return baseUrl + pathUrl;
}

String createLoadUrl(String url) {
  if (Platform.isAndroid) {
    return 'https://docs.google.com/gview?embedded=true&url=$url';
  } else {
    return url;
  }
}

Map<String, String> getBodyGs1code(String code) {
  baseBody.update('gs1code', (v) => code);
  return baseBody;
}

Map<String, String> getBodyMedicine(SearchParameter param) {
  baseBody.addAll({
    'nameWord': param.medicineWord,
    'iyakuHowtoNameSearchRadioValue': param.searchCondition1.toString(),
    'howtoMatchRadioValue': param.searchCondition2.toString(),
  });
  return baseBody;
}

Map<String, String> getHeader() {
  return hdr;
}
