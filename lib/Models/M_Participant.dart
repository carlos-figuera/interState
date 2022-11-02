// To parse this JSON data, do
//
//     final participant = participantFromJson(jsonString);

import 'dart:convert';

M_Participant participantFromJson(String str) =>
    M_Participant.fromJson(json.decode(str));

String participantToJson(M_Participant data) => json.encode(data.toJson());

class M_Participant {
  M_Participant({
    this.id,
    this.document,
    this.isCedula,
    this.gender,
    this.name,
    this.lastName,
    this.mobile,
    this.mobileOs,
    this.birthDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.acceptTermsAndConditions,
  });

  int id;
  String document;
  bool isCedula;
  String gender;
  String name;
  String lastName;
  String mobile;
  String mobileOs;
  String birthDate;
  String status;
  String createdAt;
  String updatedAt;
  bool acceptTermsAndConditions;

  factory M_Participant.fromJson(Map<String, dynamic> json) => M_Participant(
        id: json["id"],
        document: json["document"],
        isCedula: json["isCedula"],
        gender: json["gender"],
        name: json["name"],
        lastName: json["lastName"],
        mobile: json["mobile"],
        mobileOs: json["mobileOs"],
        birthDate: json["birthDate"],
        status: json["status"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        acceptTermsAndConditions: json["acceptTermsAndConditions"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "document": document,
        "isCedula": isCedula,
        "gender": gender,
        "name": name,
        "lastName": lastName,
        "mobile": mobile,
        "mobileOs": mobileOs,
        "birthDate": birthDate,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "acceptTermsAndConditions": acceptTermsAndConditions,
      };
}
