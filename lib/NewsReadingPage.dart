import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:surprize/Memory/UserMemory.dart';
import 'package:surprize/Resources/FirestoreResources.dart';

class NewsReadingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewsReadingPageState();
  }
}

class NewsReadingPageState extends State<NewsReadingPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                child: Icon(Icons.arrow_back, color: Colors.white),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text("News"),
            ),
          body:SingleChildScrollView(child: newsContent())
        ));
  }

  /// News content
  Widget newsContent(){
    return Container(
      child: Column(children: <Widget>[
        newsTitle(),
        newsImage(),
        newsBody()
      ],),
    );
  }

  /// Title of news
  Widget newsTitle(){
   return Padding(
     padding: const EdgeInsets.all(16.0),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: <Widget>[
         Text("Surprize has finally declared its first winner", style: TextStyle(color: Colors.black, fontFamily: 'Roboto' ,fontSize: 24, fontWeight: FontWeight.w500)),
         Padding(
           padding: const EdgeInsets.only(top:2.0),
           child: Text("12/1/2019", style: TextStyle(color: Colors.grey, fontFamily: 'Roboto' ,fontSize: 12, fontWeight: FontWeight.w500)),
         )
       ],
     ),
   );
  }

  /// News image
  Widget newsImage(){
    return Container(
        child: Column(
          children: <Widget>[
            Image.network('http://lorempixel.com/400/200/', height: 200),
            Container(
                height: 20,
                child: Text("Image short description here", style: TextStyle(color: Colors.black, fontFamily: 'Roboto' ,fontSize: 14, fontWeight: FontWeight.w300))),
          ],
        ));
  }

  /// News body
  Widget newsBody(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Html(
        data: "test data"
      ),
    );
  }

}