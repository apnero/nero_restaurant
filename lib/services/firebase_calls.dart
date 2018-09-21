import 'package:nero_restaurant/model/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nero_restaurant/model/item_model.dart';
import 'package:nero_restaurant/model/category_model.dart';
import 'package:nero_restaurant/model/selection_model.dart';
import 'package:nero_restaurant/model/user_model.dart';

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nero_restaurant/model/web_link_model.dart';

class FirebaseCalls {
  static Future loadItems() async {
    final refItems = Firestore.instance.collection('Items');
    List<Item> itemList = [];

    await refItems.getDocuments().then((querySnapshot) => querySnapshot
        .documents
        .forEach((document) => itemList.add(Item.fromDocument(document))));

    globals.allItems = itemList;
    return;
  }

  static Future loadCategories() async {
    final refCategories = Firestore.instance.collection('Categories');
    List<Category> categoryList = [];

    await refCategories.getDocuments().then((querySnapshot) =>
        querySnapshot.documents.forEach(
            (document) => categoryList.add(Category.fromDocument(document))));

    globals.allCategories = categoryList;
    return;
  }

  static Future loadOptions() async {
    final refOptions = Firestore.instance.collection('Options');
    Map<String, dynamic> optionMap = new Map();
    List<dynamic> list;
    Map<String, List<String>> optionStringMap = new Map();

    await refOptions.getDocuments().then((querySnapshot) => querySnapshot
        .documents
        .forEach((document) => optionMap.addAll(document.data)));

    optionMap.forEach((k, v) {
      if (v is List)
        list = v.cast<String>().toList();
      else
        list.add(v) as String;
      optionStringMap.addAll({k: list});
    });

    globals.allOptions = optionStringMap;
    return;
  }

  static Future loadWebLinks() async {
    final refWebLinks = Firestore.instance.collection('WebLinks');
    List<WebLink> webLinkList = [];

    await refWebLinks.where('active', isEqualTo: true).getDocuments().then(
        (querySnapshot) => querySnapshot.documents.forEach(
            (document) => webLinkList.add(WebLink.fromDocument(document))));

    List<WebLink> removeList = [];
    removeList.addAll(webLinkList);
    removeList.forEach((webLink) {
      if (DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day, webLink.start, 0)
              .isAfter(DateTime.now()) ||
          DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day, webLink.end, 0)
              .isBefore(DateTime.now())) webLinkList.remove(webLink);
    });

    globals.webLinks = webLinkList;
    return;
  }

  static void modifySelection(Selection selection) {
    final refSelections = Firestore.instance.collection('Selections');
    print("i am here flutter me up");

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
        final DocumentSnapshot existingDoc = await transaction
            .get(refSelections.document(selection.selectionId));
        await transaction.update(existingDoc.reference, selection.toMap());
      }
    });
  }

  static void sendOrder() {
    final refSelections = Firestore.instance.collection('Selections');
    final refSent = Firestore.instance.collection('Sent');

    Map<String, dynamic> map = new Map();
    map.addAll({'status': 'working'});
    map.addAll({'date': DateTime.now()});
    map.addAll({'inCart': false});
    Firestore.instance.runTransaction((transaction) async {
      FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

      await refSelections
          .where('inCart', isEqualTo: true)
          .where('uid', isEqualTo: firebaseUser.uid)
          .getDocuments()
          .then((querySnapshot) => querySnapshot.documents.forEach((document) =>
              refSelections.document(document.documentID).updateData(map)));

//      globals.currentCart.forEach((selectionPrice) {
//        refSelections.document(selectionPrice.selectionId).updateData(map);
//      });

      final DocumentReference document = refSent.document();
      document.setData(<String, dynamic>{
        'name': globals.currentUser.displayName,
        'pushToken': globals.currentUser.pushToken
      });
    });
  }

  static String getCurrentUserId() {
    String userId = '';
    Firestore.instance.runTransaction((transaction) async {
      FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
      userId = firebaseUser.uid;
    });

    return userId;
  }

  static Future saveUser(FirebaseUser firebaseUser, String pushToken) async {
    final refUsers = Firestore.instance.collection('Users');
    DocumentSnapshot userRecord;

    if (firebaseUser != null) {
      userRecord = await refUsers.document(firebaseUser.uid).get();

      if (userRecord.data == null) {
        // no user record exists, time to create
        List<dynamic> list = [];
        if (pushToken != null || pushToken != '') list.add(pushToken);
        await refUsers.document(firebaseUser.uid).setData({
          "id": firebaseUser.uid,
          "photoUrl":
              firebaseUser.photoUrl != null ? firebaseUser.photoUrl : '',
          "email": firebaseUser.email != null ? firebaseUser.email : '',
          "displayName":
              firebaseUser.displayName != null ? firebaseUser.displayName : '',
          "pushToken": list,
          "admin": false,
          "points": 0.0,
        });

        globals.currentUser = User.fromFirebaseUser(firebaseUser, [pushToken]);
      } else if (!userRecord.data['pushToken'].contains(pushToken) &&
          pushToken != null &&
          pushToken != '') {
        List<dynamic> list = [];

        globals.currentUser = User.fromDocument(userRecord);
        list.addAll(userRecord.data['pushToken']);
        list.add(pushToken);
        await refUsers
            .document(firebaseUser.uid)
            .updateData({'pushToken': list});
      } else
        globals.currentUser = User.fromDocument(userRecord);
    }
  }



  static Future<Map<String,double>> getCost() async {
    final refSelections = Firestore.instance.collection('Selections');
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    Map<String,double> map = new Map();

    double sentPrice = 0.0;
    double cartPrice = 0.0;

    await refSelections
//        .where('status', isEqualTo: 'working')
        .where('uid', isEqualTo: firebaseUser.uid)
        .getDocuments()
        .then((querySnapshot) => querySnapshot.documents.forEach((document) {
        if(document['inCart'] == true)
          cartPrice+= Item.getItemFromDocId(document['itemDocId']).price;
        if(document['status'] == 'working')
          sentPrice+= Item.getItemFromDocId(document['itemDocId']).price;


    }));

    map.addAll({'sentPrice':sentPrice});
    map.addAll({'cartPrice': cartPrice});
    return map;
  }
}
