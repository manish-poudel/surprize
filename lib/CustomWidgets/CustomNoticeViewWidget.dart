import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Models/Notice.dart';
import 'package:Surprize/NoticeReadingPage.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:Surprize/WebViewPage.dart';
import 'package:flutter/material.dart';

class CustomNoticeViewWidget extends StatefulWidget {

  Notice _notice;
  CustomNoticeViewWidget(this._notice);
  @override
  _CustomNoticeViewWidgetState createState() => _CustomNoticeViewWidgetState();
}

class _CustomNoticeViewWidgetState extends State<CustomNoticeViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
          leading: noticeImageView(),
          title: noticeTitle(),
          trailing: IconButton(icon: Icon(Icons.navigate_next), onPressed: () {
            if (widget._notice.redirect == null ||
                widget._notice.redirect == "IN_APP") {
              AppHelper.cupertinoRoute(
                  context, NoticeReadingPage(widget._notice));
            }
            else if(widget._notice.redirect == "WEB"){
              AppHelper.cupertinoRoute(context, WebViewPage("Notice", widget._notice.urlRoute));
            }
          }),

      ),
    );
  }

  /// Notice image view
  Widget noticeImageView(){
    return widget._notice.photoUrl.isEmpty
        ? Icon(Icons.info_outline, size: 100)
        : FadeInImage.assetNetwork(
        image: widget._notice.photoUrl,
        placeholder: ImageResources.emptyImageLoadingUrlPlaceholder, height: 100, width:80,fit: BoxFit.fill);
  }

  /// Notice title
  Widget noticeTitle(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
      Text(widget._notice.title,style: TextStyle( fontSize: 16, fontFamily:'Raleway',color: Colors.deepPurple[500], fontWeight: FontWeight.w500)),
      Padding(
        padding: const EdgeInsets.only(top:2.0),
        child: Text(AppHelper.dateToReadableString(widget._notice.addedTime),style: TextStyle(color:Colors.grey[600], fontSize:10, fontWeight:FontWeight.w500,fontFamily: 'Roboto')),
      ),
    ]);
  }
}
