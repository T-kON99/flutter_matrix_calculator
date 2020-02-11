import 'package:flutter/material.dart';
import './views/data.dart';
import './views/calculator.dart';

class NavTab {
  const NavTab(this.title, this.icon, this.color, this.route);
  final String title;
  final IconData icon;
  final MaterialColor color;
  final String route;
}

class TabView extends StatefulWidget {
  const TabView({Key key, this.tab}) : super(key: key);
  final NavTab tab;
  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch(widget.tab.route) {
      case '/data':
        return DataPage();
      case '/calculator':
        return CalculatorPage();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

const List<NavTab> Navigations = <NavTab>[
  NavTab('Data', Icons.apps, Colors.blue, '/data'),
  NavTab('Calculator', Icons.keyboard, Colors.blue, '/calculator')
];
