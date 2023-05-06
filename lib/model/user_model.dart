import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;

  UserModel({this.id, this.name, this.email, this.phone, this.address});

  UserModel.fromSnapshot(DataSnapshot snapshot) {
    id = (snapshot.value as dynamic)["id"];
    name = (snapshot.value as dynamic)["name"];
    email = (snapshot.value as dynamic)["email"];
    phone = (snapshot.value as dynamic)["phone"];
    address = (snapshot.value as dynamic)["address"];
  }
}
