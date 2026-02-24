class InpatientQueueDetail {

  int id;
  String patientType;
  String mcr;
  String prn;
  String title;
  String firstName;
  String middleName;
  String lastName;
  String sexCode;
  String sexDesc;
  String age;
  String nationality;
  String vipFlag;
  String visitType;
  String visitNumber;
  String? queueNumber;
  String? queueCriteria;
  String? patientStatus;
  String? registrationDate;
  String? registrationTime;
  String? appointmentDate;
  String? appointmentTime;
  String? vitalAreAvailable;
  String? triageScore;
  String? triageDiscriminator;
  String? hasOnArrivalOrders;
  String? routedBy;
  String ward;
  String bed;
  String admissionDate;
  String admissionTime;
  String lastUpdateDate;

  InpatientQueueDetail({
    required this.id,
    required this.patientType,
    required this.mcr,
    required this.prn,
    required this.title,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.sexCode,
    required this.sexDesc,
    required this.age,
    required this.nationality,
    required this.vipFlag,
    required this.visitType,
    required this.visitNumber,
    required this.queueNumber,
    required this.queueCriteria,
    required this.patientStatus,
    required this.registrationDate,
    required this.registrationTime,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.vitalAreAvailable,
    required this.triageScore,
    required this.triageDiscriminator,
    required this.hasOnArrivalOrders,
    required this.routedBy,
    required this.ward,
    required this.bed,
    required this.admissionDate,
    required this.admissionTime,
    required this.lastUpdateDate,
  });

  factory InpatientQueueDetail.fromJson(Map<String, dynamic> json) {
    return InpatientQueueDetail(
      id: json['id'],
      patientType: json['patientType'],
      mcr: json['mcr'],
      prn: json['prn'],
      title: json['title'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      sexCode: json['sexCode'],
      sexDesc: json['sexDesc'],
      age: json['age'],
      nationality: json['nationality'],
      vipFlag: json['vipFlag'],
      visitType: json['visitType'],
      visitNumber: json['visitNumber'],
      queueNumber: json['queueNumber'],
      queueCriteria: json['queueCriteria'],
      patientStatus: json['patientStatus'],
      registrationDate: json['registrationDate'],
      registrationTime: json['registrationTime'],
      appointmentDate: json['appointmentDate'],
      appointmentTime: json['appointmentTime'],
      vitalAreAvailable: json['vitalAreAvailable'],
      triageScore: json['triageScore'],
      triageDiscriminator: json['triageDiscriminator'],
      hasOnArrivalOrders: json['hasOnArrivalOrders'],
      routedBy: json['routedBy'],
      ward: json['ward'],
      bed: json['bed'],
      admissionDate: json['admissionDate'],
      admissionTime: json['admissionTime'],
      lastUpdateDate: json['lastUpdateDate'],
    );
  }
}