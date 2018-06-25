import 'package:nero_restaurant/model/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  const Category(
      {this.id, this.heading, this.category, this.subCategories, this.url});

  final int id;
  final String heading;
  final String category;
  final List<dynamic> subCategories;
  final String url;

  factory Category.fromDocument(DocumentSnapshot document) {
    return new Category(
        id: document['id'],
        heading: document['heading'],
        category: document['category'],
        subCategories: document['subCategories'],
        url: document['url']);
  }



  static Map<String, List<String>> categoryOrg(List<Category> categories) {
    Map<String, List<String>> map = new Map();

    categories.forEach((category) {
      if (map.containsKey(category.heading) == false) {
        List<String> list = new List();
        list.add(category.category);
        map.addAll({category.heading: list});
      } else
        map[category.heading].add(category.category);
    });
    return map;
  }

  static String categoryUrl(String stringCategory) {
    String url = '';
    globals.allCategories.forEach((category) {
      if (category.category == stringCategory) {
        url = category.url;
      }
    });
    return url;
  }

  static List<String> getSubCategories(String stringCategory) {
    List<String> list = [];

    globals.allCategories.forEach((category) {
      if (category.category == stringCategory) {
        category.subCategories.forEach((subCat) => list.add(subCat.toString()));

      }});
    return list;
  }


  static List<String> getHeadings(){
    Set<String> set = new Set();
    globals.allCategories.forEach((category) => set.add(category.heading));

    return set.toList();
  }

}

