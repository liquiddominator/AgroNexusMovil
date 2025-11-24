import 'package:agro_nexus_movil/views/auth/login_screen.dart';
import 'package:agro_nexus_movil/views/auth/register_screen.dart';
import 'package:agro_nexus_movil/views/auth/splash_screen.dart';
import 'package:agro_nexus_movil/views/encabezado/configuracion_screen.dart';
import 'package:agro_nexus_movil/views/encabezado/notificaciones_screen.dart';
import 'package:agro_nexus_movil/views/inicio/home_shell.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bsmobatqfjmrfiipkimu.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJzbW9iYXRxZmptcmZpaXBraW11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM2MzUxODIsImV4cCI6MjA3OTIxMTE4Mn0.E6mthorZPy3qcquoLLm_VWu10CK2HikbwxHx3Yq6tlA',
  );

  runApp(const AgroNexusApp());
}

class AgroNexusApp extends StatelessWidget {
  const AgroNexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgroNexus',
      theme: ThemeData(
        primaryColor: const Color(0xFF00796B),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard-principal': (context) => const AgroNexusHomeShell(),
        '/configuracion': (context) => const ConfiguracionScreen(),
        '/notificaciones': (context) => const NotificacionesScreen(),
      },
    );
  }
}