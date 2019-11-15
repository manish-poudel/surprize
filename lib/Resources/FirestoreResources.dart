class FirestoreResources {


  static final leaderboardCollection = "Leaderboard";
  static final leaderboardSubCollection = "Leaderboard_scores";
  static final leaderboardSubCollectionLatestQuiz = "Leaderboard_scores_latest";
  static final leaderboardSubCollectionBeforeLatestQuiz = "Leaderboard_scores_before_latest";

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
  static final String fieldDailyQuizTotalCorrectAnswer = "Total correct answer";
  static final String fieldDailyQuizPlayScore = "score";

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
  static final String fieldPlayerAccountVerified = 'accountVerified';

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
  static final String fieldQuizLetterState = "State";

  // Related to quiz letter

  static final String collectionNotice = "/Notice";
  static final String fieldNoticeId = "Id";
  static final String fieldNoticeTitle = "Notice";
  static final String fieldNoticeBody = "Body";
  static final String fieldNoticeImageUrl = "Image Url";
  static final String fieldNoticeImageDesc = "Image Desc";
  static final String fieldNoticeAddedDate = "Added date";
  static final String fieldNoticeRedirect = "redirect";
  static final String fieldNoticeRouteUrl = "url";

  /// Related to user presence

  static final String collectionUserPresence = "/User Presence";
  static final String fieldUserPresenceState = "Current State";
  static final String fieldUserPresenceStateChangedTime = "State changed at";

  /// Related to report
  static get fieldReportId => 'Id';

  static get fieldReportSubject => 'Subject';

  static get fieldReportBody => 'Body';

  static get fieldReportedBy => 'ReportedBy';

  static get fieldReportedOn => 'ReportedOn';

  static get fieldReportReply => 'Reply';

  static get fieldRepliedOn => 'RepliedOn';

  static String get collectionReport => '/Report';

  static String get collectionReportList => '/Reportlist';


  /// Related to referral
  static final String fieldReferralCollection = "/Referrals";
  static final String fieldReferralId = 'Id';
  static final String fieldReferralCode = "Code";
  static final String fieldReferralCreateDate = "createdAt";
  static final String fieldReferralCreator = "createdBy";
  static final String fieldReferralUsedBy = "usedBy";
  static final String fieldReferralState = "State";
  static final String fieldReferralAccountStateReceiver = "receiverAccountState";
  static final String fieldReferralAccountStateSender = "senderAccountState";

  static get fieldDailyQuizState => "State";

  /// Related to survey
  static final String fieldSurveyCollection = "/Survey";
  static final String fieldSurveyId = "id";
  static final String fieldSurveyRatingField = "rating";
  static final String fieldSurveyIssueYesNoField = "Had Issue?";
  static final String fieldSurveyIssueDesc = "Issue Desc";
  static final String fieldSurveyNoOfQuizQuestion ="Total Question faced";
  static final String fieldSurveyTime = "time";
  static final String fieldSurveyFor = "quizName";
  static final String fieldSurveyQuizKeywords = "Keywords";

  /// Related to version
  static final String fieldAppVersionCollection = "/App version";
  static final String fieldAppLatestVersionDocument = "latest version";
  static final String fieldVersion = "version";


  /// Related to Daily Quiz Challenge
  static final String collectionDailyQuizChallenge = "/Daily Quiz Challenge";
  static final String docChallengeOfToday = "Today";
  static final String docChallengeOfYesterday = "Yesterday";
  static final String collectionChallengeInfo = "Data";
  static final String docChallengeConductedOn = "Conducted on";
  static final String docChallengePlayerList = "Players";
  static final String fieldDQCConductedOn = "date";
  static final String fieldDQCPlayerId = "playerId";
  static final String fieldDQCid=  "id";
  static final String fieldDQCRank = "rank";
  static final String fieldDQCPlayerName = "playerName";
  static final String fieldDQCPlayerEmailVerified = "isEmailVerified";
  static final String fieldDQCHasPlayerWon = "didPlayerWon";
  static final String fieldDQCPlayedOn = "playedOn";
  static final String fieldDQCPlayerScore = "score";
  static final String fieldNextGameOn = "nextGameOn";
  static final String collectionEasyQuestion = "Easy Questions";
  static final String collectionMediumQuestion = "Medium Questions";
  static final String collectionHardQuestion = "Hard Questions";


  /// Related to facts
  static final String collectionsDidYouKnow = '/Did You Know';
  static final String fieldDYKId =  'id';
  static final String fieldDYKBody =  'body';
  static final String fieldDRYKImageUrl=  'imageUrl';
  static final String fieldDYKState = 'state';

}