class User {
  int id;
  String name;
  String email;
  dynamic profilePicture;

  User({
    required this.id, 
    required this.name, 
    required this.email, 
    this.profilePicture});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        profilePicture = json['profile_picture'];
}
