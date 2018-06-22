import 'package:nero_restaurant/model/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nero_restaurant/model/item_model.dart';
import 'package:nero_restaurant/model/category_model.dart';
import 'package:nero_restaurant/model/selection_model.dart';
import 'package:nero_restaurant/model/user_model.dart';

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

final refItems = Firestore.instance.collection('Items');
final refCategories = Firestore.instance.collection('Categories');
final refOptions = Firestore.instance.collection('Options');
final refSelections = Firestore.instance.collection('Selections');
final refSent = Firestore.instance.collection('Sent');
final refUsers = Firestore.instance.collection('Users');

Future loadItems() async {
  List<Item> itemList = [];

  await refItems.getDocuments().then((querySnapshot) => querySnapshot.documents
      .forEach((document) => itemList.add(Item.fromDocument(document))));

  globals.allItems = itemList;
  return;
}

Future loadCategories() async {
  List<Category> categoryList = [];

  await refCategories.getDocuments().then((querySnapshot) =>
      querySnapshot.documents.forEach(
          (document) => categoryList.add(Category.fromDocument(document))));

  globals.allCategories = categoryList;
  return;
}

Future loadOptions() async {
  Map<String, dynamic> optionMap = new Map();
  List<dynamic> list;
  Map<String, List<String>> optionStringMap = new Map();

  await refOptions.getDocuments().then((querySnapshot) => querySnapshot
      .documents
      .forEach((document) => optionMap.addAll(document.data)));

  optionMap.forEach((k, v) {
    if(v is List)
      list = v.cast<String>().toList();
    else list.add(v) as String;
    optionStringMap.addAll({k: list});
  });

  globals.allOptions = optionStringMap;
  return;
}

void modifySelection(Selection selection) {
  Firestore.instance.runTransaction((transaction) async {
    selection.date = DateTime.now();

    if (selection.selectionId == '') {
      //new one
      FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
      selection.uid = firebaseUser.uid;
      final DocumentSnapshot newDoc =
          await transaction.get(refSelections.document());
      selection.selectionId = newDoc.reference.documentID;
      await transaction.set(newDoc.reference, selection.toMap());
    } else {
      //modify one
      final DocumentSnapshot existingDoc =
          await transaction.get(refSelections.document(selection.selectionId));
      await transaction.update(existingDoc.reference, selection.toMap());
    }
  });
}

sendOrder() {
  Map<String, dynamic> map = new Map();
  map.addAll({'status': 'working'});
  map.addAll({'date': DateTime.now()});
  map.addAll({'inCart': false});
  Firestore.instance.runTransaction((transaction) async {
    globals.currentCart.forEach((selectionId) {
      refSelections.document(selectionId).updateData(map);
    });

    final DocumentReference document = refSent.document();
    document.setData(<String, dynamic>{
      'uid': globals.currentUser.id,
      'pushToken': globals.currentUser.pushToken
    });
  });
}

String getCurrentUserId() {
  String userId = '';
  Firestore.instance.runTransaction((transaction) async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    userId = firebaseUser.uid;
  });

  return userId;
}

Future saveUser(FirebaseUser firebaseUser, String pushToken) async {
  DocumentSnapshot userRecord;
  if (firebaseUser != null) {
    userRecord = await refUsers.document(firebaseUser.uid).get();

    if (userRecord.data == null) {
      // no user record exists, time to create

      await refUsers.document(firebaseUser.uid).setData({
        "id": firebaseUser.uid,
        "photoUrl": firebaseUser.photoUrl,
        "email": firebaseUser.email,
        "displayName": firebaseUser.displayName,
        "pushToken": pushToken,
        "admin": false,
        "points": 0.0,
      });

      globals.currentUser = User.fromFirebaseUser(firebaseUser);
    } else
      globals.currentUser = User.fromDocument(userRecord);
  }
}
