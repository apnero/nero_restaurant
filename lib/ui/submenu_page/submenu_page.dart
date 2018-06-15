import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:nero_restaurant/model/selection_model.dart';
import 'package:nero_restaurant/ui/item_page/item_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nero_restaurant/ui/common/horizontal_list_item.dart';
import 'package:nero_restaurant/ui/style.dart';


Future<List<SubCategory>> listSub;
List<SubCategory> myList = [];

class SubMenuPage extends StatefulWidget {
  @override
  _SubMenuPageState createState() => new _SubMenuPageState();

  SubMenuPage({Key key, @required this.category, @required this.group})
      : super(key: key);
  final String group;
  final String category;
}

class _SubMenuPageState extends State<SubMenuPage> {
  @override
  void initState() {
    super.initState();
    Future<List<SubCategory>> listSub = fetchItems();
    listSub.then((List<SubCategory> listS) {
      myList = listS;
      setState(() {});
    });
  }

  Future<List<SubCategory>> fetchItems() async {
    var url =
        "https://us-central1-nero-digital.cloudfunctions.net/subMenuQuery";
    var response;

    try {
      response = await http.post(url,
          body: {"collection": widget.group, "category": widget.category});

      if (response.statusCode != HttpStatus.OK) {
        response = 'Error getting a feed:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      response = 'Failed invoking the getFeed function. Exception: $exception';
    }

    final responseJson = json.decode(response.body);
    print('JSON: ' + responseJson.toString());

    return buildCategories(responseJson);
  }

  List<SubCategory> buildCategories(List<dynamic> json) {
    List<SubCategory> list = [];

    json.forEach((item) => list.add(SubCategory(item)));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    int onCat = -1;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.category),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          onCat++;
          return Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10.0),
            child: myList.isEmpty == true
                ? new Center(child: new CircularProgressIndicator())
                : new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        myList[index].name,
                        style: menuTextHeading,
                      ),
                      new Container(
                        height: 190.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => new HorizontalListItem(
                              context: context, selection: myList[onCat].selections[index]),
                          itemCount: myList[onCat].selections.length,
                          shrinkWrap:
                              true, // todo comment this out and check the result
                          physics:
                              ClampingScrollPhysics(), // todo comment this out and check the result
                        ),
                      ),
                      new Divider(height: 20.0, color: Colors.black54),
                    ],
                  ),
          );
        },
        itemCount: myList.length,
      ),
    );
  }
}
