import 'package:cloud_firestore/cloud_firestore.dart';

class WebLink {
  const WebLink({
    this.title,
    this.subtitle,
    this.webtitle,
    this.imageUrl,
    this.destUrlOrItemId,
    this.active,
    this.type,
    this.start,
    this.end,
  });

  final String title;
  final String subtitle;
  final String webtitle;
  final String imageUrl;
  final String destUrlOrItemId;
  final bool active;
  final String type;
  final int start;
  final int end;

  factory WebLink.fromDocument(DocumentSnapshot document) {
    return new WebLink(
      title: document['title'],
      subtitle: document['subtitle'],
      webtitle: document['webtitle'],
      imageUrl: document['imageUrl'],
      destUrlOrItemId: document['destUrlOrItemId'],
      active: document['active'],
      type: document['type'],
      start: document['start'],
      end: document['end'],
    );
  }
}
