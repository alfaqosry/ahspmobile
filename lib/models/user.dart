class User {
  String name;
  String username;
  String email;
  int id;
  // String avatar;

  User(
      {required this.id,
      required this.name,
      required this.username,
      required this.email});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['nama'],
        username = json['username'],
        email = json['email'];
}
