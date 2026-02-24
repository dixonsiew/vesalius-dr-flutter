// ignore_for_file: constant_identifier_names

const NotificationType = {
  'Discharge Summary': 'Discharge Summary Notification',
  'Drug Discontinue': 'Drug Discontinue Verification',
  'Verbal Order': 'Verbal Drug Order Verification'
};

class TodoNotification {

  int notificationId;
  String mcr;
  String notificationType;
  String lastUpdateDate;
  String prn;
  String patientName;
  String accountNo;
  String doctorName;
  String? accessionNo;
  String? itemCode;
  String? itemDesc;
  String? itemQuantity;
  String? uom;
  String? instruction;
  String? orderDate;
  String? orderTime;
  String? orderBy;
  String? dispenseQuantity;
  String? lastDispenseTime;
  String? servedQuantity;
  String? lastServedTime;
  String? discontinueDate;
  String? discontinueTime;
  String? discontinueReason;
  String? discontinueBy;
  String? dischargeSummary;
  bool acknowledgementFlag;

  String notificationTypes = '';

  TodoNotification({
    required this.notificationId,
    required this.mcr,
    required this.notificationType,
    required this.lastUpdateDate,
    required this.prn,
    required this.patientName,
    required this.accountNo,
    required this.doctorName,
    required this.accessionNo,
    required this.itemCode,
    required this.itemDesc,
    required this.itemQuantity,
    required this.uom,
    required this.instruction,
    required this.orderDate,
    required this.orderTime,
    required this.orderBy,
    required this.dispenseQuantity,
    required this.lastDispenseTime,
    required this.servedQuantity,
    required this.lastServedTime,
    required this.discontinueDate,
    required this.discontinueTime,
    required this.discontinueReason,
    required this.discontinueBy,
    required this.dischargeSummary,
    required this.acknowledgementFlag,
  });

  factory TodoNotification.fromJson(Map<String, dynamic> json) {
    return TodoNotification(
      notificationId: json['notification_id'],
      mcr: json['mcr'],
      notificationType: json['notificationType'],
      lastUpdateDate: json['lastUpdateDate'],
      prn: json['prn'],
      patientName: json['patientName'],
      accountNo: json['accountNo'],
      doctorName: json['doctorName'],
      accessionNo: json['accessionNo'],
      itemCode: json['itemCode'],
      itemDesc: json['itemDesc'],
      itemQuantity: json['itemQuantity'],
      uom: json['uom'],
      instruction: json['instruction'],
      orderDate: json['orderDate'],
      orderTime: json['orderTime'],
      orderBy: json['orderBy'],
      dispenseQuantity: json['dispenseQuantity'],
      lastDispenseTime: json['lastDispenseTime'],
      servedQuantity: json['servedQuantity'],
      lastServedTime: json['lastServedTime'],
      discontinueDate: json['discontinueDate'],
      discontinueTime: json['discontinueTime'],
      discontinueReason: json['discontinueReason'],
      discontinueBy: json['discontinueBy'],
      dischargeSummary: json['dischargeSummary'],
      acknowledgementFlag: json['acknowledgementFlag'],
    );
  }

  void setNotificationTypes(List<String> ls) {
    ls.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    notificationTypes = ls.join(' / ');
  }

  static String getNotificationType(String s) {
    if (NotificationType.containsKey(s)) {
      return NotificationType[s]!;
    }

    return s;
  }

  static List<TodoNotification> getUniqueList(List<TodoNotification> lx) {
    Map<String, List<String>> m = {};
    List<TodoNotification> ls = [];
    for (var o in lx) {
      String k = o.patientName.toUpperCase();
      if (m.containsKey(k)) {
        List<String> ld = m[k]!;
        String t = getNotificationType(o.notificationType);
        var j = ld.indexOf(t);
        if (j < 0) {
          ld.add(t);
          m[k] = ld;
        }
        continue;
      }

      m[k] = [getNotificationType(o.notificationType)];
      ls.add(o);
    }

    for (var o in ls) {
      var lp = m[o.patientName.toUpperCase()];
      o.setNotificationTypes(lp!);
    }

    return ls;
  }

  // "notification_id": 14926,
  //   "mcr": "IHP-00001",
  //   "notificationType": "Drug Discontinue",
  //   "lastUpdateDate": "26/05/2020 01:07:37",
  //   "prn": "20-000052",
  //   "patientName": "ABBIE NEOH BOON CHONG",
  //   "accountNo": "AN20-000052",
  //   "doctorName": "Dato Professor Dr NOVA DOCTOR",
  //   "accessionNo": "1290",
  //   "itemCode": "PMPT000235",
  //   "itemDesc": "GLUCOBAY TAB 50MG",
  //   "itemQuantity": "3",
  //   "uom": "TAB",
  //   "instruction": "Take 1 tablet(s) 3 TIMES DAILY",
  //   "orderDate": "23-Apr-2020",
  //   "orderTime": "15:25",
  //   "orderBy": "NOVA.DR",
  //   "dispenseQuantity": null,
  //   "lastDispenseTime": null,
  //   "servedQuantity": null,
  //   "lastServedTime": null,
  //   "discontinueDate": "21-May-2020",
  //   "discontinueTime": "14:56",
  //   "discontinueReason": "Allergy",
  //   "discontinueBy": "NOVA",
  //   "dischargeSummary": null
}