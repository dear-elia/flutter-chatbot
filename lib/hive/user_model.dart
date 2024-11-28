import 'package:hive_flutter/hive_flutter.dart';

//this file defines a model for user data that will be stored in a Hive box
//Important file for identifying and displaying the user profile

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {

  //user's unique id
  @HiveField(0)
  final String uid;

  //user's name
  @HiveField(1)
  final String name;

  //path to user's image
  @HiveField(2)
  final String image;

  // constructor
  UserModel({
    required this.uid,
    required this.name,
    required this.image,
  });
}
