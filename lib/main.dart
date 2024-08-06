import 'package:flutter/material.dart';
import 'package:untitled1/loan_page.dart';
import 'package:untitled1/past_commits_page.dart';
import 'package:untitled1/users_equipments.dart';
import 'package:untitled1/widgets/search_bar.dart';
import 'First_page.dart';
import 'design_features.dart';
import 'equipment_summary_page.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDbCmHUgspgVqTT6b15mc6LvcBPiR15qJc",
            authDomain: "storagekepp.firebaseapp.com",
            projectId: "storagekepp",
            storageBucket: "storagekepp.appspot.com",
            messagingSenderId: "546266079998",
            appId: "1:546266079998:web:220106647f055f6860fbaf",
            measurementId: "G-3N446WG4G0"
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    runApp(const MyApp());
  } catch (e, stackTrace) {
    print('Error initializing Firebase: $e');
    print(stackTrace);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'החתמת ציוד',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(0, 0, 0, 1)),
        // useMaterial3: true,
        appBarTheme: AppBarTheme( backgroundColor: appBarColor),
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: ''),
      initialRoute: '/',
      routes: {
        '/first': (context) => const FirstPage(),
        '/second': (context) => const LoanPage(),
        '/third': (context) => const EquipSumPage(),
        '/fourth': (context) => const UserEquipmentPage(),
        '/fifth': (context) => const PastCommitPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();

  void _handleSearch(String query) {
    // Implement your search logic here
    print("Searching for: $query");
  }

  void goToFirstPage() {
    Navigator.pushNamed(context, '/first');
  }

  void goToLoanPage() {
    Navigator.pushNamed(context, '/second');
  }

  void goToEquipSumPage() {
    Navigator.pushNamed(context, '/third');
  }

  void goToShowPage() {
    Navigator.pushNamed(context, '/fourth');
  }

  void goToPastCommits() {
    Navigator.pushNamed(context, '/fifth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title, style: labelTextStyle,),
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // buildSearchBar(controller: _searchController, onSearch: _handleSearch),
              const SizedBox(height: 70),
              Hero(tag: "add storage eq",
                  child: _buildNavigationButton(context, 'הוספת ציוד לאחסון', goToFirstPage)),
              const SizedBox(height: 53),
              Hero(tag: "loan equipment",
                  child: _buildNavigationButton(context, 'החתמת/זיכוי ציוד', goToLoanPage)),
              const SizedBox(height: 53),
              _buildNavigationButton(context, 'Show all loaners', goToShowPage),
              const SizedBox(height: 53),
              Hero(tag: 'equipment state', child:
              _buildNavigationButton(context, 'מציבת ציוד', goToEquipSumPage)),
              const SizedBox(height: 53),
              _buildNavigationButton(context, 'Show past commits', goToPastCommits),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, String text, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10),
        color: directorsBotoomBarColor,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Center(child: Text(
          text,
          style: labelTextStyle,
        ),
      ),
    ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

}
