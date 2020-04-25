class User {
  final String id;
  final String fullName;
  final String email;
  int uploadCount;
  final String userRole;

  User({this.id, this.fullName, this.email, this.userRole, this.uploadCount =0});

  User.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        uploadCount = data['uploadCount'],
        userRole = data['userRole'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'userRole': userRole,
      'uploadCount':uploadCount
    };
  }
}