import 'dart:convert';

GetUser getUserFromJson(String str) => GetUser.fromJson(json.decode(str));

String getUserToJson(GetUser data) => json.encode(data.toJson());

class GetUser {
  GetUser({
    required this.data,
  });

  Data data;

  factory GetUser.fromJson(Map<String, dynamic> json) => GetUser(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.id,
    required this.username,
    required this.image,
  });

  int id;
  String username;
  String image;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        username: json["username"],
        image: json["image"] == null ? 'noImage' : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "image": image,
      };
}
