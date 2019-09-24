import 'package:Surprize/DailyQuizChallengePage.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/LeaderboardPage.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/NoticePage.dart';
import 'package:Surprize/QuizLettersPage.dart';
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
      padding: EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
        Text("Surprize",style:TextStyle(
            fontFamily: 'Raleway',
            fontSize: 21,
            color: Colors.purple[800],
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
            textLink("Leaderboard" ,() => AppHelper.cupertinoRoute(context, LeaderboardPage(UserMemory().getPlayer().membershipId))),
          AppHelper().socialMediaWidget(context)
      ]),
    );
  }

  /// Text link
  Widget textLink(name, onTap){
    return GestureDetector(
      onTap: onTap ,
      child: Text(name,style:TextStyle(
          fontFamily: 'Raleway',
          color: Colors.grey,
          decoration: TextDecoration.underline,
          fontSize: 16,
          fontWeight: FontWeight.w400)),
    );
  }

}
