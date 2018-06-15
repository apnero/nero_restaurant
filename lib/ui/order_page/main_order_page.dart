import 'package:flutter/material.dart';
import 'package:nero_restaurant/ui/order_page/favorites_tab.dart';
import 'package:nero_restaurant/ui/order_page/featured_tab.dart';
import 'package:nero_restaurant/ui/order_page/menu_tab.dart';
import 'package:nero_restaurant/ui/order_page/previous_tab.dart';
import 'package:nero_restaurant/ui/style.dart';

class MainOrderPage extends StatelessWidget {
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
        ),
        body: new TabBarView(
          children: <Widget>[
            MenuTab(),
            FeaturedTab(),
            PreviousTab(),
            FavoritesTab(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          hasNotch: false,
          child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: ()  => Navigator.of(context).pushNamed('/shopping-cart-page'),
                ),
              ]),
        ),
      ),
    );
  }
}
