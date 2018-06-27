import 'package:nero_restaurant/model/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nero_restaurant/model/selection_model.dart';
import 'package:nero_restaurant/ui/common/selection_list_item.dart';

final refSelections = Firestore.instance.collection('Selections');

class PreviousTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: refSelections.where('status', isEqualTo: 'complete').where('uid', isEqualTo: globals.currentUser.id)
            .limit(5).orderBy('date').snapshots(),
builder: (context, snapshot) {
if (!snapshot.hasData)
return new Text('Loading');
else if (snapshot.data.documents.length == 0)
return new Center(
child: Image.asset(
'assets/images/empty-previous.png',
width: 255.0,
fit: BoxFit.fitHeight,
));
return new ListView.builder(
itemCount: snapshot.data.documents.length,
padding: const EdgeInsets.only(bottom: 2.0, top: 8.0),
itemBuilder: (context, index) => new SelectionListItem(
context: context,
selection: Selection
    .fromSelectionDoc(snapshot.data.documents[index]),
fromShoppingPage: false,
));
});
}
}
