import 'package:flutter/material.dart';
import 'package:nero_restaurant/model/selection_model.dart';
import 'package:nero_restaurant/ui/item_page/item_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nero_restaurant/model/item_model.dart';


class HorizontalListItem extends StatefulWidget {
  final BuildContext context;
  final Selection selection;

  HorizontalListItem({@required this.context, @required this.selection});
  @override
  _HorizontalListItem createState() => new _HorizontalListItem();
}

class _HorizontalListItem extends State<HorizontalListItem> {
  Item thisItem;


  @override
  void initState() {
    thisItem = ItemMethod.getItemFromDocId(widget.selection.itemDocId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    padding: const EdgeInsets.only(right: 20.0),
                    child: new Column(children: <Widget>[
                      new Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new CachedNetworkImageProvider(
                                      thisItem.url)))),
                      new Container(
                        width: 120.0,
                        padding: const EdgeInsets.only(top: 8.0),
                        child: new Text(
                          thisItem.name,
                          style: Theme.of(context).textTheme.title,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ])))));
  }
}
