import 'dart:convert';

List<Users> usersFromJson(String str) => List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String usersToJson(List<Users> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
    String id;
    String username;
    String email;
    String profile_pic;

    Users({
        required this.id,
        required this.username,
        required this.email,
        required this.profile_pic,
    });

    factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"] ?? '',
        username: json["username"] ?? '',
        email: json["email"] ?? '',
        profile_pic: json["profile_pic"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "profile_pic": profile_pic,
    };
}
