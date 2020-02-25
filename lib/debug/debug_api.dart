import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../debug/debug_data.dart';
import '../repository/basic_api.dart';
import '../util/api_parameter.dart';

class DebugApi {
  Future<String> debugPost(String codeId) async {
    print('debugPost: codeId: $codeId');
    return BasicApi().postSearch(getRandomGs1Code());
  }

  // test用メソッド　ここから
  Future<String> postMultiple(String codeId) async {
    final url = baseUrl + searchDir;

    final client = http.Client();

    if (codeId == '') {
      codeId = '(01)14987080100314';
    }

    final bodyParam = getBodyGs1code(codeId);
    final hdr = getHeader();
    final DateTime timeStartReq = DateTime.now();
    print('deb1 : $timeStartReq');
    final List<http.Response> responses = await Future.wait([
      client.post(url, body: bodyParam, headers: hdr),
      client.post(url, body: bodyParam, headers: hdr),
      client.post(url, body: bodyParam, headers: hdr),
      client.post(url, body: bodyParam, headers: hdr),
      client.post(url, body: bodyParam, headers: hdr), //5
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr), //10
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr), //15
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr), //20
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr), //25
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr), //30
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr), //35
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr), //40
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr), //45
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr),
//      client.post(url, body: bodyParam, headers: hdr), //50
    ]);
    final DateTime timeSecondRes = DateTime.now();
    print('deb2: $timeSecondRes');

    final response = responses[0];

    if (response.statusCode == 200) {
      final resBody = response.body.toString();
      Iterable<Match> matches =
          RegExp('/PmdaSearch/iyakuDetail/ResultDataSetPDF/.*?>')
              .allMatches(resBody);

      var pdfUrl = baseUrl;
      for (Match m in matches) {
        pdfUrl = baseUrl + m.group(0).replaceAll("'>", "");
//        print("pdf url : $pdfUrl");
      }
      final DateTime timeEndRes = DateTime.now();
      final int sinceEpochStartReq = timeStartReq.millisecondsSinceEpoch;
      final int sinceEpochSecondRes = timeSecondRes.millisecondsSinceEpoch;
      final int sinceEpochEndRes = timeEndRes.millisecondsSinceEpoch;
      final int apiTime = sinceEpochSecondRes - sinceEpochStartReq;
      final int totalTime = sinceEpochEndRes - sinceEpochStartReq;

      print('time log, api: $apiTime (ms), total: $totalTime (ms).');
      return pdfUrl;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return "";
    }
  }

  // 旧サイトに接続
  Future<void> testHttpGet() async {
    var url =
        'https://www.info.pmda.go.jp/psearch/PackinsSearch?dragname=ソラナックス';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print('Number of books about http: ${response.body.toString()}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<Uint8List> getPdf(String pdfUrl) async {
    var hdr = {
      "Accept":
          "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "ja,en-US;q=0.9,en;q=0.8",
      "Connection": "keep-alive",
      "Content-Type": "application/x-www-form-urlencoded",
      "Host": "www.pmda.go.jp",
    };
    var response = await http.get(pdfUrl, headers: hdr);
    if (response.statusCode == 200) {
//      print('Number of books about http: ${response.body.toString()}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return response.bodyBytes;
  }
// test用メソッド　ここまで
}
