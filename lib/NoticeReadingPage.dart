import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Models/Notice.dart';
import 'package:flutter/material.dart';

class NoticeReadingPage extends StatefulWidget{

  Notice notice;
  NoticeReadingPage(this.notice);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoticeReadingPageState();
  }
}

class NoticeReadingPageState extends State<NoticeReadingPage>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
            appBar:  CustomAppBar("Notice",context),
          body:SingleChildScrollView(child: newsContent())
        ));
  }

  /// News content
  Widget newsContent(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        newsTitle(),
        Visibility(visible: widget.notice.photoUrl != null, child: Center(child: newsImage())),
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
         Text(widget.notice.title, style: TextStyle(color: Colors.black, fontFamily: 'Raleway' ,fontSize: 24, fontWeight: FontWeight.w500)),
         Padding(
           padding: const EdgeInsets.only(top:2.0),
           child: Text(AppHelper.dateToReadableString(widget.notice.addedTime), style: TextStyle(color: Colors.grey, fontFamily: 'Raleway' ,fontSize: 12, fontWeight: FontWeight.w500)),
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
            Image.network(widget.notice.photoUrl, height: 200),
            Visibility(visible: widget.notice.photoDesc.isNotEmpty || widget.notice.photoDesc != null,
              child: Container(
                  height: 20,
                  child: Text(widget.notice.photoDesc, style: TextStyle(color: Colors.black, fontFamily: 'Raleway' ,fontSize: 14, fontWeight: FontWeight.w300))),
            ),
          ],
        ));
  }

  /// News body
  Widget newsBody(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        widget.notice.body,style: TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }

}