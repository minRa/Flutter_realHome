
class PostProperty {
  final String id;
  final String email;
  final String fullName;
  final String documentId;
  final String createdAt;
  final String chattingWith;
   String update;
   int room;
   int carpark;
   int toilet;
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
    this.room,
    this.carpark,
    this.toilet,
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
    this.update,
    this.chattingWith
});

Map<String, dynamic> toMap() {
    return {
      'id' :id,
      'email':email,
      'fullName':fullName,
      'title':title,
      'date':date,
      'room':room,
      'carpark':carpark,
      'toilet':toilet,
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
      'update' : update,
      'createdAt': createdAt,
      'chattingWith': null,
      //'documentId' :documentId
    };
  }

  static PostProperty fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return PostProperty(
      id: map['id'],
      email: map['email'],
      rentType: map['rentType'],
      fullName: map['fullName'],
      room:map['room'],
      carpark: map['carpark'],
      toilet: map['toilet'],
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
      update: map['update'],
      chattingWith:map['chattingWith'],
      documentId: documentId,
    );
  }
}