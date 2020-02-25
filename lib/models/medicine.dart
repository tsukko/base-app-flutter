// 検索した医薬品の情報
class Medicine {
  Medicine(
      this.gs1code, this.medicineName, this.docType, this.url, this.favorite);

  final String gs1code;
  final String medicineName;
  final String docType;
  final String url;
  bool favorite;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gs1code': gs1code,
      'medicineName': medicineName,
      'docType': docType,
      'url': url,
      'favorite': favorite ? 1 : 0,
    };
  }
}
