import 'package:flutter/material.dart';
import 'package:untitled1/loan_page.dart';
import 'package:untitled1/widgets/search_bar.dart';

import 'First_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'החתמת ציוד',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
      initialRoute: '/',
      routes: {
        '/first': (context) => const FirstPage(),
        '/second': (context) => const LoanPage()
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
  TextEditingController _searchController = TextEditingController();

  void _handleSearch(String query) {
    // Implement your search logic here
    print("Searching for: $query");
  }

  void go_to_first_page(){
   Navigator.pushNamed(context, '/first');
  }

  void go_to_loan_page(){
    Navigator.pushNamed(context, '/second');
  }
  void null_Function(){
    print('null function');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child:
        SingleChildScrollView(
          child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildSearchBar(controller: _searchController, onSearch: _handleSearch),
            SizedBox(height: 10),
            //add equipment to storage button
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: GestureDetector(
                onTap: go_to_first_page,
                child: Text(
                  'ADD equipment to storage',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              )
            ),
            SizedBox(height: 10),
            //add equipment to loaner button
            Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: GestureDetector(
                  onTap: go_to_loan_page,
                  child: Text(
                    'add equipment to loaner',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                )
            ),
            SizedBox(height: 10),
            //show equipment loaned
            Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: GestureDetector(
                  onTap: go_to_first_page,
                  child: Text(
                    'show all loaners',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                )
            ),
            SizedBox(height: 10),
            //show equipment state
            Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: GestureDetector(
                  onTap: go_to_first_page,
                  child: Text(
                    'show equipment states',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                )
            ),
            SizedBox(height: 10),
            //show equipment state
            Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: GestureDetector(
                  onTap: go_to_first_page,
                  child: Text(
                    'show equipment states',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                )
            ),


          ],
        ),
      ),)
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

}
