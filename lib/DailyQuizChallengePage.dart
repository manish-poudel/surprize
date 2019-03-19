import 'package:surprize/Helper/AppHelper.dart';

class DailyQuizChallengePage{
  /*
  Open page
   */
  void openPage(context){
    if(!_checkIfDailyQuizGameIsOn()){
      AppHelper.goToPage(context, false, '/dailyQuizChallengeNotAvailablePage');
    }
  }

  bool _checkIfDailyQuizGameIsOn(){
    return false;
  }
}