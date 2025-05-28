import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'login.dart';
import 'register.dart';
import 'home.dart';
import 'history.dart';
import 'firmware.dart';
import 'settings.dart';
import 'forgot_password.dart';
import 'reset_password.dart';
import 'edit_name.dart';
import 'edit_password.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    await dotenv.load(fileName: ".env");
    
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      debug: true,
    );
    
    runApp(const MyApp());
  } catch (error) {
    debugPrint('Error initializing app: $error');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Error initializing app: $error'),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lokatani',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/main': (context) => const MainNavigation(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/reset-password': (context) => const ResetPasswordPage(),
        '/edit-name': (context) => const EditNamePage(),
        '/edit-password': (context) => const EditPasswordPage(),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _handleInitialDeepLink();
  }

  Future<void> _handleInitialDeepLink() async {
    try {
      final uri = Uri.base;
      debugPrint('Initial deep link: $uri');

      // First priority: Handle OTP expired case
      if (uri.toString().contains('error_code=otp_expired')) {
        if (!mounted) return;
        await Future.delayed(Duration.zero);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email berhasil diverifikasi. Silakan login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }

      // Second priority: Handle password reset
      if (uri.fragment.contains('type=recovery') || 
          uri.queryParameters['type'] == 'recovery') {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/reset-password');
        return;
      }

      // Check session last
      final session = await Supabase.instance.client.auth.currentSession;
      if (!mounted) return;
      
      if (session != null) {
        Navigator.of(context).pushReplacementNamed('/main');
      }
    } catch (e) {
      debugPrint('Error handling deep link: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final uri = Uri.base;

        // Handle OTP expired case first
        if (uri.toString().contains('error_code=otp_expired')) {
          return const LoginPage();
        }

        // Handle recovery token
        if (uri.fragment.contains('type=recovery') || 
            uri.queryParameters['type'] == 'recovery') {
          return const ResetPasswordPage();
        }

        if (snapshot.hasData) {
          final event = snapshot.data!.event;
          switch (event) {
            case AuthChangeEvent.passwordRecovery:
              return const ResetPasswordPage();
            case AuthChangeEvent.signedIn:
              return const MainNavigation();
            default:
              return const LoginPage();
          }
        }

        return const LoginPage();
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    HomePage(),
    FirmwareUploadPage(),
    FirmwareHistoryPage(),
    ProfilePage(),
  ];

  final List<NavigationItem> _navigationItems = const [
    NavigationItem(icon: 'assets/home.png', label: 'Home'),
    NavigationItem(icon: Icons.cloud_upload_outlined, label: 'Firmware'),
    NavigationItem(icon: Icons.history, label: 'History'),
    NavigationItem(icon: Icons.settings_outlined, label: 'Settings'),
  ];

  Widget _buildIcon(dynamic icon, bool isSelected) {
    if (icon is IconData) {
      return Icon(
        icon,
        size: 26,
        color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
      );
    } else {
      return SizedBox(
        width: 22,
        height: 22,
        child: Image.asset(
          icon as String,
          color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
          fit: BoxFit.contain,
        ),
      );
    }
  }

  Widget _buildNavItem(int index, NavigationItem item) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        width: 85,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E7D32).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border(
            top: BorderSide(
              color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(item.icon, isSelected),
            if (isSelected) ...[
              const SizedBox(height: 2),
              Text(
                item.label,
                style: const TextStyle(
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  color: Color(0xFF2E7D32),
                  height: 1.2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 68,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _navigationItems.length,
            (index) => _buildNavItem(index, _navigationItems[index]),
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  final dynamic icon;
  final String label;

  const NavigationItem({
    required this.icon,
    required this.label,
  });
}