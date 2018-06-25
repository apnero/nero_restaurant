import 'package:flutter/material.dart';

import 'package:nero_restaurant/model/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nero_restaurant/ui/common/horizontal_list_item.dart';
import 'package:nero_restaurant/model/selection_model.dart';
import 'package:nero_restaurant/ui/shopping_cart/shopping_cart_page.dart';
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
      ),);
  }
}
