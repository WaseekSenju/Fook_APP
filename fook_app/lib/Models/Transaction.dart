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
    required this.fromWallet,
    required this.token,
    required this.collection,
    required this.toWallet,
    required this.fromUser,
    required this.toUser,
    required this.price,
  });

  String transactionHash;
  String transactionType;
  String tokenId;
  String fromWallet;
  Token token;
  Collection collection;
  String toWallet;
  User fromUser;
  User toUser;
  Price price;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
<<<<<<< HEAD
        transactionHash: json["transactionHash"],
        transactionType: json["transactionType"],
        tokenId: json["tokenId"],
        fromWallet: json["fromWallet"],
        token: Token.fromJson(json["token"]),
        collection: Collection.fromJson(json["collection"]),
        toWallet: json["toWallet"] == null ? ' ' : json["toWallet"],
        fromUser: json['fromUser'] == null
            ? User.fromJsonIfNull()
            : User.fromJson(json["fromUser"]),
        toUser: json['toUser'] == null
            ? User.fromJsonIfNull()
            : User.fromJson(json["toUser"]),
        price: json["price"] == null
            ? Price.fromJson2()
            : Price.fromJson(json["price"]),
=======
        transactionHash: json["transactionHash"] ?? '',
        transactionType: json["transactionType"] ?? '',
        tokenId: json["tokenId"] ?? '',
        contract: json["contract"] ?? '',
        fromWallet: json["fromWallet"] ?? '',
        toWallet: json["toWallet"] ?? '',
        token: Token.fromJson(json["token"] ?? Map<String, dynamic>()),
        collection: Collection.fromJson(json["collection"] ?? Map<String, dynamic>()),
        fromUser: User.fromJson(json["fromUser"] ?? Map<String, dynamic>()),
        toUser: User.fromJson(json["toUser"] ?? Map<String, dynamic>()),
        price: Price.fromJson(json["price"] ?? Map<String, dynamic>()),
>>>>>>> b21721468fc60e641902f6a31274919b29301d87
      );

  Map<String, dynamic> toJson() => {
        "transactionHash": transactionHash,
        "transactionType": transactionType,
        "tokenId": tokenId,
        "fromWallet": fromWallet,
        "token": token.toJson(),
        "collection": collection.toJson(),
        "toWallet": toWallet,
        "fromUser": fromUser,
        "toUser": toUser,
        "price": price,
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
<<<<<<< HEAD
        id: json["id"],
        name: json["name"],
        symbol: json["symbol"],
        image: json["image"],
        contract: json["contract"],
=======
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        symbol: json["symbol"] ?? '',
        image: json["image"] ?? '' ,
        contract: json["contract"] ?? '',
>>>>>>> b21721468fc60e641902f6a31274919b29301d87
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
    required this.image,
  });

  int id;
  String username;
  String image;

  factory User.fromJson(Map<String, dynamic> json) => User(
<<<<<<< HEAD
        id: json["id"],
        username: json["username"],
        image: json["image"] == null ? ' ' : json["image"],
      );

  factory User.fromJsonIfNull() => User(
        id: 0,
        username: ' ',
        image: ' ',
=======
        id: json["id"] ?? 0,
        username: json["username"] ?? '',
        //image: json["image"] == null ? 'lib/Assets/grid/image (6).png' : json["image"],
>>>>>>> b21721468fc60e641902f6a31274919b29301d87
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "image": image,
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
        value: json["value"] ?? '',
        unit: json["unit"] ?? '',
      );
  factory Price.fromJson2() => Price(
        value: ' ',
        unit: ' ',
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
    required this.collection,
    required this.thumbnail,
    required this.description,
  });

  String id;
  String file;
  String name;
  Collection collection;
  String thumbnail;
  String description;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
<<<<<<< HEAD
        id: json["id"],
        file: json["file"],
        name: json["name"],
        collection: Collection.fromJson(json["collection"]),
        thumbnail: json["thumbnail"],
        description: json["description"],
=======
        id: json["id"] ?? 0,
        file: json["file"] ?? 0,
        name: json["name"] ?? 0,
        thumbnail: json["thumbnail"] ?? 0,
        description: json["description"] ?? 0,
        price: Price.fromJson(json["price"] ?? Map<String, dynamic>()),
        collection: Collection.fromJson(json["collection"] ?? Map<String, dynamic>()),
        currentUserData: CurrentUserData.fromJson(json["currentUserData"] ?? Map<String, dynamic>()),
>>>>>>> b21721468fc60e641902f6a31274919b29301d87
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "file": file,
        "name": name,
        "collection": collection.toJson(),
        "thumbnail": thumbnail,
        "description": description,
<<<<<<< HEAD
=======
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
        isLiked: json["isLiked"] ?? false,
        isOwner: json["isOwner"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "isLiked": isLiked,
        "isOwner": isOwner,
>>>>>>> b21721468fc60e641902f6a31274919b29301d87
      };
}
