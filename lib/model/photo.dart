class Photo {
  int? id;
  String photoName, description, title;

  Photo({this.id, required this.photoName, required this.title, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photoName': photoName,
      'title': title,
      'description': description,
    };
  }

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'],
      photoName: map['photoName'],
      title: map['title'],
      description: map['description']
    );
  }
}
