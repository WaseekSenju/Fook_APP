import 'dart:convert';

Tokken tokkenFromJson(String str) => Tokken.fromJson(json.decode(str));

String tokkenToJson(Tokken data) => json.encode(data.toJson());

class Tokken {
  Tokken({
    required this.data,
  });

  List<Datum> data;

  factory Tokken.fromJson(Map<String, dynamic> json) => Tokken(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.file,
    required this.name,
    required this.thumbnail,
    required this.description,
    required this.collection,
    required this.currentUserData,
    required this.price,
  });

  String id;
  String file;
  String name;
  String thumbnail;
  String description;
  Price price;
  Collection collection;
  CurrentUserData currentUserData;


  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        file: json["file"],
        name: json["name"],
        thumbnail: json["thumbnail"] == null
            ? 'lib/Assets/grid/image (6).png'
            : json["thumbnail"],
        description: json["description"],
        price: json["price"] == null
            ? Price.fromJson2()
            : Price.fromJson(json["price"]),
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
        image: json["image"],
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

class CurrentUserData {
  CurrentUserData({
    required this.isLiked,
  });

  bool isLiked;

  factory CurrentUserData.fromJson(Map<String, dynamic> json) =>
      CurrentUserData(
        isLiked: json["isLiked"],
      );

  Map<String, dynamic> toJson() => {
        "isLiked": isLiked,
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

  factory Price.fromJson2() => Price(
        value: ' ',
        unit: ' ',
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "unit": unit,
      };
}
