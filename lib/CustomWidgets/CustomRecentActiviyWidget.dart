import 'package:flutter/material.dart';
import 'package:surprize/Helper/AppHelper.dart';
import 'package:surprize/Leaderboard/ScoreSystem.dart';
import 'package:surprize/Models/Activity.dart';

class CustomRecentActivityWidget extends StatelessWidget{

  Activity _activity;
  CustomRecentActivityWidget(this._activity);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return playedQuizCard();
  }

  Widget playedQuizCard(){
    return Card(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left:16.0, top:8.0),
              child: Text("Played daily quiz challenge", style: TextStyle(fontSize: 21,
                  color: Colors.purple,
                  fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding: const EdgeInsets.only(left:16.0),
              child: Text(AppHelper.dateToReadableString(_activity.time), style: TextStyle(fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w300)),
            ),
        Padding(
          padding: const EdgeInsets.only(left:16.0,top:8.0),
          child: Text("Score: " + _activity.reward, style: TextStyle(fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w400)),
        ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 1,color: Colors.grey[200]),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only( bottom:8.0, left:16.0, right: 16.0),
                child: Text((_activity.reward == ScoreSystem.getFullSoreFromQuizPlay().toString()? "Congratulation! You have won daily quiz challenge!.":
                "You didn't complete it succesfully. Read quiz letters to maxmize your chance of winning it!"
                ), style: TextStyle(fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400)),
              ),
            ),

          ],
        ),
      ),
    );
  }
}