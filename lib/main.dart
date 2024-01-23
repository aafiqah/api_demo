// main.dart
import 'package:api_demo/pages/home.dart';
import 'package:api_demo/pages/other.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyAppStateful(), 
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyAppStateful extends StatefulWidget {
  const MyAppStateful({Key? key}) : super(key: key);

  @override
  State<MyAppStateful> createState() => _MyAppState();
}

class _MyAppState extends State<MyAppStateful> {
  int currentIndex = 0;
  List<Widget> widgetList = const [
    HomePage(),
    OtherPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: widgetList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        showUnselectedLabels: false,
        backgroundColor: Colors.blueAccent,
        selectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Other',
          ),
        ],
      ),
    );
  }
}
