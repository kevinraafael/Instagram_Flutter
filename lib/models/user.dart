class User {
  final String email;
  final String uuid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  //Construtor
  const User({
    required this.email,
    required this.uuid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });
  //Esse método converte todos nossos atributos em um objeto
  Map<String, dynamic> toJson() => {
        "username": username,
        "uuid": uuid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
      };
}
