import 'package:surprize/Helper/AppHelper.dart';

class DailyQuizChallengePage{
  /*
  Open page
   */
  void openPage(context){
    if(!_checkIfDailyQuizGameIsOn()){
      AppHelper.goToPage(context, false, '/dailyQuizChallengeNotAvailablePage');
    }
    if(_checkIfDailyQuizGameIsOn()){
      AppHelper.goToPage(context, false, '/dailyQuizChallengeGamePlayPage');
    }
  }

  /*
  Check if quiz is on
   */
  bool _checkIfDailyQuizGameIsOn(){
    return true;
  }
}