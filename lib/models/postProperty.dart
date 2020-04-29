
class PostProperty {
  final String id;
  final String email;
  final String fullName;
  final String documentId;
  final String createdAt;
  final String chattingWith;
   String rentType;
   String date;
   String title;
   String message;
   String phone;
   String price;
   String address;
   String city;
   String messenger;
   double latitude;
   double longitude;
   List<dynamic> imageUrl;
  PostProperty({
    this.id,
    this.email,
    this.rentType,
    this.fullName,
    this.date,
    this.title,
    this.message,
    this.phone,
    this.price,
    this.address,
    this.city,
    this.messenger,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.documentId,
    this.createdAt, 
    this.chattingWith
});

Map<String, dynamic> toMap() {
    return {
      'id' :id,
      'email':email,
      'fullName':fullName,
      'title':title,
       'date':date,
      'message':message,
      'price':price,
      'rentType':rentType,
      'messenger':messenger,
      'city':city,
      'phone':phone,
      'latitude':latitude,
      'longitude':longitude,
      'address':address,
      'images' :imageUrl,
      'createdAt': createdAt,
      'chattingWith': null,
    };
  }

  static PostProperty fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return PostProperty(
      id: map['id'],
      email: map['email'],
      rentType: map['rentType'],
      fullName: map['fullName'],
      date: map['date'],
      imageUrl: map['images'],
      title: map['title'],
      phone: map['phone'],
      address:map['address'],
      city: map['city'],
      message: map['message'],
      messenger: map['messenger'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      price: map['price'],
      createdAt: map['createdAt'],
      chattingWith:map['chattingWith'],
      documentId: documentId,
    );
  }
}