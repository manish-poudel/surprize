/// Class for handling the score system in the app

class ScoreSystem{

  static final int _scoreFromEachQuizCorrectAnswer = 4;
  static final int _scoreFromGamePlay = 15;

  static final int _scoreFromSharingAppToFacebook = 10;
  static final int _scoreFromSharingToOtherPlatform = 5;

  static final int _totalQuestions = 5;
  static final int _fullScoreFromOneQuizPlay = _scoreFromEachQuizCorrectAnswer * _totalQuestions;

  /// Returns score for each correct quiz answer
  static int getScoreFromQuizCorrectAnswer(){
    return _scoreFromEachQuizCorrectAnswer;
  }

  /// Returns score for game play
  static int getScoreFromGamePlay(){
    return _scoreFromGamePlay;
  }

  /// Returns score for sharing the app
  static int getSoreFromSharingApp(String platform){
    /// if user has shared to facebook
    if (platform == 'Facebook') {
      return _scoreFromSharingAppToFacebook;
    }
    return _scoreFromSharingToOtherPlatform;
  }

  /// Returns full score from one quiz play
  static int getFullSoreFromQuizPlay(){
    return _fullScoreFromOneQuizPlay;
  }


}