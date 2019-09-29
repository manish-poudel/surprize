
import 'package:Surprize/Helper/AppHelper.dart';

import 'package:flutter/material.dart';

class CustomFooterWidget extends StatefulWidget {

  String quizLetterId;

  @override
  _CustomFooterWidgetState createState() => _CustomFooterWidgetState();
}

class _CustomFooterWidgetState extends State<CustomFooterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
    color: Colors.grey[100],
      child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
/*        Text("Surprize",style:TextStyle(
            fontFamily: 'Raleway',
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.w400)),
       Padding(
         padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
           textLink("DailyQuizChallenge" ,() => DailyQuizChallengePage(context).openPage()),
           Padding(
             padding: const EdgeInsets.only(left:16.0, right: 16.0),
             child: textLink("Quiz Letters" , () => AppHelper.cupertinoRoute(context, QuizLettersPage(null))),
           ),
             textLink("Notice",() => AppHelper.cupertinoRoute(context, NoticePage()))
           ],
         ),
       ),
            textLink("Leaderboard" ,() => AppHelper.cupertinoRoute(context, LeaderboardPage(UserMemory().getPlayer().membershipId))),*/
          Padding(
            padding: const EdgeInsets.only(bottom:8.0),
            child: AppHelper().socialMediaWidget(context),
          )
      ]),
    );
  }

  /// Text link
  Widget textLink(name, onTap){
    return GestureDetector(
      onTap: onTap ,
      child: Text(name,style:TextStyle(
          fontFamily: 'Raleway',
          color: Colors.white,
          decoration: TextDecoration.underline,
          fontSize: 16,
          fontWeight: FontWeight.w400)),
    );
  }

}
