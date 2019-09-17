class FirestoreResources {


  static final leaderboardCollection = "Leaderboard";
  static final leaderboardSubCollection = "Leaderboard_scores";

  /// Related to leaderboard
  static final String leaderboardAllTime = "All Time Score";
  static final String leaderboardWeekly = "Weekly Score";
  static final String leaderboardDaily = "Daily Winners";

  static final String fieldLeaderBoardScore = "score";
  static final String fieldDailyQuizWinner = "isWinner";

  /// Related to daily quiz challenge leaderboard

  static final String fieldDailyQuizPlayState = "Play state";
  static final String fieldDailyQuizLastPlayed = "Last played";
  static final String fieldDailyQuizPlayedId = "Quiz played id";
  static final String fieldDailyQuizPlayedName = "Quiz played name";

  /// Related to registration

  /// Player basic registration info related
  static final String userCollectionName = "/Players";
  static final String fieldPlayerId = 'membershipId';
  static final String fieldPlayerEmail = 'email';
  static final String fieldPlayerName = 'name';
  static final String fieldPlayerGender = 'gender';
  static final String fieldPlayerDOB = 'dob';
  static final String fieldPlayerCountry = 'country';
  static final String fieldPlayerPhoneNumber = 'phoneNumber';
  static final String fieldPlayerAddress = 'address';
  static final String fieldPlayerProfileURL = 'profileImageURL';
  static final String fieldPlayerMembershipDate = 'membershipDate';

  /*****************************************************************/

  /// Related to daily quiz challenge

  static final String collectionQuizName = '/quiz';
  static final String collectionQuestionAndAnswersList = 'quiz_q&a_list';
  static final String fieldQuizId = 'id';
  static final String fieldQuizState = 'quizState';
  static final String fieldQuizName = 'quizName';
  static final String fieldQuizStateId = 'quizId';
  static final String fieldQuizStartTime = 'quizStartTime';
  static final String fieldCurrentQuizId = "current_quiz_id";
  static final String fieldQuizQuestion = 'question';
  static final String fieldQuizAnswers = 'answers';
  static final String fieldQuizCorrectAnswer = 'correct_answer_value';
  static final String fieldQuizDocumentName = 'quizDocument';


  /*****************************************************************/


  /// Related to events collections
  static final String collectionEvent = "events";
  static final String fieldEventId = "eventId";
  static final String fieldEventPhoto = "eventPhoto";
  static final String fieldEventTitle = "eventTitle";
  static final String fieldEventDesc = "eventDesc";
  static final String fieldEventTime = "eventTime";

  /***************************Related to activity**************************************/

  static final String collectionActivity = "activity";
  static final String collectionActivityList = "top_five_recent_activity_list";
  static final String fieldActivityId = "activityId";
  static final String fieldActivityType = "activityType";
  static final String fieldActivityReward = "activityReward";
  static final String fieldActivityTime = "activityTime";


  /**********************************************************************/

  /// Related to storage
  static final String storageProfileFolder = "User profile images";
  static final String storageQuizLetters = "Quiz letter";

  // Related to quiz letters
  static final String collectionQuizLetterName = "/Quiz Letters";
  static final String fieldQuizLetterId = "Id";
  static final String fieldQuizLetterSubject = "Subject";
  static final String fieldQuizLetterBody = "Body";
  static final String fieldQuizLetterQuiz = "Quiz";
  static final String fieldQuizLetterImage = "Image Url";
  static final String fieldQuizLetterAddedDate = "Added date";

  // Related to quiz letter

  static final String collectionNotice = "/Notice";
  static final String fieldNoticeId = "Id";
  static final String fieldNoticeTitle = "Notice";
  static final String fieldNoticeBody = "Body";
  static final String fieldNoticeImageUrl = "Image Url";
  static final String fieldNoticeImageDesc = "Image Desc";
  static final String fieldNoticeAddedDate = "Added date";

  /// Related to user presence

  static final String collectionUserPresence = "/User Presence";
  static final String fieldUserPresenceState = "Current State";
  static final String fieldUserPresenceStateChangedTime = "State changed at";
}