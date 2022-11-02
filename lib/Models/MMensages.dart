// To parse this JSON data, do
//
//     final mMensages = mMensagesFromJson(jsonString);

import 'dart:convert';

MMensages mMensagesFromJson(String str) => MMensages.fromJson(json.decode(str));

String mMensagesToJson(MMensages data) => json.encode(data.toJson());

class MMensages {
    MMensages({
        this.id,
        this.messageId,
        this.title,
        this.message,
        this.typeMessage,
        this.createdDate,
        this.v,
    });

    String id;
    String messageId;
    String title;
    String message;
    String typeMessage;
    DateTime createdDate;
    int v;

    factory MMensages.fromJson(Map<String, dynamic> json) => MMensages(
        id: json["_id"],
        messageId: json["message_id"],
        title: json["title"],
        message: json["message"],
        typeMessage: json["type_message"],
        createdDate: DateTime.parse(json["created_date"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "message_id": messageId,
        "title": title,
        "message": message,
        "type_message": typeMessage,
        "created_date": createdDate.toIso8601String(),
        "__v": v,
    };
}
