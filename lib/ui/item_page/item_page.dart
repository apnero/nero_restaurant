import 'package:flutter/material.dart';
import 'package:nero_restaurant/ui/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nero_restaurant/model/selection_model.dart';
import 'package:nero_restaurant/ui/item_page/chips_tile.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';
import 'package:nero_restaurant/model/item_model.dart';
import 'package:nero_restaurant/model/options_model.dart';
import 'package:nero_restaurant/services/firebase_calls.dart';
import 'package:nero_restaurant/ui/shopping_cart/shopping_cart_page.dart';
import 'package:nero_restaurant/ui/item_page/animated_fab.dart';
import 'package:nero_restaurant/ui/item_page/diagonal_clipper.dart';

//class ItemPage extends StatelessWidget {
//  ItemPage({Key key, @required this.selection}) : super(key: key);
//  final Selection selection;
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      body: new ItemPage(selection: selection),
//    );
//  }
//}
class ItemPage extends StatefulWidget {
  ItemPage({Key key, @required this.selection}) : super(key: key);
  final Selection selection;

  @override
  _ItemPageState createState() => new _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final double _imageHeight = 256.0;
  Item thisItem;
  Map<String, List<String>> thisItemOptions;
  String uid = '';

  @override
  void initState() {
    thisItem = getItemFromDocId(widget.selection.itemDocId);
    thisItemOptions = getOptionsForThisItem(thisItem.options);
    uid = getCurrentUserId();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          _buildImage(),
          _buildFab(),
        ],
      ),
    );
  }

  Widget _buildFab() {
    return new Positioned(
        top: _imageHeight - 100.0,
        right: -40.0,
        child: new AnimatedFab(selection: widget.selection,
//          onClick: _changeFilterState,
        ));
  }


  Widget _buildImage() {
    return new Positioned.fill(
      bottom: null,
      child: new ClipPath(
        clipper: new DialogonalClipper(),
        child: new Hero(
            tag: widget.selection.hashCode.toString(),
            child: new Container(
                height: 256.0,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: new CachedNetworkImageProvider(
                            thisItem.url))))),
      ),
    );
  }

}
