class Message {
  //a unique id for each message
  String messageId;

  //the id for chat session to which the message belongs
  String chatId;

  //the role of sender: user or assistant
  Role role;

  //hold the actual message content
  StringBuffer message;

  //a list of image URLs associated with message
  List<String> imagesUrls;

  //indicates when the message was sent
  DateTime timeSent;

  // constructor
  Message({
    required this.messageId,
    required this.chatId,
    required this.role,
    required this.message,
    required this.imagesUrls,
    required this.timeSent,
  });

  // toMap
  //This method converts the Message into a map. Useful for serialization (saving to DB)

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'chatId': chatId,
      'role': role.index,
      //coverts the StringBuffer to a string
      'message': message.toString(),
      'imagesUrls': imagesUrls,
      //converts the DateTime to a string in ISO 8602 format
      'timeSent': timeSent.toIso8601String(),
    };
  }

  // from map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['messageId'],
      chatId: map['chatId'],

      //converts the stored index back to Role
      role: Role.values[map['role']],
      message: StringBuffer(map['message']),
      imagesUrls: List<String>.from(map['imagesUrls']),
      
      //back to DataTime from string
      timeSent: DateTime.parse(map['timeSent']),
    );
  }

  // This method allows to create a copy of the current message object
  // Used when we want to change message properties
  Message copyWith({
    String? messageId,
    String? chatId,
    Role? role,
    StringBuffer? message,
    List<String>? imagesUrls,
    DateTime? timeSent,
  }) {
    //?? operator helps to keep the original values if the new values is not provided
    return Message(
      messageId: messageId ?? this.messageId,
      chatId: chatId ?? this.chatId,
      role: role ?? this.role,
      message: message ?? this.message,
      imagesUrls: imagesUrls ?? this.imagesUrls,
      timeSent: timeSent ?? this.timeSent,
    );
  }

//if the two messages have the same ID, they are considered equal
  @override
  bool operator ==(Object other) {

    //This function checks if the this(current object) and other(another obhect)
    //refer to the exact same object in memory
    if (identical(this, other)) return true;

    //if other is Message and other object's messageId is the same as messageId of current object(this) --> true
    return other is Message && other.messageId == messageId;
  }
  
  //getter providees a hash code for the Message object
  @override
  int get hashCode {
    return messageId.hashCode;
  }
}

enum Role {
  user,
  assistant,
}
