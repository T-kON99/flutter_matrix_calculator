import 'package:flutter/material.dart';
import './views/data.dart';
import './views/calculator.dart';
import './classes/matrix.dart';

class NavTab {
  const NavTab(this.title, this.icon, this.color, this.route);
  final String title;
  final IconData icon;
  final MaterialColor color;
  final String route;
}

class TabView extends StatefulWidget {
  const TabView({Key key, this.tab, this.data}) : super(key: key);
  final NavTab tab;
  final Map<String, Matrix> data;
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
        return DataPage(data: widget.data);
      case '/calculator':
        return CalculatorPage(data: widget.data);
      default:
        return DataPage();
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
