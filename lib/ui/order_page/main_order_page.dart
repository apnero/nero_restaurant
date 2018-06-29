import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nero_restaurant/ui/order_page/favorites_tab.dart';
import 'package:nero_restaurant/ui/order_page/featured_tab.dart';
import 'package:nero_restaurant/ui/order_page/menu_tab.dart';
import 'package:nero_restaurant/ui/order_page/previous_tab.dart';
import 'package:nero_restaurant/services/firebase_calls.dart';

class MainOrderPage extends StatefulWidget {
  @override
  _MainOrderPageState createState() => new _MainOrderPageState();
}

class _MainOrderPageState extends State<MainOrderPage> {

  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = new Timer.periodic(new Duration(seconds: 2), (Timer timer) async {
      try {
        setState(() {});
      } catch (e) {
        print(e.toString());
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 4,
      child: new Scaffold(
        appBar: new AppBar(
          bottom: new TabBar(
            tabs: <Widget>[
              new Tab(text: 'Menu'),
              new Tab(text: 'Featured'),
              new Tab(text: 'Previous'),
              new Tab(text: 'Favorites'),
            ],
          ),
          title: new Text('Orders'),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.restaurant_menu),
              tooltip: 'Menu',
              onPressed: () => Navigator.pushNamed(context, "/main_order_page"),
            ),
            new IconButton(
              icon: new Icon(Icons.shopping_cart),
              tooltip: 'Shopping Cart',
              onPressed: () =>
                  Navigator.pushNamed(context, "/shopping_cart_page"),
            ),
            new IconButton(
              icon: new Icon(Icons.card_membership),
              tooltip: 'Loyalty Card',
              onPressed: () =>
                  Navigator.pushNamed(context, "/loyalty_card_page"),
            ),
          ],
        ),
        body: new TabBarView(
          children: <Widget>[
            MenuTab(),
            FeaturedTab(),
            PreviousTab(),
            FavoritesTab(),
          ],
        ),
        floatingActionButton: new FutureBuilder<Map<String, double>>(
            future: FirebaseCalls.getCost(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FloatingActionButton.extended(
                    icon: new Icon(Icons.shopping_cart),
                    key: new ValueKey<Key>(new Key('1')),
                    label: new Text('\$' +
                        (snapshot.data['cartPrice'] * 1.0635)
                            .toStringAsFixed(2)),
                    onPressed: () =>
                        Navigator.pushNamed(context, "/shopping_cart_page"));
              } else if (snapshot.hasError) {
                return new Text("${snapshot.error}");
              } else
                return new Container(
                  height: 30.0,
                );
            }),
      ),
    );
  }
}
