import 'package:flutter/cupertino.dart';
import 'package:natal_smart/screens/configurations.dart';
import 'package:natal_smart/screens/home.dart';

class NatalSmartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: NatalSmartHomePage(),
    );
  }
}

class NatalSmartHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.brightness),
            title: Text('List'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            title: Text('Server'),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        CupertinoTabView returnValue;
        switch (index) {
          case 0:
            returnValue = CupertinoTabView(builder: (context) {
              return MyHomePage();
            });
            break;
          case 1:
            returnValue = CupertinoTabView(builder: (context) {
              return ConfigPage();
            });
            break;
        }
        return returnValue;
      },
    );
  }
}
