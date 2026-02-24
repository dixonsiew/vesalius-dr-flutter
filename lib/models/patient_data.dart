import 'package:collection/collection.dart';

class Address {

  String address1;
  String address2;
  String address3;
  String cityState;
  String postalCode;

  Address({
    required this.address1,
    required this.address2,
    required this.address3,
    required this.cityState,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address1: json['address1'],
      address2: json['address2'],
      address3: json['address3'],
      cityState: json['cityState'],
      postalCode: json['postalCode'],
    );
  }
}

class ContactNumber {

  String home;
  String email;

  ContactNumber({
    required this.home,
    required this.email,
  });

  factory ContactNumber.fromJson(Map<String, dynamic> json) {
    return ContactNumber(
      home: json['home'],
      email: json['email'],
    );
  }
}

class Name {

  String firstName;
  String lastName;
  String middleName;
  String title;

  Name({
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.title,
  });

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      firstName: json['firstName'],
      lastName: json['lastName'],
      middleName: json['middleName'],
      title: json['title'],
    );
  }
}

class Document {

  String? code;
  String? description;
  String? value;
  String? expiryDate;

  Document({
    required this.code,
    required this.description,
    required this.value,
    required this.expiryDate,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      code: json['code'],
      description: json['description'],
      value: json['value'],
      expiryDate: json['expiryDate'],
    );
  }
}

class PatientData {

  ContactNumber contactNumber;
  String dob;
  Address homeAddress;
  Name name;
  String nationalityCode;
  String nationalityDescription;
  String prn;
  String resident;
  String sexCode;
  String sexDesc;
  List<Document> documents;

  PatientData({
    required this.contactNumber,
    required this.dob,
    required this.homeAddress,
    required this.name,
    required this.nationalityCode,
    required this.nationalityDescription,
    required this.prn,
    required this.resident,
    required this.sexCode,
    required this.sexDesc,
    required this.documents,
  });

  factory PatientData.fromJson(Map<String, dynamic> json)  {
    var ls = json['documents'] as List;
    List<Document> lx = ls.map<Document>((x) => Document.fromJson(x)).toList();

    return PatientData(
      contactNumber: ContactNumber.fromJson(json['contactNumber']),
      dob: json['dob'],
      homeAddress: Address.fromJson(json['homeAddress']),
      name: Name.fromJson(json['name']),
      nationalityCode: json['nationality']['code'],
      nationalityDescription: json['nationality']['description'],
      prn: json['prn'],
      resident: json['resident'],
      sexCode: json['sex']['code'],
      sexDesc: json['sex']['description'],
      documents: lx,
    );
  }

  String get documentNo {
    String? s = '';
    if (documents.isNotEmpty) {
      var o = documents.firstWhereOrNull((x) => x.code == 'ID');
      s = o == null ? '' : o.value;
    }

    return s ?? '';
  }
}

class PatientInfo {

  String prn;
  Name name;
  String sexCode;
  String sexDesc;

  PatientInfo({
    required this.prn,
    required this.name,
    required this.sexCode,
    required this.sexDesc,
  });
}