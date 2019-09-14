import 'package:flutter/material.dart';

class CustomExpandableWidget extends StatefulWidget {

  bool initiallyExpanded;
  Function onExpansionChanged;

  Widget title, leading;
  List<Widget> childrenWidgets;

  CustomExpandableWidget({this.initiallyExpanded, this.onExpansionChanged, this.childrenWidgets, this.leading, this.title});

  @override
  _CustomExpandableWidgetState createState() => _CustomExpandableWidgetState();
}

class _CustomExpandableWidgetState extends State<CustomExpandableWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: widget.initiallyExpanded,
      onExpansionChanged: widget.onExpansionChanged,
      children: widget.childrenWidgets,
      leading: widget.leading,
      title: widget.title,
    );
  }
}
