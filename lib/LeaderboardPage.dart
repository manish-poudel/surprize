import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Models/DailyQuizChallenge/QuizPlay.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/Leaderboard/LeaderboardManager.dart';
import 'package:Surprize/Models/Leaderboard.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

import 'package:Surprize/Models/DailyQuizChallenge/enums/PlayState.dart';
import 'package:intl/intl.dart';
import 'Resources/ImageResources.dart';

class LeaderboardPage extends StatefulWidget {

  String _playerId;
  LeaderboardPage(this._playerId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LeaderboardPageState();
  }
}

class LeaderboardPageState extends State<LeaderboardPage> {
  bool _dailyQuizWinnerDataLoaded = false;
  bool _weeklyScorerLeaderboardLoaded = false;
  bool _allTimeScorerLeaderboardLoaded = false;

  QuizPlay _quizPlay;

  Map<String, Leaderboard> _allTimeScorerMap = new Map();
  Map<String, Leaderboard> _weeklyScorerMap = new Map();

  double _screenWidth;

  int _selectedIndex = 0;

  List<Widget> _leaderboardOptions;

  @override
  Widget build(BuildContext context) {

    _leaderboardOptions = <Widget>[_dailyQuizBody(), _weeklyScoreBody(), _allTimeScoreBody()];

    _screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
            appBar: CustomAppBar("Leaderboard",context),

            bottomNavigationBar: BottomNavigationBar(items: const<BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.stars), title: Text("Daily quiz",style: TextStyle(fontFamily: 'Raleway'))),
              BottomNavigationBarItem(icon: Icon(Icons.view_week), title: Text("Weekly Score",style: TextStyle(fontFamily: 'Raleway'))),
              BottomNavigationBarItem(icon: Icon(Icons.score), title: Text("All time score",style: TextStyle(fontFamily: 'Raleway'))),
            ], currentIndex:_selectedIndex,  selectedItemColor: Colors.purple, onTap: _onItemSelected),

            body: _leaderboardOptions.elementAt(_selectedIndex)));
  }

  /// On bottom navigation bar selected
  _onItemSelected(int index){
    setState(() {
      _selectedIndex = index;
    });
  }


  /// Daily quiz body for leaderboard page
   Widget _dailyQuizBody() {
    return SingleChildScrollView(
      child: !_dailyQuizWinnerDataLoaded? Center(child: CircularProgressIndicator()):
       Center(
          child: Column(
        children: <Widget>[
          Container(
            color: Colors.grey[50],
            child: Image.asset(ImageResources.dailyQuizChallengeLogo),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: (Text(_dailyQuizPlayChallengeText() ,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontFamily: 'Raleway'),
            )),
          ),
          _quizPlay != null?Visibility(
            visible: (_quizPlay.playState == PlayState.WON || _quizPlay.playState == PlayState.LOST),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                (Text("Last played on: " ,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18,fontFamily: 'Raleway', fontWeight: FontWeight.w500),
                )),
                Text(AppHelper.dateToReadableString(_quizPlay.playedOn) ,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color:Colors.grey,fontFamily: 'Raleway',fontWeight: FontWeight.w300),
                )
              ],
            ),
          ):Container()
        ],
      )),
    );
  }

  String _dailyQuizPlayChallengeText(){
    print("Daily wuiz state" + _quizPlay.playState.toString());
   if(_quizPlay == null)
     return "New challenge is in progress. Get ready!";
   if(_quizPlay.playState == PlayState.WON)
     return "Congratulation! You are a winner of daily quiz challenge!";
   if(_quizPlay.playState == PlayState.LOST)
     return "You are not a daily quiz winner. You can improve your chance of winning by reading quiz letters.";
    if(_quizPlay.playState == PlayState.NOT_PLAYED)
      return "New challenge is in progress. Get ready!";
    return "";
  }

  /// Weekly score body for leaderboard page
   _weeklyScoreBody() {
   return !_weeklyScorerLeaderboardLoaded? Center(child: CircularProgressIndicator()):
     Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        myScore(_weeklyScorerMap[widget._playerId]),
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: leaderboardHeading("Top Weekly scorers"),
        ),
        Expanded(child: showTopScorers(_weeklyScorerMap.values.toList())),
      ],
    );
  }

  /// All time score body for leaderboard page
   _allTimeScoreBody() {
    return !_allTimeScorerLeaderboardLoaded? Center(child: CircularProgressIndicator()):
     Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        myScore(_allTimeScorerMap[widget._playerId]),
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: leaderboardHeading("Top all time scorers"),
        ),
        Expanded(child: showTopScorers(_allTimeScorerMap.values.toList())),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    checkForDailyWinner();
    getAllTimeScorer();
    getWeeklyScorer();
  }

   checkForDailyWinner() async {
    await LeaderboardManager().getDailyScoreWinner(widget._playerId).then((value){
      value.listen((snapshot){
        setState(() {
          _dailyQuizWinnerDataLoaded = true;
          if(!snapshot.exists){
            _quizPlay = QuizPlay(PlayState.NOT_PLAYED, DateTime.now(),"","");
            return;
          }
          else {
            _quizPlay = QuizPlay.fromMap(snapshot.data);
          }
          print("The state us " + _quizPlay.playState.toString());

        });
      });
    });

  }

  /// Get all time scorer
  void getAllTimeScorer() {
    LeaderboardManager().getScorer(FirestoreResources.leaderboardAllTime,
        FirestoreResources.fieldLeaderBoardScore, (Leaderboard leaderboard) {
      setState(() {
        _allTimeScorerMap.putIfAbsent(
            leaderboard.player.membershipId, () => leaderboard);
        _allTimeScorerLeaderboardLoaded = true;
      });
    });
  }

  /// Get all time scorer
  void getWeeklyScorer() {
    LeaderboardManager().getScorer(FirestoreResources.leaderboardWeekly,
        FirestoreResources.fieldLeaderBoardScore, (leaderboard) {
      setState(() {
        _weeklyScorerMap.putIfAbsent(
            leaderboard.player.membershipId, () => leaderboard);
        _weeklyScorerLeaderboardLoaded = true;
      });
    });
  }

  /// Widget to show the player score
  Widget myScore(Leaderboard leaderboard) {
    if(leaderboard == null)
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.tag_faces, size: 20, color: Colors.grey),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text("Play or share the game to be listed on the leaderboard!",style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w300)),
              ),
            ],
          ),
        ),
      );

    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(1.0, 2.0),
                blurRadius: 25.0),
          ],
        ),
        child: playerScoreHolder(leaderboard),
      ),
    );
  }

  /// Widget to populate top scorer
  Widget showTopScorers(List<Leaderboard> topScorerLeaderboardList) {

    if(topScorerLeaderboardList.length == 0)
      return Center(child: Text("Empty leaderboard", style: TextStyle(fontFamily: 'Raleway')));
    if (topScorerLeaderboardList.length > 1) {
      topScorerLeaderboardList.sort((Leaderboard lbOne, Leaderboard lbTwo) =>
          lbOne.rank.compareTo(lbTwo.rank));
    }

    return ListView.builder(
        itemCount: topScorerLeaderboardList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 1.0),
            child: Container(
                color: Colors.white,
                child: Card(
                    color: Colors.white,
                    child: playerScoreHolder(topScorerLeaderboardList[index]))),
          );
        });
  }

  /// Widget to hold each player score
  Widget playerScoreHolder(Leaderboard leaderboard) {
    Color color = Colors.white;
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:Text(
                  leaderboard == null
                      ? ""
                      : leaderboard.rank.toString(),
                  style: TextStyle(
                      color: Colors.purple,
                      fontFamily: 'Raleway',
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ),
          ),

          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipOval(

                  child:leaderboard.player.profileImageURL.isEmpty
                      ? Image.asset(
                      ImageResources.emptyUserProfilePlaceholderImage, height: 50,width: 50,)
                      : FadeInImage.assetNetwork(image: leaderboard.player.profileImageURL,height:50,width:50,placeholder: ImageResources.emptyUserProfilePlaceholderImage)),
            ),
          ),
          Flexible(
            child: Container(
              width: _screenWidth * 0.5,
              child: Column(
                children: <Widget>[
                  Text(leaderboard == null ? "" : leaderboard.player.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.purple[800],
                          fontFamily: 'Raleway',
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                  Text(leaderboard == null ? "" : leaderboard.score.toString(),
                      style: TextStyle(
                          color: Colors.purple[600],
                          fontFamily: 'Raleway',
                          fontSize: 21,
                          fontWeight: FontWeight.w500))
                ],
              ),
            ),
            flex: 3,
          ),

        ],
      ),
    );
  }

  /// Heading text of an leaderboard
  Widget leaderboardHeading(String text) {
    return Container(
        width: MediaQuery.of(context).size.width - 32,
        color: Colors.purple[400],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Raleway',
                  fontSize: 24,
                  fontWeight: FontWeight.w400)),
        ));
  }

}
