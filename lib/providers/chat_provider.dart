import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:chatbotapp/constants/constants.dart';
import 'package:chatbotapp/hive/boxes.dart';
import 'package:chatbotapp/hive/chat_history.dart';
import 'package:chatbotapp/hive/settings.dart';
import 'package:chatbotapp/hive/user_model.dart';
import 'package:chatbotapp/models/message.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatProvider extends ChangeNotifier {
  // List of messages
  final List<Message> _inChatMessages = [];

  // Page controller
  final PageController _pageController = PageController();

  // Images file list
  List<XFile>? _imagesFileList = [];

  // Current index and chatId
  int _currentIndex = 0;
  String _currentChatId = '';

  // Model type and loading state
  String _modelType = 'gemini-pro';
  bool _isLoading = false;

  // Getters
  List<Message> get inChatMessages => _inChatMessages;
  PageController get pageController => _pageController;
  List<XFile>? get imagesFileList => _imagesFileList;
  int get currentIndex => _currentIndex;
  String get currentChatId => _currentChatId;
  String get modelType => _modelType;
  bool get isLoading => _isLoading;

  // Load messages from Hive for a specific chat ID
  Future<void> setInChatMessages({required String chatId}) async {
    final messagesFromDB = await loadMessagesFromDB(chatId: chatId);

    for (var message in messagesFromDB) {
      if (_inChatMessages.contains(message)) {
        log('message already exists');
        continue;
      }
      _inChatMessages.add(message);
    }
    notifyListeners();
  }

  Future<List<Message>> loadMessagesFromDB({required String chatId}) async {
    await Hive.openBox('${Constants.chatMessagesBox}$chatId');
    final messageBox = Hive.box('${Constants.chatMessagesBox}$chatId');
    final newData = messageBox.keys.map((e) {
      final message = messageBox.get(e);
      return Message.fromMap(Map<String, dynamic>.from(message));
    }).toList();
    notifyListeners();
    return newData;
  }

  void setImagesFileList({required List<XFile> listValue}) {
    _imagesFileList = listValue;
    notifyListeners();
  }

  String setCurrentModel({required String newModel}) {
    _modelType = newModel;
    notifyListeners();
    return newModel;
  }

  void setCurrentIndex({required int newIndex}) {
    _currentIndex = newIndex;
    notifyListeners();
  }

  void setCurrentChatId({required String newChatId}) {
    _currentChatId = newChatId;
    notifyListeners();
  }

  void setLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> deleteChatMessages({required String chatId}) async {
    final boxName = '${Constants.chatMessagesBox}$chatId';
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }

    await Hive.box(boxName).clear();
    await Hive.box(boxName).close();

    if (currentChatId == chatId) {
      setCurrentChatId(newChatId: '');
      _inChatMessages.clear();
      notifyListeners();
    }
  }

  Future<void> prepareChatRoom({
    required bool isNewChat,
    required String chatID,
  }) async {
    _inChatMessages.clear();
    if (!isNewChat) {
      _inChatMessages.addAll(await loadMessagesFromDB(chatId: chatID));
    }
    setCurrentChatId(newChatId: chatID);
    notifyListeners();
  }

  Future<void> sentMessage({
    required String message,
    required bool isTextOnly,
  }) async {
    setLoading(value: true);
    final chatId = getChatId();
    final imagesUrls = getImagesUrls(isTextOnly: isTextOnly);
    final messagesBox = await Hive.openBox('${Constants.chatMessagesBox}$chatId');

    final userMessage = Message(
      messageId: messagesBox.keys.length.toString(),
      chatId: chatId,
      role: Role.user,
      message: StringBuffer(message),
      imagesUrls: imagesUrls,
      timeSent: DateTime.now(),
    );

    _inChatMessages.add(userMessage);
    notifyListeners();

    if (currentChatId.isEmpty) {
      setCurrentChatId(newChatId: chatId);
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5001/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final assistantMessage = Message(
          messageId: (messagesBox.keys.length).toString(),
          chatId: chatId,
          role: Role.assistant,
          message: StringBuffer(responseData['response']),
          timeSent: DateTime.now(),
          imagesUrls: imagesUrls,
        );

        _inChatMessages.add(assistantMessage);
        notifyListeners();

        await saveMessagesToDB(
          chatID: chatId,
          userMessage: userMessage,
          assistantMessage: assistantMessage,
          messagesBox: messagesBox,
        );
      } else {
        log('Error: ${response.statusCode}');
      }
    } catch (error) {
      log('Error sending message: $error');
    } finally {
      setLoading(value: false);
      await messagesBox.close();
    }
  }

  Future<void> saveMessagesToDB({
    required String chatID,
    required Message userMessage,
    required Message assistantMessage,
    required Box messagesBox,
  }) async {
    await messagesBox.add(userMessage.toMap());
    await messagesBox.add(assistantMessage.toMap());

    final chatHistoryBox = Boxes.getChatHistory();
    final chatHistory = ChatHistory(
      chatId: chatID,
      prompt: userMessage.message.toString(),
      response: assistantMessage.message.toString(),
      imagesUrls: userMessage.imagesUrls,
      timestamp: DateTime.now(),
    );
    await chatHistoryBox.put(chatID, chatHistory);

    await messagesBox.close();
  }

  List<String> getImagesUrls({required bool isTextOnly}) {
    return isTextOnly || imagesFileList == null
        ? []
        : imagesFileList!.map((image) => image.path).toList();
  }

  Future<List<String>> getHistory({required String chatId}) async {
    if (_currentChatId != chatId) {
      await setInChatMessages(chatId: chatId);
    }
    return _inChatMessages.map((msg) => msg.message.toString()).toList();
  }

  String getChatId() {
    if (_currentChatId.isEmpty) {
      _currentChatId = const Uuid().v4();
    }
    return _currentChatId;
  }

  static Future<void> initHive() async {
    final dir = await path.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.initFlutter(Constants.geminiDB);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatHistoryAdapter());
      await Hive.openBox<ChatHistory>(Constants.chatHistoryBox);
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserModelAdapter());
      await Hive.openBox<UserModel>(Constants.userBox);
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SettingsAdapter());
      await Hive.openBox<Settings>(Constants.settingsBox);
    }
  }
}
