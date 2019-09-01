import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DailyQuizChallengeGamePlayPage.dart';
import 'DailyQuizChallengeNotAvailablePage.dart';

class DailyQuizChallengePage{

  DailyQuizChallengePage(context){
    openPage(context);
  }

  /// Open page
   openPage(context){
    if(!_checkIfDailyQuizGameIsOn()){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DailyQuizChallengeNotAvailablePage()));
    }

    if(_checkIfDailyQuizGameIsOn()){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DailyQuizChallengeGamePlayPage()));
    }
  }

  /// Check if quiz is on
  bool _checkIfDailyQuizGameIsOn(){
    return true;
  }

}