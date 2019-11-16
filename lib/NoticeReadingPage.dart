import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Models/Notice.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
          key: _scaffoldKey,
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
        newsBody(),
        Container(height: 120)
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
         Text(widget.notice.title, style: TextStyle(color: Colors.black ,fontSize: 24, fontWeight: FontWeight.w400)),
         Padding(
           padding: const EdgeInsets.only(top:2.0),
           child: Text(AppHelper.dateToReadableString(widget.notice.addedTime), style: TextStyle(color: Colors.grey ,fontSize: 12, fontWeight: FontWeight.w400)),
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
                  child: Text(widget.notice.photoDesc, style: TextStyle(color: Colors.black ,fontSize: 14, fontWeight: FontWeight.w300))),
            ),
          ],
        ));
  }

  /// Launch url
  _launchURL() async {
    var url =
        widget.notice.urlRoute;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      AppHelper.showSnackBar("Couldn't launch " + url, _scaffoldKey);
      throw 'Could not launch $url';
    }
  }

  /// News body
  Widget newsBody(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            widget.notice.body,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300, fontSize: 18)),
          widget.notice.urlRoute != null ?Visibility(visible: widget.notice.urlRoute.isNotEmpty || widget.notice.urlRoute != null, child: Center(
            child: FlatButton(child:
            Container(
              padding: EdgeInsets.all(16),
                decoration: new BoxDecoration(
                  color: Colors.grey[100],
                    border: new Border.all(color: Colors.white, width: 1),
                    borderRadius: new BorderRadius.all(Radius.circular(40.0))
                ),
                child: Text(widget.notice.urlRoute,style: TextStyle(color:Colors.blue,decoration: TextDecoration.underline)))
                ,onPressed: () => _launchURL()),
          )):Visibility(visible: false,child: Container(height: 0, width: 0)),
        ],
      ),
    );
  }

}