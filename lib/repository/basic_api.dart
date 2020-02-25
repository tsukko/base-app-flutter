import 'package:http/http.dart' as http;

import '../models/medicine.dart';
import '../models/search_parameter.dart';
import '../util/api_parameter.dart';

class BasicApi {
  Future<String> postSearch(String codeId) async {
    final url = baseUrl + searchDir;
    final client = http.Client();

    if (codeId == '') {
//      codeId = '(01)14987080100314';
      print('error code is empty.');
      return null;
    }

    final bodyParam = getBodyGs1code(codeId);
    final hdr = getHeader();

    final response = await client.post(url, body: bodyParam, headers: hdr);

    if (response.statusCode == 200) {
      final resBody = response.body.toString();
      //TODO さまざまなパラメータをパースする
//      Iterable<Match> matches =
//          new RegExp('<a target=\'_blank\' href=.*?</a>').allMatches(resBody);
//      <a target='_blank' href='/PmdaSearch/iyakuDetail/GeneralList/1124023'>アルプラゾラム</a>
//      <a target='_blank' href='/PmdaSearch/iyakuDetail/ResultDataSetPDF/780075_1124023F1118_1_04'>PDF(2019年07月22日)</a>
      final Iterable<Match> matches =
          RegExp('/PmdaSearch/iyakuDetail/ResultDataSetPDF/.*?>')
              .allMatches(resBody);

      var pdfUrl = baseUrl;
      for (final m in matches) {
        pdfUrl = baseUrl + m.group(0).replaceAll("'>", '');
      }

      return pdfUrl;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return '';
    }
  }

  Future<List<Medicine>> postWordSearch(SearchParameter param) async {
    final url = baseUrl + searchDir;
    final client = http.Client();
    Map<String, String> bodyParam;
    var code = param.gs1code;
    if (code.isNotEmpty) {
      bodyParam = getBodyGs1code(code);
    } else {
      bodyParam = getBodyMedicine(param);
    }
    final hdr = getHeader();

    final response = await client.post(url, body: bodyParam, headers: hdr);

    if (response.statusCode == 200) {
      final resBody = response.body.toString();

      return parse(resBody);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  // パース処理
  List<Medicine> parse(String resBody) {
    final List<Match> matches =
        RegExp('<td><div>.*?</div></td>').allMatches(resBody).toList();
    List<Medicine> medicineList = [];

    for (int i = 0; i < matches.length; i++) {
//      print("SearchMedicineResult parse :${matches[i].group(0)}");
      if (matches[i].group(0).contains('/PmdaSearch/iyakuDetail/GeneralList')) {
        String medicineName = matches[i + 1]
            .group(0)
            .replaceAll('<td><div>', '')
            .replaceAll('</div></td>', '');
        // urlは1件のみある
        List<Match> matchesUrl =
            RegExp('/PmdaSearch/iyakuDetail/ResultDataSetPDF/.*?>')
                .allMatches(matches[i + 3].group(0))
                .toList();
        String url = '';
        if (matchesUrl.isNotEmpty) {
          url = baseUrl + matchesUrl.first.group(0).replaceAll("'>", '');
        }

        print("medicineName:$medicineName, url:$url");
        medicineList.add(Medicine('', medicineName, '添付文書', url, false));
      }
    }
    return medicineList;
  }
}
