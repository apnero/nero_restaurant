import 'package:flutter/material.dart';

typedef void OnFabMiniMenuItemPressed();

class FabMiniMenuItem {
  double elevation;
  String text;
  Icon icon;
  Color fabColor;
  Color chipColor;
  String tooltip;
  Color textColor;
  OnFabMiniMenuItemPressed onPressed;

  FabMiniMenuItem.withText(
      this.icon,
      this.fabColor,
      this.elevation,
      this.tooltip,
      this.onPressed,
      this.text,
      this.chipColor,
      this.textColor);

  FabMiniMenuItem.noText(this.icon,this.fabColor,this.elevation,this.tooltip,this.onPressed){
    this.text = null;
    this.chipColor = null;
    this.textColor = null;
  }

}

class FabMenuMiniItemWidget extends StatelessWidget {
  const FabMenuMiniItemWidget(
      {Key key,
        this.elevation,
        this.text,
        this.icon,
        this.fabColor,
        this.chipColor,
        this.textColor,
        this.tooltip,
        this.index,
        this.controller,
        this.onPressed})
      : super(key: key);
  final double elevation;
  final String text;
  final Icon icon;
  final Color fabColor;
  final Color chipColor;
  final String tooltip;
  final Color textColor;
  final int index;
  final OnFabMiniMenuItemPressed onPressed;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 8.0),
                child: new ScaleTransition(
                    scale: new CurvedAnimation(
                      parent: controller,
                      curve: new Interval(((index + 1) / 10), 1.0,
                          curve: Curves.linear),
                    ),
                    child: chipColor!=null
                        ?new Chip(
                      label: new Text(
                        text,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                            color: textColor, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: chipColor,
                    ):null)),
            new ScaleTransition(
              scale: new CurvedAnimation(
                parent: controller,
                curve:
                new Interval(((index + 1) / 10), 1.0, curve: Curves.linear),
              ),
              child: new FloatingActionButton(
                  elevation: elevation,
                  mini: true,
                  backgroundColor: fabColor,
                  tooltip: tooltip,
                  child: icon,
                  heroTag: "$index",
                  onPressed: onPressed),
            )
          ],
        ));
  }
}


class FabDialer extends StatefulWidget {
  const FabDialer(this._fabMiniMenuItemList, this._fabColor, this._fabIcon);

  final List<FabMiniMenuItem> _fabMiniMenuItemList;
  final Color _fabColor;
  final Icon _fabIcon;

  @override
  FabDialerState createState() =>
      new FabDialerState(_fabMiniMenuItemList, _fabColor, _fabIcon);
}

class FabDialerState extends State<FabDialer> with TickerProviderStateMixin {
  FabDialerState(this._fabMiniMenuItemList, this._fabColor, this._fabIcon);

  int _angle = 90;
  bool _isRotated = true;
  final List<FabMiniMenuItem> _fabMiniMenuItemList;
  final Color _fabColor;
  final Icon _fabIcon;
  List<FabMenuMiniItemWidget> _fabMenuItems;

  AnimationController _controller;

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _controller.reverse();

    setFabMenu(this._fabMiniMenuItemList);
    super.initState();
  }

  void setFabMenu(List<FabMiniMenuItem> fabMenuList) {
    List<FabMenuMiniItemWidget> fabMenuItems = new List();
    for (int i = 0; i < _fabMiniMenuItemList.length; i++) {
      fabMenuItems.add(new FabMenuMiniItemWidget(
        tooltip: _fabMiniMenuItemList[i].tooltip,
        text: _fabMiniMenuItemList[i].text,
        elevation: _fabMiniMenuItemList[i].elevation,
        icon: _fabMiniMenuItemList[i].icon,
        index: i,
        onPressed: _fabMiniMenuItemList[i].onPressed,
        textColor: _fabMiniMenuItemList[i].textColor,
        fabColor: _fabMiniMenuItemList[i].fabColor,
        chipColor: _fabMiniMenuItemList[i].chipColor,
        controller: _controller,
      ));
    }

    this._fabMenuItems = fabMenuItems;
  }

  void _rotate() {
    setState(() {
      if (_isRotated) {
        _angle = 45;
        _isRotated = false;
        _controller.forward();
      } else {
        _angle = 90;
        _isRotated = true;
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _fabMenuItems,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FloatingActionButton(
                    child: new RotationTransition(
                      turns: new AlwaysStoppedAnimation(_angle / 360),
                      child: _fabIcon,
                    ),
                    backgroundColor: _fabColor,
                    onPressed: _rotate)
              ],
            ),
          ],
        ));
  }
}
