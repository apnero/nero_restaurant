import 'package:flutter/material.dart';
import 'package:nero_restaurant/ui/order_page/favorites_tab.dart';
import 'package:nero_restaurant/ui/order_page/featured_tab.dart';
import 'package:nero_restaurant/ui/order_page/menu_tab.dart';
import 'package:nero_restaurant/ui/order_page/previous_tab.dart';
import 'package:nero_restaurant/ui/shopping_cart/shopping_cart_page.dart';


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
        floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new ShoppingCartPage(),
              ),
            );
          }, //animate,
          tooltip: 'Toggle',
          child: Icon(Icons.shopping_cart),
        ),
      ),
    );
  }
}
