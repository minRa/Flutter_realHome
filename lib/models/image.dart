
class ImageFile {

  final String title;
  final String imageUrl;
  final String userId;

  ImageFile({
    this.title,
    this.imageUrl,
    this.userId,
  });

 Map<String, dynamic> toMap () {
   return {
     'userId':userId,
     'title':title,
     'imageUrl': imageUrl,
   };
 }

 static ImageFile fromMap(Map <String, dynamic> map) {
    if(map == null) return null;
    return ImageFile (
      title:map['title'],
      imageUrl: map['imageUrl'],
      userId: map['userId'],
    );
  }
}