import 'package:flutter/material.dart';
import './navbar.dart';

void main() => runApp(Main());

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _curTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('Matrix Calculator'),
      ),
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _curTabIndex,
          children: Navigations.map<Widget>((NavTab tab) {
            return TabView(tab: tab);
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _curTabIndex,
        items: Navigations.map((NavTab tab) {
          return BottomNavigationBarItem(
            icon: Icon(tab.icon),
            title: Text(tab.title),
            backgroundColor: tab.color
          );
        }).toList(),
        onTap: (tabIndex) {
          setState(() {
            _curTabIndex = tabIndex;
          });
        },
      ),
    ));
  }
}
