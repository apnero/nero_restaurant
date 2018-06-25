import 'package:flutter/material.dart';
import 'package:nero_restaurant/ui/submenu_page/submenu_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nero_restaurant/model/globals.dart' as globals;
import 'package:nero_restaurant/model/category_model.dart';

class MenuTab extends StatelessWidget {
  Widget _buildListItem(BuildContext context, String category) {
    return new InkWell(
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new SubMenuPage(category: category),
            ),
          );
        },
        child: Container(
            child: new Row(children: <Widget>[
          new Container(
              width: 110.0,
              height: 110.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new CachedNetworkImageProvider(
                          Category.categoryUrl(category))))),
          new Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: new Text(category, style: Theme.of(context).textTheme.title))
        ])));
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<String>> _categoryOrg = Category.categoryOrg(globals.allCategories);
    List<String> keys = _categoryOrg.keys.toList();
    return new ListView.builder(
      itemBuilder: (context, index) {
        return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(children: <Widget>[
              new Text(keys[index], style: Theme.of(context).textTheme.headline),
              new Column(
                children: _categoryOrg[keys[index]].map((string) {
                  return new Column(
                    children: [
                      new Padding(
                        padding: new EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        child: _buildListItem(context, string),
                      )
                    ],
                  );
                }).toList(),
              ),
            ]));
      },
      itemCount: keys.length,
    );
  }
}
