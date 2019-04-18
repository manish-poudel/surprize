import 'package:flutter/material.dart';

class CustomSliverAppBarWidget extends StatefulWidget{

  final Widget _title;
  final  Widget _background;

   CustomSliverAppBarWidget(this._title, this._background);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomSliverAppBarWidgetState();
  }

}

class CustomSliverAppBarWidgetState extends State<CustomSliverAppBarWidget>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SliverAppBar(
      title: widget._title,
      expandedHeight: 92.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: widget._background,
      ),
    );
  }
}