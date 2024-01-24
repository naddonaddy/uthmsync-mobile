import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uthmsync5/firebase_options.dart';
import 'package:uthmsync5/utils/responsive%20layout/desktop_scaffold.dart';
import 'package:uthmsync5/utils/responsive%20layout/mobile_scaffold.dart';
import 'package:uthmsync5/utils/responsive%20layout/responsive_layout.dart';
import 'package:uthmsync5/utils/responsive%20layout/tablet_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase for Windows
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Run your app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTHMSync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      initialRoute: '/', // Set the initial route to '/'
      routes: {
        '/': (context) => const MyAppRouter(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyAppRouter extends StatelessWidget {
  const MyAppRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: ResponsiveLayout(
          mobileScaffold: MobileScaffold(),
          tabletScaffold: TabletScaffold(),
          desktopScaffold: DesktopScaffold(),
        ),
      ),
    );
  }
}
