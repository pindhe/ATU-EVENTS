import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/event_provider.dart';
import 'providers/user_provider.dart';
import 'providers/class_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/message_provider.dart';
import 'providers/log_provider.dart';
import 'providers/notification_provider.dart';
import 'theme/apex_theme.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ClassProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (_) => LogProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const AtuEventsApp(),
    ),
  );
}

class AtuEventsApp extends StatelessWidget {
  const AtuEventsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'ATU Events',
      themeMode: themeProvider.themeMode,
      theme: ApexTheme.lightTheme,
      darkTheme: ApexTheme.darkTheme,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

