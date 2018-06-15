import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:nero_restaurant/model/selection_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nero_restaurant/ui/common/selection_list_item.dart';

List<Selection> itemsInCart = [];

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => new _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  @override
  void initState() {
    super.initState();

    Future<List<Selection>> selections = fetchItems();
    selections.then((List<Selection> listS) {
      try {
        setState(() {
          itemsInCart = listS;
        });
      } catch (exception) {
        print('Error setState on ShoppingCartPage');
      }
    });
  }

  Future<List<Selection>> fetchItems() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    var url =
        "https://us-central1-nero-digital.cloudfunctions.net/shoppingCartQuery";
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

  void _showSnackBar(){
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Order Has Been Sent")));

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
          pinned: true,
          expandedHeight: 50.0,
          flexibleSpace: const FlexibleSpaceBar(
            title: const Text('Shopping Cart'),
          ),
        ),
        new SliverFixedExtentList(
          itemExtent: 180.0,
          delegate: new SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return new Container(
                alignment: Alignment.center,
//                color: Colors.lightBlue[100 * (index % 9)],
                child: new SelectionListItem(
                    context: context, selection: itemsInCart[index]),
              );
            },
            childCount: itemsInCart.length,
          ),
        ),

      ],
    ),floatingActionButton: new FloatingActionButton.extended(
        key: new ValueKey<Key>(new Key('1')),
        tooltip: 'Show your loyalty card to the staff.',
        backgroundColor: Colors.blue,
        icon: new Icon(Icons.message), //page.fabIcon,
        label: Text('Send Order'),
        onPressed: () => _showSnackBar()));
  }
}
