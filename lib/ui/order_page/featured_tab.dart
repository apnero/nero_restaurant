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

List<Selection> featuredDrinks = [];
List<Selection> featuredFoods= [];
class FeaturedTab extends StatefulWidget {
  @override
  _FeaturedTabState createState() => new _FeaturedTabState();
}

class _FeaturedTabState extends State<FeaturedTab> {
  @override
  void initState() {
    super.initState();
    Future<List<Selection>> drinkSelections = fetchItems('Drinks');
    Future<List<Selection>> foodSelections = fetchItems('Food');

    drinkSelections.then((List<Selection> listS) {
      try {
        setState(() {
          featuredDrinks = listS;
        });
      } catch (exception) {
        print('Error setState on FeaturedTab Drinks');
      }
    });

    foodSelections.then((List<Selection> listS) {
      try {
        setState(() {
          featuredFoods = listS;
        });
      } catch (exception) {
        print('Error setState on FeaturedTab Foods');
      }
    });
  }



  Future<List<Selection>> fetchItems(String collection) async {
    var url =
        "https://us-central1-nero-digital.cloudfunctions.net/featuredQuery";
    var response;

    try {
      response = await http.post(url, body: {"collection": collection});

      if (response.statusCode != HttpStatus.OK) {
        response = 'Error getting a feed:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      response = 'Failed invoking the getFeed function. Exception: $exception';
    }

    final responseJson = json.decode(response.body);
    print('JSON: ' + responseJson.toString());

    return buildSelectionLists(responseJson);
  }

  List<Selection> buildSelectionLists(List<dynamic> json) {
    List<Selection> list = [];

    json.forEach((item) => list.add(new Selection(item)));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, top: 8.0),
      child: (featuredDrinks.isEmpty == true && featuredFoods.isEmpty == true)
          ? new Center(child: new CircularProgressIndicator())
          : new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            'Featured Drinks',
            style: menuTextHeading,
          ),
          new Container(
            height: 182.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => new HorizontalListItem(
                  context: context, selection: featuredDrinks[index]),
              itemCount: featuredDrinks.length,
              shrinkWrap:
              true, // todo comment this out and check the result
              physics:
              ClampingScrollPhysics(), // todo comment this out and check the result
            ),
          ),
          new Divider(height: 10.0, color: Colors.black54),
          new Container(
            height: 182.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => new HorizontalListItem(
                  context: context, selection: featuredFoods[index]),
              itemCount: featuredFoods.length,
              shrinkWrap:
              true, // todo comment this out and check the result
              physics:
              ClampingScrollPhysics(), // todo comment this out and check the result
            ),
          ),
        ],
      ),
    );
  }
}
