import 'package:flutter/material.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Leaderboard/ScoreSystem.dart';
import 'package:Surprize/Models/Activity.dart';

class CustomRecentActivityWidget extends StatelessWidget {
  Activity _activity;
  CustomRecentActivityWidget(this._activity);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return recentActivityCard();
  }

  Widget recentActivityCard() {
    return Card(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top:16.0, bottom: 16.0, left:8.0, right: 8.0),
          child: Column(
            children: <Widget>[
              Align(alignment: Alignment.center, child: title()),
              Padding(
                padding: const EdgeInsets.only(top:8.0, bottom: 16.0),
                child: Container(height: 0.5, color: Colors.grey[200]),
              ),
              desc()
            ],
          ),
        ),
      ),
    );
  }

  /// Title of the card
  Widget title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(getIcon(), color: Colors.purple),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(getTitleText(),
                      style: TextStyle(
                          fontSize: 21,
                          color: Colors.purple,
                          fontWeight: FontWeight.w500)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(AppHelper.dateToReadableString(_activity.time),
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w300)),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  getIcon() {
    if (_activity.type == ActivityType.EDITED_PROFILE) {
      return Icons.edit;
    }
    if (_activity.type == ActivityType.SHARING_APP_TO_FACEBOOK) {
      return Icons.share;
    }
    if (_activity.type == ActivityType.PLAYED_QUIZ) {
      return Icons.games;
    }
  }

  /// Score display
  Widget score() {
    return Align(
      alignment: Alignment.center,
      child: Text("Score earned " + _activity.reward,
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'Roboto',
              color: Colors.black,
              fontWeight: FontWeight.w500)),
    );
  }

  /// Desc
  Widget desc() {
    return Container(

      child: Column(
        children: <Widget>[
          Visibility(visible: false, child: score()),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(getDescText(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w300)),
            ),
          ),
        ],
      ),
    );
  }

  /// Get title text
  getTitleText() {
    switch (_activity.type) {
      case ActivityType.EDITED_PROFILE:
        return "Edited profile";
        break;
      case ActivityType.PLAYED_QUIZ:
        return "Played daily quiz challenge";
        break;
      case ActivityType.SHARING_APP_TO_OTHER_APPS:
        return "Shared app";
        break;
      case ActivityType.SHARING_APP_TO_FACEBOOK:
        return "Shared app to facebook";
        break;
      case ActivityType.UNKNOWN:
        return "UNKNOWN";
        break;
    }
  }

  /// Get desc Text
  getDescText() {
    if (_activity.type == ActivityType.PLAYED_QUIZ) {
      return (_activity.reward ==
              (ScoreSystem.getFullSoreFromQuizPlay() +
                      ScoreSystem.getScoreFromGamePlay())
                  .toString()
          ? "Congratulation! You have won daily quiz challenge!"
          : "You didn't complete it succesfully. Read quiz letters to maxmize your chance of winning it!");
    } else if (_activity.type == ActivityType.SHARING_APP_TO_FACEBOOK) {
      return "Earned " + _activity.reward + " points by sharing app to facebook!";
    } else if (_activity.type == ActivityType.EDITED_PROFILE) {
      return "Edited your profile!";
    }
    return "";
  }

  /// Show score or not
  bool showScore() {
    return (_activity.type != ActivityType.EDITED_PROFILE);
  }
}
