class Review {
  
  int id;
  String accountNo;
  String prn;
  String patientName;
  String accessionNo;
  String investigationType;
  String serviceCode;
  String serviceDesc;
  String orderDoctorMcr;
  String orderDate;
  String resultDate;
  String reportType;
  String? result;
  String remark;
  String lastUpdateDate;
  bool reviewInvestigationFlag;

  Map<String, List<String>>? investigationTypes;

  Review({
    required this.id,
    required this.accountNo,
    required this.prn,
    required this.patientName,
    required this.accessionNo,
    required this.investigationType,
    required this.serviceCode,
    required this.serviceDesc,
    required this.orderDoctorMcr,
    required this.orderDate,
    required this.resultDate,
    required this.reportType,
    required this.result,
    required this.remark,
    required this.lastUpdateDate,
    required this.reviewInvestigationFlag,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      accountNo: json['accountNo'],
      prn: json['prn'],
      patientName: json['patientName'],
      accessionNo: json['accessionNo'],
      investigationType: json['investigationType'],
      serviceCode: json['serviceCode'],
      serviceDesc: json['serviceDesc'],
      orderDoctorMcr: json['orderDoctorMcr'],
      orderDate: json['orderDate'],
      resultDate: json['resultDate'],
      reportType: json['reportType'],
      result: json['result'],
      remark: json['remark'],
      lastUpdateDate: json['lastUpdateDate'],
      reviewInvestigationFlag: json['reviewInvestigationFlag'],
    );
  }

  void setInvestigationTypes(Map<String, List<String>> m) {
    investigationTypes = m;
  }

  static List<Review> getUniqueList(List<Review> lx) {
    Map<String, Map<String, List<String>>> m = {};
    List<Review> ls = [];
    for (var o in lx) {
      String k = o.patientName.toUpperCase();
      String ki = o.investigationType.toUpperCase();
      if (m.containsKey(k)) {
        Map<String, List<String>> mi = m[k]!;
        if (mi.containsKey(ki)) {
          List<String> li = mi[ki]!;
          li.add(o.serviceDesc);
          mi[ki] = li;
          m[k] = mi;
          continue;
        }

        mi[ki] = [o.serviceDesc];
        m[k] = mi;
        continue;
      }

      m[k] = {};
      m[k]![ki] = [o.serviceDesc];
      ls.add(o);
    }

    for (var o in ls) {
      var mi = m[o.patientName.toUpperCase()];
      o.setInvestigationTypes(mi!);
    }

    return ls;
  }

  // "id": 1393,
  //   "accountNo": "OP20-000592",
  //   "prn": "20-000058",
  //   "patientName": "Dato Professor Dr Hamilton Kourtney Kardashian Mobile Doctor",
  //   "accessionNo": "2272",
  //   "investigationType": "LABS",
  //   "serviceCode": "CAST",
  //   "serviceDesc": "CASTS",
  //   "orderDoctorMcr": "IHP-00001",
  //   "orderDate": "03-Jul-2020",
  //   "resultDate": "03-Jul-2020",
  //   "reportType": "MANUAL",
  //   "result": "334.00",
  //   "remark": "",
  //   "lastUpdateDate": "05/07/2020 12:58 AM",
  //   "reviewInvestigationFlag": false
}