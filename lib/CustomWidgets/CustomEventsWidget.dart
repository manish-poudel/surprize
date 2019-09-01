import 'package:flutter/cupertino.dart';
import 'package:surprize/CustomWidgets/CustomStreamBuilderWidget.dart';

class CustomEventsWidget extends StatefulWidget{
  var _query;
  var _list;
  CustomEventsWidget (this._query, this._list);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomEventWidgetsState();
  }
}

class CustomEventWidgetsState extends State<CustomEventsWidget>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomStreamBuilderWidget(
       widget._query, widget._list);
  }
}