import 'package:hive_flutter/hive_flutter.dart';

//this file defines a model for settings that will be stored in a Hive box
//Important file for personalizing the user experience

//indicates that this file is linked to a generated part file
part 'settings.g.dart';

//defines the Settings' unique typeId, all Hive objects have unique ids
@HiveType(typeId: 2)
class Settings extends HiveObject {
  @HiveField(0)

  //boolean field to determine if the dark theme is enabled
  bool isDarkTheme = false;

  //boolean field to specify if the application should provide spoken feedback
  @HiveField(1)
  bool shouldSpeak = false;

  // constructor
  Settings({
    required this.isDarkTheme,
    required this.shouldSpeak,
  });
}
