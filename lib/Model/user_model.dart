import 'package:flutter/scheduler.dart';

class User {
  int? iD;
  String? firstName;
  String? lastName;
  var age;
  String? gender;
  int? status;

  User({
    this.firstName,
    this.lastName,
    this.age,
    this.gender,
    this.status,
  });

  User.withId({
    this.iD,
    this.firstName,
    this.lastName,
    this.age,
    this.gender,
    this.status,
  });


  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();

    if (iD != null) {
      map["id"] = iD;
    }

    map["firstName"] = firstName;
    map["lastName"] = lastName;
    map["age"] = age;
    map["gender"] = gender;
    map["status"] = status;
    return map;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User.withId(
      iD: map["id"],
      firstName: map["firstName"],
      lastName: map["lastName"],
      age: map["age"],
      gender: map["gender"],
      status: map["status"],
    );
  }
}
