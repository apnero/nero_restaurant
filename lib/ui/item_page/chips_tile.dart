import 'package:flutter/material.dart';

class ChipsTile extends StatefulWidget {
  ChipsTile(
      {Key key,
      @required this.label,
      @required this.values,
      @required this.choices})
      : super(key: key);

  final List<String> values;
  final Map<String, List<String>> choices;
  final String label;

  @override
  _ChipsTileState createState() => new _ChipsTileState();
}

class _ChipsTileState extends State<ChipsTile> {
  String _chipType;
  String _labelString;

  @override
  void initState() {
    if (widget.label.split != "") {
      _labelString = widget.label.split('-')[0];
      _chipType = widget.label.split('-')[1];
    }
    super.initState();
  }

  void _selected(String choice, bool selected) {
    List<String> list = new List();

    if (selected == true) {
      if (widget.choices.containsKey(widget.label)) if (_chipType == 'one')
        widget.choices.remove(widget.label);
      else if (_chipType == 'many') list.addAll(widget.choices[widget.label]);

      list.add(choice);
      widget.choices.addAll({widget.label: list});
    } else if (widget.choices.containsKey(widget.label) ==
        true) if (_chipType == 'one')
      widget.choices.remove(widget.label);
    else if (_chipType == 'many') {
      list = widget.choices[widget.label];
      list.remove(choice);
      widget.choices.addAll({widget.label: list});
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
//      mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(_labelString.toUpperCase()),
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
                      label: new Text(widget.values[index]),
                      selected: (widget.choices.containsKey(widget.label) &&
                          widget.choices[widget.label]
                              .contains(widget.values[index])),
                      onSelected: (bool selected) {
                        _selected(widget.values[index], selected);
                      },
                    )),
                itemCount: widget.values.length,
              )),
          new Divider(),
        ]);
  }
}
