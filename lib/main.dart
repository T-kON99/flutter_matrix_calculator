import 'package:flutter/material.dart';
import './navbar.dart';
import './classes/matrix.dart';

void main() => runApp(Main());

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _curTabIndex = 0;
  Map<String, Matrix> data = {};
  int precision = 6;

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(initialPage: _curTabIndex);
    return MaterialApp(
        title: 'Matrix Calculator',
        home: Scaffold(
      appBar: AppBar(
        title: Text('Matrix Calculator'),
      ),
      body: Builder(
        builder: (context) {
          return SafeArea(
            top: false,
            child: PageView(
              controller: pageController,
              scrollDirection: Axis.horizontal,
              children: Navigations.map<Widget>((NavTab tab) {
                return TabView(tab: tab, data: this.data, precision: this.precision);
              }).toList(),
              onPageChanged: (index) => this.setState(() { _curTabIndex = index; }),
            ),
          );
        }
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
          pageController.animateToPage(tabIndex, duration: Duration(milliseconds: 500), curve: Curves.ease);
          setState(() {
            _curTabIndex = tabIndex;
          });
        },
      ),
    ));
  }
}
