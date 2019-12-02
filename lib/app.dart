import 'package:flutter/cupertino.dart';
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
            icon: Icon(CupertinoIcons.tags),
            title: Text('NFC'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.shopping_cart),
            title: Text('Cart'),
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
              return CupertinoPageScaffold(
                // child: SearchTab(),
              );
            });
            break;
          case 2:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                // child: ShoppingCartTab(),
              );
            });
            break;
        }
        return returnValue;
      },
    );
  }
}
