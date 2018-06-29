import 'package:flutter/material.dart';

import 'package:nero_restaurant/model/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nero_restaurant/ui/common/horizontal_list_item.dart';
import 'package:nero_restaurant/model/selection_model.dart';
import 'package:nero_restaurant/services/firebase_calls.dart';
final refItems = Firestore.instance.collection('Items');

class SubMenuPage extends StatelessWidget {
  SubMenuPage({Key key, @required this.category}) : super(key: key);
  final String category;

  @override
  Widget build(BuildContext context) {
    List<String> _subCategories = Category.getSubCategories(category);
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(category),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.restaurant_menu),
              tooltip: 'Menu',
              onPressed: () => Navigator.pushNamed(context, "/main_order_page"),
            ),
            new IconButton(
              icon: new Icon(Icons.shopping_cart),
              tooltip: 'Shopping Cart',
              onPressed: () => Navigator.pushNamed(context, "/shopping_cart_page"),
            ),
            new IconButton(
              icon: new Icon(Icons.card_membership),
              tooltip: 'Loyalty Card',
              onPressed: () => Navigator.pushNamed(context, "/loyalty_card_page"),
            ),
          ],
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Column(children: <Widget>[
                  new Text(_subCategories[index], style: Theme.of(context).textTheme.headline),
                  new Container(
                    height: 200.0,
                    child: new StreamBuilder(
                        stream: refItems
                            .where('subCategory',
                                isEqualTo: _subCategories[index])
                            .where('active', isEqualTo: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return const Text('Loading...');
                          return new ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.documents.length,
                            padding:
                                const EdgeInsets.only(bottom: 2.0, top: 8.0),
                            itemBuilder: (context, index) =>
                                new HorizontalListItem(
                                    context: context,
                          selection: Selection.fromItemDoc(snapshot.data.documents[index])),
                          );
                        }),
                  ),
                ]));
          },
          itemCount: _subCategories.length,
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
            }),);
  }
}
