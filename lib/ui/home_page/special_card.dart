import 'package:flutter/material.dart';
import 'package:nero_restaurant/ui/item_page/item_page.dart';
import 'package:nero_restaurant/model/selection_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nero_restaurant/model/item_model.dart';
import 'package:nero_restaurant/model/globals.dart' as globals;

class SpecialCard extends StatelessWidget {
  SpecialCard({Key key, @required this.selection}) : super(key: key);
  final Selection selection;

  @override
  Widget build(BuildContext context) {
    return globals.allItems != null
        ? new Card(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Hero(
                    tag: selection.hashCode.toString(),
                    child: new Container(
                        height: 256.0,
                        decoration: new BoxDecoration(
                            image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: new CachedNetworkImageProvider(
                                    getItemFromDocId(selection.itemDocId)
                                        .url))))),
                const ListTile(
                  leading: const Icon(Icons.face),
                  title: const Text('Our Famous Turkey Sandwich'),
                  subtitle: const Text('Check it our this week!'),
                ),
                new ButtonTheme.bar(
                  // make buttons use the appropriate styles for cards
                  child: new ButtonBar(
                    children: <Widget>[
                      new RaisedButton(
                        color: Colors.white,
                        child: const Text('See Special'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) =>
                                  new ItemPage(selection: selection),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : new Container();
  }
}
