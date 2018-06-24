import 'package:nero_restaurant/model/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:nero_restaurant/model/selection_model.dart';
import 'package:nero_restaurant/ui/item_page/item_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nero_restaurant/model/item_model.dart';
import 'package:nero_restaurant/services/firebase_calls.dart';
import 'package:nero_restaurant/ui/style.dart';

class SelectionListItem extends StatefulWidget {
  final BuildContext context;
  final Selection selection;
  final bool fromShoppingPage;

  SelectionListItem(
      {@required this.context,
      @required this.selection,
      @required this.fromShoppingPage});
  @override
  _SelectionListItem createState() => new _SelectionListItem();
}

class _SelectionListItem extends State<SelectionListItem> {
  @override
  void initState() {
    super.initState();
  }

  _addToFavorites() {
    if (widget.selection.favorite == false) {
      Scaffold
          .of(context)
          .showSnackBar(new SnackBar(content: new Text("Added to Favorites")));
      widget.selection.favorite = true;
      modifySelection(widget.selection);
    } else {
      Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text("Removed from Favorites")));
      widget.selection.favorite = false;
      modifySelection(widget.selection);
    }

    setState(() {});
  }

  _addToCart() {
    Scaffold
        .of(context)
        .showSnackBar(new SnackBar(content: new Text("Added to Cart")));

    //if already in cart make copy
    if (widget.selection.inCart) {
      widget.selection.favorite = false;
      widget.selection.selectionId = '';
    }

    widget.selection.inCart = true;
    modifySelection(widget.selection);

    setState(() {});
  }

  _removeFromCart() {
    Scaffold
        .of(context)
        .showSnackBar(new SnackBar(content: new Text("Removed From Cart")));
    widget.selection.inCart = false;
    modifySelection(widget.selection);
  }

  List<String> mapToOneList(Map<String, List<String>> map) {
    List<String> newList = [];
    map.forEach((k, v) => newList.addAll(v));
    return newList;
  }

  List<String> _getList(Iterable<List<String>> list) {
    List<String> outputList = [];

    list.forEach((l) => outputList.addAll(l));

    return outputList;
  }

  Widget _actionRow(BuildContext context) {
    return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new InkWell(
              onTap: () {
                _addToFavorites();
              },
              child: widget.selection.favorite == true
                  ? Icon(
                      Icons.favorite,
                      size: 35.0,
                    )
                  : Icon(
                      Icons.favorite_border,
                      size: 35.0,
                    )),
          new InkWell(
              onTap: () {
                _addToCart();
              },
              child: new Icon(
                Icons.add_circle_outline,
                size: 35.0,
              )),
          widget.fromShoppingPage
              ? new InkWell(
                  onTap: () {
                    _removeFromCart();
                  },
                  child: new Icon(
                    Icons.remove_circle_outline,
                    size: 35.0,
                  ))
              : new Container(),
        ]);
  }

  Widget _image(BuildContext context) {
    return new Container(
        width: 80.0,
        height: 80.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: new CachedNetworkImageProvider(
                    getItemFromDocId(widget.selection.itemDocId).url))));
  }

  Widget _title(BuildContext context) {
    return new Padding(
        padding: new EdgeInsets.only(
          bottom: 10.0,
          top: 5.0,
        ),
        child: new Text(
          getItemFromDocId(widget.selection.itemDocId).name,
          style: Theme.of(context).textTheme.headline,
        ));
  }

  Widget _chips(BuildContext context) {
    return new Wrap(
      direction: Axis.horizontal,
      spacing: 5.0, // gap between adjacent chips
      runSpacing: 2.0,
      children: _getList(widget.selection.choices.values)
          .map<Widget>((String choice) {
        return new ChoiceChip(
          backgroundColor: Colors.blue,
          label: new Text(
            choice,
            style: Theme.of(context).textTheme.subhead,
          ),
          selected: false,
          onSelected: (bool selected) => null,
        );
      }).toList(),
    );
  }

  Widget _structure(BuildContext context) {
    return Container(
//        height: 200.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _image(context),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _title(context),
                        Container(
//                          height: 110.0,
                          width: 300.0,
                          child: _chips(context),
                        ),
                      ]),
                ]),
            Container(
              padding: EdgeInsets.only(
                 left: 50.0, right: 20.0,
              ),
              child: _actionRow(context),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    widget.fromShoppingPage
        ? globals.currentCart.add(widget.selection.selectionId)
        : null;
    return Card(
        shape: const RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
          topLeft: const Radius.circular(16.0),
          topRight: const Radius.circular(16.0),
          bottomLeft: const Radius.circular(16.0),
          bottomRight: const Radius.circular(16.0),
        )),
        child: new InkWell(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) =>
                      new ItemPage(selection: widget.selection),
                ),
              );
            },
            child: new Hero(
                tag: widget.selection.hashCode.toString(),
                child: _structure(context))));
  }
}
