import 'package:cloud_firestore/cloud_firestore.dart';

class Selection {
//  const Selection({
//    this.name,
//    this.description,
//    this.url,
//    this.options,
//    this.choices,
//  });

  String name;
  String description;
  String url;
  String docRef;
  Map<String, List<String>> options;
  List<String> choices;
  String specialInstructions;

//
//  factory Selection.fromJson(Map<String, dynamic> json) {
//    return new Selection(
//      name: json['name'],
//      description: json['description'],
//      url: json['url'],
//      options: json['options'][0],
//      choices: null,
//    );
//  }

  Selection(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    url = json['url'];
    specialInstructions = json['specialInstructions'];
    docRef = json['docRef'];

    final Iterable<String> keys = json['options'][0].keys;
    options = new Map<String, List<String>>.fromIterables(keys,
        keys.map((key) => new List<String>.from(json['options'][0][key])));

    choices = [];
    final List<dynamic> list = json['choices'];
    list.forEach((choice) {
      if (choice != 'empty') choices.add(choice);
    });
  }
  Map<String, dynamic> toMap() => {
        'name': this.name,
        'description': this.description,
        'url': this.url,
        'options': this.options,
        'choices': this.choices,
        'specialInstructions': this.specialInstructions,
      };
}

class SubCategory {
  String name;
  List<Selection> selections;

  SubCategory(Map<String, dynamic> json) {
    name = json['subCategory'];
    selections = _buildSelectionList(json['items']);
  }

  List<Selection> _buildSelectionList(List items) {
    List<Selection> sel = [];

    items.forEach((item) {
      sel.add(Selection(item));
    });
    return sel;
  }
}
