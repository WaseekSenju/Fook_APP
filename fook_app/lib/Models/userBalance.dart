import 'dart:convert';

UserBalance userBalanceFromJson(String str) => UserBalance.fromJson(json.decode(str));

String userBalanceToJson(UserBalance data) => json.encode(data.toJson());

class UserBalance {
    UserBalance({
        required this.data,
    });

    Data data;

    factory UserBalance.fromJson(Map<String, dynamic> json) => UserBalance(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    Data({
        required this.value,
        required this.unit,
    });

    String value;
    String unit;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        value: json["value"],
        unit: json["unit"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "unit": unit,
    };
}