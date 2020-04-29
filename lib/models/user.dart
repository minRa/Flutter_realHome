class User {
  final String id;
  final String fullName;
  final String email;
  final String profileUrl;
  final int uploadCount;
  final String userRole;

  User({this.id, this.fullName, this.email, this.userRole,this.profileUrl, this.uploadCount});

  User.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        uploadCount = 1, //data['uploadCount'],
        profileUrl = data['profileUrl'],
        userRole = data['userRole'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'userRole': userRole,
      'profileUrl':profileUrl,
      'uploadCount':uploadCount
    };
  }
}