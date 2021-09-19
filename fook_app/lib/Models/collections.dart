import 'dart:convert';

Collections collectionsFromJson(String str) => Collections.fromJson(json.decode(str));

String collectionsToJson(Collections data) => json.encode(data.toJson());

class Collections {
    Collections({
        required this.data,
    });

    List<Datum> data;

    factory Collections.fromJson(Map<String, dynamic> json) => Collections(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
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

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        symbol: json["symbol"],
        image: json["image"],
        contract: json["contract"]==null?' ':json["contract"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "symbol": symbol,
        "image": image,
        "contract": contract,
    };
}
