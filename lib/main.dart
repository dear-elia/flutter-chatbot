import 'package:chatbotapp/screens/welcome_screen.dart';
import 'package:chatbotapp/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatbotapp/themes/my_theme.dart';
import 'package:chatbotapp/providers/chat_provider.dart';
import 'package:chatbotapp/providers/settings_provider.dart';
import 'package:chatbotapp/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:chatbotapp/screens/signup_screen.dart';
import 'package:chatbotapp/screens/profile_screen.dart';
import 'package:chatbotapp/screens/chat_screen.dart';
import 'package:chatbotapp/screens/chat_history_screen.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:chatbotapp/themes/login_theme.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //await dotenv.load(fileName: ".env");
  await ChatProvider.initHive();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ChatProvider()),
      ChangeNotifierProvider(create: (context) => SettingsProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    setTheme();
    super.initState();
  }

  void setTheme() {
    final settingsProvider = context.read<SettingsProvider>();
    settingsProvider.getSavedSettings();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<SettingsProvider>().isDarkMode;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: _getAppropriateTheme(context, isDarkMode),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/chat': (context) => const ChatScreen(),
        '/chatHistory': (context) => const ChatHistoryScreen(),
      },
    );
  }

  ThemeData _getAppropriateTheme(BuildContext context, bool isDarkMode) {
    String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    // 检查是否是登录注册相关的界面
    if (currentRoute == '/' ||
        currentRoute == '/signin' ||
        currentRoute == '/signup') {
      return lightMode; // 登录注册界面的主题
    } else {
      // 应用界面使用 home_theme 的主题
      return isDarkMode ? darkTheme : lightTheme;
    }
  }
}
