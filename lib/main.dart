import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/firebase_options.dart';
import 'package:flutter1/navigation/layout_bottom_bar.dart';
import 'package:flutter1/utils/list_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://oukwkoishrxtyqvbqiia.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91a3drb2lzaHJ4dHlxdmJxaWlhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTUxOTgzMjgsImV4cCI6MjAzMDc3NDMyOH0.-Hz5v248e__0V2PpFRw_nfK9cZxdSXeozUtB097hz6I',
  );

  runApp(ChangeNotifierProvider(
      create: (context) => Bill(), child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: LayoutBottomBar(),
      ),
    );
  }
}
