import 'package:flutter/material.dart';
import 'package:nero_restaurant/model/selection_model.dart';
import 'package:nero_restaurant/ui/item_page/item_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nero_restaurant/ui/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


final refFavorites = Firestore.instance.collection('Favorites');
final refCarts = Firestore.instance.collection('Carts');

class SelectionListItem extends StatefulWidget {
  final BuildContext context;
  final Selection selection;

  SelectionListItem({@required this.context, @required this.selection});
  @override
  _SelectionListItem createState() => new _SelectionListItem();
}

class _SelectionListItem extends State<SelectionListItem> {
  bool _isFavorite = true;

  void _removeFromFavorites() {
    if (_isFavorite == true) {
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot favoriteRecord =
            await refFavorites.document(widget.selection.docRef).get();
        await transaction.delete(favoriteRecord.reference);
      });
    }

    try {
      setState(() {
        setState(() {
          _isFavorite = false;
        });
      });
    } catch (exception) {
      print('Error setState on Selection List');
    }

    Scaffold
        .of(context)
        .showSnackBar(new SnackBar(content: new Text("Removed from Favorites")));
  }

  _addToCart() {

      Scaffold
          .of(context)
          .showSnackBar(new SnackBar(content: new Text("Added to Cart")));

      Firestore.instance.runTransaction((transaction) async {
        FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

        final DocumentSnapshot newDoc =
        await transaction.get(refCarts.document());
        final Map<String, dynamic> data =
        _toMap(widget.selection, firebaseUser, newDoc.documentID);
        await transaction.set(newDoc.reference, data);
      });

    setState(() {
//      _favorited = !_favorited;
    });
  }

  Map<String, dynamic> _toMap(
      Selection item, FirebaseUser user, String docRef) {
    final Map<String, dynamic> result = {};

    result.addAll(item.toMap());
    result['uid'] = user.uid;
    result['docRef'] = docRef;
    result['status'] = "Pending";
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 6.0,
          vertical: 3.0,
        ),
        child: new InkWell(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new MyApp(selection: widget.selection),
                ),
              );
            },
            child: new Hero(
                tag: widget.selection.name,
                child: Container(
                    child: new Column(children: <Widget>[
                  new Row(children: <Widget>[
                    new Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new CachedNetworkImageProvider(
                                    widget.selection.url)))),
                    new Container(
                        height: 120.0,
                        padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                        child: new Row(children: <Widget>[
                          new Padding(
                              padding:
                                  new EdgeInsets.only(left: 7.0, right: 20.0),
                              child: new Text(widget.selection.name)),
                          new Column(
                            children:
                                widget.selection.choices.map((String string) {
                              return new Wrap(
                                children: [
                                  new Padding(
                                    padding:
                                        new EdgeInsets.symmetric(vertical: 3.0),
                                    child: new FilterChip(
                                      labelPadding: new EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      backgroundColor: Colors.lightGreenAccent,
                                      onSelected: null,
                                      selectedColor: Colors.blue,
                                      label: new Text(string),
                                      selected: true,
                                    ),
                                  )
                                ],
                              );
                            }).toList(),
                          )
                        ])),
                  ]),
                  new Container(
                      padding: EdgeInsets.only(
                        left: 150.0,
                      ),
                      child: new Row(children: <Widget>[
                        new InkWell(
                            onTap: () {
                              _removeFromFavorites();
                            },
                            child: _isFavorite == true
                                ? Icon(Icons.favorite)
                                : Icon(Icons.favorite_border)),
                        new InkWell(
                            onTap: () {_addToCart();},
                            child: new Icon(Icons.add_circle_outline)),
                      ])),
                  new Divider(height: 25.0),
                ])))));
  }
}
