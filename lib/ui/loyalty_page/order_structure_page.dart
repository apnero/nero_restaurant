import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nero_restaurant/model/selection_model.dart';
import 'package:nero_restaurant/model/item_model.dart';
import 'package:duration/duration.dart';

class StructurePage extends StatefulWidget {
  StructurePage({Key key, this.context, this.selections})
      : super(key: key);
  final BuildContext context;
  final List<Selection> selections;

  @override
  _StructurePageState createState() => new _StructurePageState();
}

class _StructurePageState extends State<StructurePage> {
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = new Timer.periodic(new Duration(seconds: 10), callback);
  }

  void callback(Timer timer) {
    try {
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  List<String> _getList(Iterable<List<String>> list) {
    List<String> outputList = [];

    list.forEach((l) => outputList.addAll(l));

    return outputList;
  }

  Widget _itemList(BuildContext context) {
    return Column(
      children: widget.selections.map<Widget>((Selection selection) {
        return new Container(
            decoration: const BoxDecoration(
              border: const Border(
                  bottom: const BorderSide(
                    width: 1.0,
                    color: Colors.white30, //const Color(0xFFFF000000)),
                  ),
                  top: const BorderSide(
                    width: 1.0,
                    color: Colors.white30, //const Color(0xFFFF000000)),
                  )),
            ),
            padding: EdgeInsets.symmetric(vertical: 4.0,),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      Text(
                        Item.getItemFromDocId(selection.itemDocId).name,
                        style: Theme.of(context).textTheme.title,
                      ),
                      Text(
                        Item
                            .getItemFromDocId(selection.itemDocId)
                            .price
                            .toStringAsFixed(2),
                        style: Theme.of(context).textTheme.subhead,
                      ),
                    ],
                  ),
                  Expanded(
                      child: Center(child: Wrap(
                        spacing: 3.0,
                        runSpacing: 2.0,
                        children: _getList(selection.choices.values)
                            .map<Widget>((String choice) {
                          return new ChoiceChip(
                            backgroundColor: Colors.blue,
                            label: new Text(
                              choice,
                              style: Theme.of(context).textTheme.subhead,
                            ),
                            selected: false,
                            onSelected: (bool selected) => null,
                          );
                        }).toList(),
                      ),
                      ))]));
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: const RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
              topLeft: const Radius.circular(16.0),
              topRight: const Radius.circular(16.0),
              bottomLeft: const Radius.circular(16.0),
              bottomRight: const Radius.circular(16.0),
            )),
        child: Container(
            padding: EdgeInsets.all(4.0),
            decoration:const BoxDecoration(
              color: Colors.black12, //.color,
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(padding: EdgeInsets.symmetric(vertical: 1.0),child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Text(
                          printDuration(
                              DateTime.now().difference(widget.selections[0].date),
                              tersity: DurationTersity.hour),
                          style: Theme.of(context).textTheme.title,
                        ),
                      ])),
                  _itemList(context),
                ])));
  }
}
