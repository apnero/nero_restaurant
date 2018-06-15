import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:nero_restaurant/model/selection_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nero_restaurant/ui/common/selection_list_item.dart';

List<Selection> favorites = [];

class FavoritesTab extends StatefulWidget {
  @override
  _FavoritesTabState createState() => new _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  @override
  void initState() {
    super.initState();

    Future<List<Selection>> selections = fetchItems();
    selections.then((List<Selection> listS) {
      try {
        setState(() {
          favorites = listS;
        });
      } catch (exception) {
        print('Error setState on FavoritesTab');
      }
    });
  }

  Future<List<Selection>> fetchItems() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    var url =
        "https://us-central1-nero-digital.cloudfunctions.net/favoritesQuery";
    var response;

    try {
      response = await http.post(url, body: {'uid': firebaseUser.uid});

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
    return new CustomScrollView(
      slivers: <Widget>[
        new SliverFixedExtentList(
          itemExtent: 180.0,
          delegate: new SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return new Container(
                alignment: Alignment.center,
//                color: Colors.lightBlue[100 * (index % 9)],
                child: new SelectionListItem(
                    context: context, selection: favorites[index]),
              );
            },
            childCount: favorites.length,
          ),
        ),
      ],
    );
  }
}
