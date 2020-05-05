class User {
  final String id;
  final String fullName;
  final String email;
  final String profileUrl;
  final String backgroundUrl;
  final int uploadCount;
  final String userRole;

  User({
    this.id, 
    this.fullName,
     this.email, 
     this.userRole,
     this.profileUrl, 
     this.uploadCount,
     this.backgroundUrl
     });

  User.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        uploadCount = 1, //data['uploadCount'],
        profileUrl = data['profileUrl'],
        backgroundUrl = data['backgroundUrl'],
        userRole = data['userRole'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'userRole': userRole,
      'profileUrl':profileUrl,
      'backgroundUrl':backgroundUrl,
      'uploadCount':uploadCount
    };
  }
}