import 'package:flutter/material.dart';
import 'package:nero_restaurant/model/selection_model.dart';
import 'package:nero_restaurant/ui/item_page/item_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nero_restaurant/ui/style.dart';

class HorizontalListItem extends StatelessWidget {
  final BuildContext context;
  final Selection selection;

  // Constructor. {} here denote that they are optional values i.e you can use as: new MyCard()
  HorizontalListItem({@required this.context, @required this.selection});

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
                  builder: (context) => new MyApp(selection: selection),
                ),
              );
            },
            child: new Hero(
                tag: selection.name,
                child: Container(
                    child: new Column(children: <Widget>[
                  new Container(
//                          padding: const EdgeInsets.only(bottom: 20.0),
                      width: 120.0,
                      height: 120.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new CachedNetworkImageProvider(
                                  selection.url)))),
                  new Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    width: 150.0,
                    child:
                            new Text(selection.name, style: subMenuTextLabel, textAlign: TextAlign.center,),
                  )
                ])))));
  }
}
