import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nero_restaurant/ui/submenu_page/submenu_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nero_restaurant/ui/style.dart';

class MenuTab extends StatelessWidget {
  Widget _buildListItem(BuildContext context, DocumentSnapshot document, String group) {
    return new InkWell(
        onTap: () {
//                    final snackBar = new SnackBar(content: new Text("Tap"));
//                    Scaffold.of(context).showSnackBar(snackBar);
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) =>
              new SubMenuPage(category: document['category'], group: group),
            ),
          );
        },
        child: Container(
            padding: const EdgeInsets.all(5.0),
            child: new Column(children: <Widget>[
              new Container(
                  width:  120.0,
                  height: 120.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new CachedNetworkImageProvider(
                              document['url'])))),
              new Text(document['category'], style: menuTextLabel)
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child:
        new Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          new Container(
            padding: const EdgeInsets.all(8.0),
            child: new Text("Drinks", style: menuTextHeading),
          ),
          new Container(
              height: 156.0,
              child: new StreamBuilder(
                  stream: Firestore.instance.collection('DrinkCategories').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text('Loading...');
                    return new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.documents.length,
                      itemExtent: 150.0,
                      itemBuilder: (context, index) =>
                          _buildListItem(context, snapshot.data.documents[index], 'Drinks'),
                    );
                  })),
          new Container(
            padding: const EdgeInsets.all(10.0),
            child: new Text("Food", style: menuTextHeading),
          ),
          new Container(
              height: 160.0,

              child: new StreamBuilder(
                  stream: Firestore.instance.collection('FoodCategories').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text('Loading...');
                    return new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.documents.length,
                      itemExtent: 150.0,
                      itemBuilder: (context, index) =>
                          _buildListItem(context, snapshot.data.documents[index], 'Food'),
                    );
                  }))
        ]));

  }
}
