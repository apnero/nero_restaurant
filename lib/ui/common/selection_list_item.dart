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

  @override
  Widget build(BuildContext context) {
    widget.fromShoppingPage ? globals.currentCart.add(widget.selection.selectionId):null;
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
                  builder: (context) => new ItemPage(selection: widget.selection),
                ),
              );
            },
            child: new Hero(
                tag: widget.selection.hashCode.toString(),
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: new Column(children: <Widget>[
                      new Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[

                        new Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new CachedNetworkImageProvider(
                                        getItemFromDocId(
                                                widget.selection.itemDocId)
                                            .url)))),
                        new Container(
                            height: 120.0,
                            padding:
                                const EdgeInsets.only(top: 5.0),
                            child: new Row(children: <Widget>[
                              new Padding(
                                  padding: new EdgeInsets.only(
                                      left: 7.0, right: 20.0),
                                  child: new Text(getItemFromDocId(
                                          widget.selection.itemDocId)
                                      .name)),
                              new Column(
                                children: mapToOneList(widget.selection.choices)
                                    .map((String string) {
                                  return new Wrap(
                                    children: [
                                      new Padding(
                                        padding: new EdgeInsets.symmetric(
                                            vertical: 3.0),
                                        child: new FilterChip(
                                          labelPadding:
                                              new EdgeInsets.symmetric(
                                                  horizontal: 5.0),
                                          backgroundColor:
                                              Colors.lightGreenAccent,
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
                            left: 140.0,
                          ),
                          child: new Row(children: <Widget>[
                            new InkWell(
                                onTap: () {
                                  _addToFavorites();
                                },
                                child: widget.selection.favorite == true
                                    ? Icon(Icons.favorite,size:40.0,)
                                    : Icon(Icons.favorite_border,size:40.0,)),
                            new InkWell(
                                onTap: () {
                                  _addToCart();
                                },
                                child: new Icon(Icons.add_circle_outline,size:40.0,)),
                            widget.fromShoppingPage
                                ? new InkWell(
                                    onTap: () {
                                      _removeFromCart();
                                    },
                                    child:
                                        new Icon(Icons.remove_circle_outline,size:40.0,))
                                : new Container(),
                          ])),
                    ])))));
  }
}
