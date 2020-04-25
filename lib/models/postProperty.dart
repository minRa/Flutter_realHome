
class PostProperty {
  final String id;
  final String email;
  final String fullName;
  final String title;
  final String message;
  final String phone;
  final String price;
  final String address;
  final String city;
  final String messenger;
  final String uuid;
  final String documentId;
  final double latitude;
  final double longitude;
   List<dynamic> imageUrl;
  final String createdAt;
  final String chattingWith;

  PostProperty({
    this.id,
    this.email,
    this.fullName,
    this.title,
    this.message,
    this.phone,
    this.price,
    this.address,
    this.city,
    this.messenger,
    this.uuid,
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
      'message':message,
      'price':price,
      'messenger':messenger,
      'city':city,
      'phone':phone,
      'uuid':uuid,
      'latitude':latitude,
      'longitude':longitude,
      'address':address,
      'images' :imageUrl,
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
      'chattingWith': null,
    };
  }

  static PostProperty fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return PostProperty(
      id: map['id'],
      email: map['email'],
      fullName: map['fullName'],
      imageUrl: map['images'],
      title: map['title'],
      phone: map['phone'],
      address:map['address'],
      city: map['city'],
      message: map['message'],
      messenger: map['messenger'],
      latitude: map['latitude'],
      longitude: map['longtitude'],
      price: map['price'],
      uuid: map['uuid'],
      createdAt: map['createdAt'],
      chattingWith:map['chattingWith'],
      documentId: documentId,
    );
  }
}