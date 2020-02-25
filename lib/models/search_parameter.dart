// 検索結果

class SearchParameter {
  SearchParameter(this.gs1code, this.medicineWord, this.searchCondition1,
      this.searchCondition2);

  final String gs1code;
  final String medicineWord;
  final int searchCondition1;
  final int searchCondition2;
}
