class User {
  final String id;
  final String fullName;
  final String email;
  final String profileUrl;
  final String backgroundUrl;
  final String chattingWith;
  final String userRole;
   List<dynamic> chattings;


  User({
    this.id, 
    this.fullName,
     this.email, 
     this.userRole,
     this.profileUrl, 
     this.chattingWith,
     this.backgroundUrl,
     this.chattings,
     });

  User.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        profileUrl = data['profileUrl'],
        backgroundUrl = data['backgroundUrl'],
        chattingWith = data['chattingWith'],
        chattings = data['chattings'],
        userRole = data['userRole'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'userRole': userRole,
      'profileUrl':profileUrl,
      'backgroundUrl':backgroundUrl,
      'chattingWith':chattingWith,
      'chattings':chattings,
    };
  }
}