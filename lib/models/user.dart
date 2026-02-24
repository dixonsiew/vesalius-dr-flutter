class User {

  int userId;
  String mcr;
  String? email;
  String title;
  String firstName;
  String middleName;
  String? lastName;
  String dob;
  String sex;
  String contactNumber;
  String nationality;
  bool firstTimeLogin;
  String role;
  String branch;
  String machineId;

  User({
    required this.userId,
    required this.mcr,
    this.email,
    required this.title,
    required this.firstName,
    required this.middleName,
    this.lastName,
    required this.dob,
    required this.sex,
    required this.contactNumber,
    required this.nationality,
    required this.firstTimeLogin,
    required this.role,
    required this.branch,
    required this.machineId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['doctor_app_user_id'],
      mcr: json['mcr'],
      title: json['title'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      dob: json['dob'],
      sex: json['sex'],
      contactNumber: json['contact_number'],
      nationality: json['nationality'],
      firstTimeLogin: json['firstTimeLogin'],
      role: json['role'],
      branch: json['branch'],
      machineId: json['machine_id'],
    );
  }
}