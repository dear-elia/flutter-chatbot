//import the Hive Flutter package to use Hive functions

import 'package:hive_flutter/hive_flutter.dart';

//means that this file is part of a larger file (generated file)
part 'chat_history.g.dart';

//@HiveType defined that the ChatHistory class is a Hive object
@HiveType(typeId: 0)
class ChatHistory extends HiveObject {
  @HiveField(0)
  final String chatId;

//user's input prompt
  @HiveField(1)
  final String prompt;

//the bot's response
  @HiveField(2)
  final String response;

  @HiveField(3)
  final List<String> imagesUrls;

//time when the chat occured
  @HiveField(4)
  final DateTime timestamp;

  // constructor, that ensures that a ChatHistory obbject is fully defined upon creation and has all fields
  ChatHistory({
    required this.chatId,
    required this.prompt,
    required this.response,
    required this.imagesUrls,
    required this.timestamp,
  });
}
