import 'package:nero_restaurant/model/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:nero_restaurant/model/selection_model.dart';
import 'package:nero_restaurant/ui/loyalty_page/order_structure_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final refSelections = Firestore.instance.collection('Selections');

class LoyaltyCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Loyalty Card'),
        ),
        body: new Center(
            child: new Column(children: <Widget>[
          new QrImage(
            data: globals.currentUser.id,
            size: 280.0,
            backgroundColor: Colors.white,
          ),
          new StreamBuilder(
              stream: refSelections
                  .where('status', isEqualTo: 'working')
                  .where('uid', isEqualTo: globals.currentUser.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return new Text('Loading');
                else if (snapshot.data.documents.length == 0)
                  return Text(
                    'No Current Order',
                    style: Theme.of(context).textTheme.headline,
                  );
                return StructurePage(
                    context: context, selections: snapshot.data.documents.map<Selection>((DocumentSnapshot document) {
                      return Selection.fromSelectionDoc(document);
                }).toList(),);
              })
        ])));
  }
}
