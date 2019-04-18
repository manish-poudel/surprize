
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomStreamBuilderWidget extends StatelessWidget{

  Stream<QuerySnapshot> _querySnapshot;
  Function _listview;

  CustomStreamBuilderWidget(this._querySnapshot, this._listview);

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      stream: _querySnapshot,
      builder: (BuildContext context, snapshot){

        if(!snapshot.hasData) return CircularProgressIndicator();
        if(snapshot.hasError) return new Text('Error occured');
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());

          case(ConnectionState.active):
            return _listview(snapshot);
          default:
        }
      },
    );
  }

}