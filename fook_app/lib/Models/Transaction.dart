import 'dart:convert';

Transaction transactionFromJson(String str) =>
    Transaction.fromJson(json.decode(str));

String transactionToJson(Transaction data) => json.encode(data.toJson());

class Transaction {
  Transaction({
    required this.data,
  });

  List<Datum> data;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.transactionHash,
    required this.transactionType,
    required this.tokenId,
    required this.contract,
    required this.fromWallet,
    required this.toWallet,
    required this.token,
    required this.collection,
    required this.fromUser,
    required this.toUser,
    required this.price,
  });

  String transactionHash;
  String transactionType;
  String tokenId;
  String contract;
  String fromWallet;
  String toWallet;
  Token token;
  Collection collection;
  User fromUser;
  User toUser;
  Price price;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        transactionHash: json["transactionHash"],
        transactionType: json["transactionType"],
        tokenId: json["tokenId"],
        contract: json["contract"],
        fromWallet: json["fromWallet"],
        toWallet: json["toWallet"],
        token: Token.fromJson(json["token"]),
        collection: Collection.fromJson(json["collection"]),
        fromUser: User.fromJson(json["fromUser"]),
        toUser: User.fromJson(json["toUser"]),
        price: Price.fromJson(json["price"]),
      );

  Map<String, dynamic> toJson() => {
        "transactionHash": transactionHash,
        "transactionType": transactionType,
        "tokenId": tokenId,
        "contract": contract,
        "fromWallet": fromWallet,
        "toWallet": toWallet,
        "token": token.toJson(),
        "collection": collection.toJson(),
        "fromUser": fromUser.toJson(),
        "toUser": toUser.toJson(),
        "price": price.toJson(),
      };
}

class Collection {
  Collection({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.contract,
  });

  int id;
  String name;
  String symbol;
  String image;
  String contract;

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        id: json["id"],
        name: json["name"],
        symbol: json["symbol"],
        image: json["image"] ,
        contract: json["contract"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "symbol": symbol,
        "image": image,
        "contract": contract,
      };
}

class User {
  User({
    required this.id,
    required this.username,
    //required this.image,
  });

  int id;
  String username;
  //String image;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        //image: json["image"] == null ? 'lib/Assets/grid/image (6).png' : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
       // "image": image ,
      };
}

class Price {
  Price({
    required this.value,
    required this.unit,
  });

  String value;
  String unit;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        value: json["value"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "unit": unit,
      };
}

class Token {
  Token({
    required this.id,
    required this.file,
    required this.name,
    required this.thumbnail,
    required this.description,
    required this.price,
    required this.collection,
    required this.currentUserData,
  });

  String id;
  String file;
  String name;
  String thumbnail;
  String description;
  Price price;
  Collection collection;
  CurrentUserData currentUserData;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        id: json["id"],
        file: json["file"],
        name: json["name"],
        thumbnail: json["thumbnail"],
        description: json["description"],
        price: Price.fromJson(json["price"]),
        collection: Collection.fromJson(json["collection"]),
        currentUserData: CurrentUserData.fromJson(json["currentUserData"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "file": file,
        "name": name,
        "thumbnail": thumbnail,
        "description": description,
        "price": price.toJson(),
        "collection": collection.toJson(),
        "currentUserData": currentUserData.toJson(),
      };
}

class CurrentUserData {
  CurrentUserData({
    required this.isLiked,
    required this.isOwner,
  });

  bool isLiked;
  bool isOwner;

  factory CurrentUserData.fromJson(Map<String, dynamic> json) =>
      CurrentUserData(
        isLiked: json["isLiked"],
        isOwner: json["isOwner"],
      );

  Map<String, dynamic> toJson() => {
        "isLiked": isLiked,
        "isOwner": isOwner,
      };
}
