import 'package:flutter/material.dart';

class ChipsTile extends StatefulWidget {
  ChipsTile(
      {Key key,
      @required this.label,
      @required this.value,
      @required this.choices})
      : super(key: key);

  final List<String> value;
  final List<String> choices;
  final String label;

  @override
  _ChipsTileState createState() => new _ChipsTileState();
}

class _ChipsTileState extends State<ChipsTile> {

  void _selected(String choice, bool selected){

    String chipType = widget.label.split('_')[1];

    widget.value.forEach((value) {
      if (chipType == 'one') widget.choices.remove(value);
    });
    setState((){
      if (selected) widget.choices.add(choice);
      else widget.choices.remove(choice);
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Column(
//      mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(widget.label.split('_')[0].toUpperCase()),
          new Container(
              height: 40.0,
              child: new ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding:
                    new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                itemBuilder: (context, index) => new Padding(
                    padding: new EdgeInsets.symmetric(horizontal: 5.0),
                    child: FilterChip(
                      labelPadding: new EdgeInsets.symmetric(horizontal: 5.0),
                      backgroundColor: Colors.blue,
                      selectedColor: Colors.red,
                      label: new Text(widget.value[index]),
                      selected:
                          widget.choices.indexOf(widget.value[index]) != -1,
                      onSelected: (bool selected) {
                        _selected(widget.value[index],selected);
                      },

                    )),
                itemCount: widget.value.length,
              )),
          new Divider(),
        ]);
  }
}
