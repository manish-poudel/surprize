import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNavigationDrawerWidget extends StatefulWidget{

  final Widget _drawerContent;

  CustomNavigationDrawerWidget(this._drawerContent);

  @override
  State<StatefulWidget> createState() {
    return CustomNavigationDrawerWidgetState();
  }
}

class CustomNavigationDrawerWidgetState extends State<CustomNavigationDrawerWidget>{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: widget._drawerContent,
    );
  }
}

