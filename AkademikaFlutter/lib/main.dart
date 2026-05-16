import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import './providers/auth_provider.dart';
import './screens/login_screen.dart';
import './screens/main_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const AkademikaApp(),
    ),
  );
}

class AkademikaApp extends StatelessWidget {
  const AkademikaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akademika',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FD),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF316483),
          onPrimary: Color(0xFFF5F9FF),
          primaryContainer: Color(0xFFA6D8FB),
          onPrimaryContainer: Color(0xFF124C6A),
          secondary: Color(0xFF50616E),
          onSecondary: Color(0xFFF5F9FF),
          secondaryContainer: Color(0xFFD2E5F5),
          onSecondaryContainer: Color(0xFF425461),
          tertiary: Color(0xFF565D85),
          onTertiary: Color(0xFFFAF8FF),
          tertiaryContainer: Color(0xFFC9CFFE),
          onTertiaryContainer: Color(0xFF3E456C),
          error: Color(0xFFA83836),
          onError: Color(0xFFFFF7F6),
          errorContainer: Color(0xFFFA746F),
          onErrorContainer: Color(0xFF6E0A12),
          surface: Color(0xFFF8F9FD),
          onSurface: Color(0xFF2C3339),
          surfaceContainerHighest: Color(0xFFDCE3EB),
          onSurfaceVariant: Color(0xFF596066),
          outline: Color(0xFF747C82),
          outlineVariant: Color(0xFFACB3BA),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).tryAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (auth.user != null) {
      return const MainScreen();
    }
    return const LoginScreen();
  }
}
