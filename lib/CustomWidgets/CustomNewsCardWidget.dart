import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../NoticeReadingPage.dart';

class CustomNewsCardWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NoticeReadingPage()),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Container(
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                newsCardTitle(),
                newsCardImage(),
                newsCardFooter(context)
                ],
              ),
            )
        ),
      ),
    );
  }

  /// News card title
  Widget newsCardTitle(){
    return  Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:16.0),
            child: Icon(Icons.info, color: Colors.grey, size: 21,),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                /// News Heading
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top:8.0, right:16.0),
                  child: Text("Surprize has finally declared its first winner",
                    style: TextStyle(fontFamily: 'Raleway',
                        fontSize: 18, fontWeight: FontWeight.w300),),
                ),

                /// News date
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                  child: Text("12/12/2012", style: TextStyle(fontSize: 12,
                      fontFamily: 'Raleway',
                      color: Colors.grey,
                      fontWeight: FontWeight.w300)),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  /// News card image
  Widget newsCardImage(){
    return  Container(
      height: 170,
      color: Colors.grey[50],
      child: Image.network('http://lorempixel.com/400/200/', height: 160),
    );
  }

  /// News card footer
  Widget newsCardFooter(context){
    return Container(
      color:Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          /// Main news in short view
          Container(
            width:MediaQuery.of(context).size.width*0.6,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                  "We are in the new era of surprize where you can earn loads of money with just a click..",
                 textAlign: TextAlign.left, overflow: TextOverflow.ellipsis,style:
              TextStyle(fontSize: 16, color:Colors.black, fontFamily: 'Raleway',fontWeight: FontWeight.w400, )),
            ),
          ),

          /// Click for more button
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: FlatButton(child: Text("Click for more", style: TextStyle(fontFamily: 'Raleway'))),
          )
        ],
      ),
    );
  }
}