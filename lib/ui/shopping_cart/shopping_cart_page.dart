import 'package:nero_restaurant/model/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nero_restaurant/model/selection_model.dart';
import 'package:nero_restaurant/ui/common/selection_list_item.dart';
import 'package:nero_restaurant/services/firebase_calls.dart';
import 'package:nero_restaurant/ui/home_page/home_page.dart';
import 'package:nero_restaurant/model/selection_price_model.dart';
import 'package:nero_restaurant/model/item_model.dart';
import 'package:nero_restaurant/ui/common/pricing_item.dart';

final refSelections = Firestore.instance.collection('Selections');


class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => new _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {



  _messageDialog(BuildContext context) {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Order Has Been Sent'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('You are all done.'),
                new Text('Thank you.'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new HomePage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  _confirmationDialog(BuildContext context) {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Send In Order'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Are You Ready to Send in the Order?'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text('Yes'),
              onPressed: () {
                FirebaseCalls.sendOrder();
                Navigator.pop(context);
                _messageDialog(context);
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
//    globals.currentCart.clear();
    return new Scaffold(
        appBar: new AppBar(title: new Text('Shopping Cart')),
        body: new StreamBuilder(
            stream: refSelections
                .where('inCart', isEqualTo: true)
                .where('uid', isEqualTo: globals.currentUser.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return new Text('Loading');
              else if (snapshot.data.documents.length == 0)
                return new Center(
                    child: Image.asset(
                  'assets/images/empty-cart.png',
                  width: 255.0,
                  fit: BoxFit.fitHeight,
                ));
              return Column(children: <Widget>[
                Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        padding: const EdgeInsets.only(bottom: 2.0, top: 8.0),
                        itemBuilder: (context, index) => new SelectionListItem(
                              context: context,
                              selection: Selection.fromSelectionDoc(
                                  snapshot.data.documents[index]),
                              fromShoppingPage: true,
                            ))),
               PricingItem(context: context, selectionPriceList: snapshot.data.documents.map<SelectionPrice>((DocumentSnapshot snapshot) {
                  return SelectionPrice.from(snapshot['selectionId'], Item.getItemFromDocId(snapshot['itemDocId']).price);},
              ).toList())]);
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: new Builder(builder: (BuildContext context) {
          return new FloatingActionButton(
              key: new ValueKey<Key>(new Key('1')),
              tooltip: 'Check-Out.',
              backgroundColor: Colors.green,
              child: new Icon(Icons.send),
              onPressed: () {
                _confirmationDialog(context);
              });
        }));
  }
}
