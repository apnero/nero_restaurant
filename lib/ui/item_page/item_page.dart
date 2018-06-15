import 'package:flutter/material.dart';
import 'package:nero_restaurant/ui/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nero_restaurant/model/selection_model.dart';
import 'package:nero_restaurant/ui/item_page/chips_tile.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_auth/firebase_auth.dart';

final refFavorites = Firestore.instance.collection('Favorites');
final refCarts = Firestore.instance.collection('Carts');

enum AppBarBehavior { normal, pinned, floating, snapping }

class MyApp extends StatelessWidget {
  MyApp({Key key, @required this.selection}) : super(key: key);
  final Selection selection;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(body: new ItemPage(selection: selection)),
    );
  }
}

class ItemPage extends StatefulWidget {
  ItemPage({Key key, @required this.selection}) : super(key: key);
  final Selection selection;

  @override
  _ItemPageState createState() => new _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();
  BuildContext thisContext;

  final double _appBarHeight = 256.0;
  bool _favorited = false;

  _addToFavorites() {
    if (_favorited == false) {
      Scaffold
          .of(context)
          .showSnackBar(new SnackBar(content: new Text("Added to Favorites")));

      Firestore.instance.runTransaction((transaction) async {
        FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

        final DocumentSnapshot newDoc =
            await transaction.get(refFavorites.document());
        final Map<String, dynamic> data =
            _toMap(widget.selection, firebaseUser, newDoc.documentID);
        await transaction.set(newDoc.reference, data);
      });
    } else
      Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text("Removed from Favorites")));
    setState(() {
      _favorited = !_favorited;
    });
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

//    setState(() {
////      _favorited = !_favorited;
//    });
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
    var _fabMiniMenuItemList = [
      new FabMiniMenuItem.noText(
        new Icon(Icons.favorite_border),
        Colors.cyan,
        4.0,
        "Button menu",
        _addToFavorites,
      ),
      new FabMiniMenuItem.noText(
        new Icon(Icons.add_shopping_cart),
        Colors.cyan,
        4.0,
        "Button menu",
        _addToCart,
      )
    ];

    var _fabMiniMenuItemListFavorite = [
      new FabMiniMenuItem.noText(
        new Icon(Icons.favorite),
        Colors.cyan,
        4.0,
        "Button menu",
        _addToFavorites,
      ),
      new FabMiniMenuItem.noText(
        new Icon(Icons.add_shopping_cart),
        Colors.cyan,
        4.0,
        "Button menu",
        _addToCart,
      )
    ];

    return new Theme(
      data: mainTheme,
      child: new Scaffold(
        body: new Stack(children: <Widget>[
          new CustomScrollView(slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: false,
              flexibleSpace: new FlexibleSpaceBar(
//                title:  Text(itemDoc['name']),
//                centerTitle: true,
                background: new Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    new Hero(
                        tag: widget.selection.name,
                        child: new Container(
                            height: _appBarHeight,
                            decoration: new BoxDecoration(
                                image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image: new CachedNetworkImageProvider(
                                        widget.selection.url))))),

                    // This gradient ensures that the toolbar icons are distinct
                    // against the background image
                    const DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: const LinearGradient(
                          begin: const Alignment(0.0, -1.0),
                          end: const Alignment(0.0, -0.4),
                          colors: const <Color>[
                            const Color(0x60000000),
                            const Color(0x00000000)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            new SliverAppBar(
              title: new Text(widget.selection.name, style: menuTextHeading),
              automaticallyImplyLeading: false,
//              backgroundColor: Colors.blueGrey,
              centerTitle: true,
              pinned: true,
              brightness: Brightness.light,
            ),
            new SliverList(
              delegate: new SliverChildListDelegate(<Widget>[
                new Container(
                    padding: new EdgeInsets.symmetric(horizontal: 20.0),
                    child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Padding(
                            padding: new EdgeInsets.symmetric(vertical: 10.0),
                            child: new Text(widget.selection.description,
                                style: subMenuTextLabel),
                          ),
                        ]))
              ]),
            ),
            widget.selection.options.isNotEmpty == true
                ? new SliverPadding(
                    padding: EdgeInsets.all(20.0),
                    sliver: SliverList(
                        delegate: new SliverChildBuilderDelegate(
                            (BuildContext context, int index) =>
                                widget.selection.options.values.toList()[index]
                                            [0] !=
                                        ''
                                    ? new ChipsTile(
                                        label: widget.selection.options.keys
                                            .toList()[index],
                                        value: widget.selection.options.values
                                            .toList()[index],
                                        choices: widget.selection.choices)
                                    : new Container(),
                            childCount:
                                widget.selection.options.values.length)))
                : new Container(),
          ]),
          _favorited == false
              ? new FabDialer(
                  _fabMiniMenuItemList, Colors.green, new Icon(Icons.add))
              : new Container(),
          _favorited == true
              ? new FabDialer(_fabMiniMenuItemListFavorite, Colors.green,
                  new Icon(Icons.add))
              : new Container(),
        ]),
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
                onPressed: () => Navigator.of(context).pushNamed('/shopping-cart-page'),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
