import 'dart:convert';

import 'M_Participant.dart';

User userFromJson(
  String user,
  String part,
) =>
    User.fromJson(json.decode(user), json.decode(part));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({this.username, this.email, this.participant});

  String username;
  String email;
  M_Participant participant;

  User.fromJson(Map json, Map json_part)
      : username = json['username'],
        email = json['email'],
        participant = M_Participant.fromJson(json_part['imageName']);

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
      };
}
