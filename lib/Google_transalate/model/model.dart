// To parse this JSON data, do
//
//     final language = languageFromJson(jsonString);

import 'dart:convert';

Language languageFromJson(String str) => Language.fromJson(json.decode(str));

String languageToJson(Language data) => json.encode(data.toJson());

class Language {
  String status;
  Data data;

  Language({
    required this.status,
    required this.data,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  String text;

  Data({
    required this.text,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
  };
}
