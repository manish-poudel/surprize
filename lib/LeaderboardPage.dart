import 'package:flutter/material.dart';
import 'package:surprize/Leaderboard/LeaderboardManager.dart';
import 'package:surprize/Models/Leaderboard.dart';
import 'package:surprize/Resources/FirestoreResources.dart';

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
  bool _isDailyQuizWinner;
  Map<String, Leaderboard> _allTimeScorerMap = new Map();
  Map<String, Leaderboard> _weeklyScorerMap = new Map();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
                appBar: AppBar(
                  leading: GestureDetector(
                    child: Icon(Icons.arrow_back, color: Colors.white),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  title: Text("Leaderboard"),
                  bottom: _leaderboardTabs(),
                ),
                body: _leaderboardBody())));
  }

  /// Main leaderboard body page
  TabBarView _leaderboardBody() {
    return TabBarView(
      children: [
        _dailyQuizBody(),
        _weeklyScoreBody(),
        _allTimeScoreBody(),
      ],
    );
  }

  /// Main leaderboard tabs
  TabBar _leaderboardTabs() {
    return TabBar(
      tabs: [
        Tab(icon: Icon(Icons.card_giftcard), child: Text("Daily quiz")),
        Tab(icon: Icon(Icons.view_week), child: Text("Weekly Score")),
        Tab(icon: Icon(Icons.score), child: Text("All Time Score")),
      ],
    );
  }

  /// Daily quiz body for leaderboard page
  Widget _dailyQuizBody() {
    if (!_dailyQuizWinnerDataLoaded) return Center(child: Text("Loading..."));
    return Center(
        child: Column(
      children: <Widget>[
        Container(
          color: Colors.grey[50],
          child: Image.asset(ImageResources.dailyQuizChallengeLogo),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: (Text(
            _isDailyQuizWinner
                ? "Congrats! You are a winner of daily quiz challenge."
                : "You are not a daily quiz winner. You can improve your chance of winning by reading quiz letters.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
          )),
        ),
      ],
    ));
  }

  /// Weekly score body for leaderboard page
  Widget _weeklyScoreBody() {
    return Column(
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
  Widget _allTimeScoreBody() {
    return Column(
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

  Future checkForDailyWinner() async {
    bool isWinner =
        await LeaderboardManager().getDailyScoreWinner(widget._playerId);
    setState(() {
      _isDailyQuizWinner = isWinner;
      _dailyQuizWinnerDataLoaded = true;
    });
  }

  /// Get all time scorer
  void getAllTimeScorer() {
    LeaderboardManager().getScorer(FirestoreResources.leaderboardAllTime,
        FirestoreResources.fieldLeaderBoardScore, (Leaderboard leaderboard) {
      setState(() {
        _allTimeScorerMap.putIfAbsent(
            leaderboard.player.membershipId, () => leaderboard);
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
      });
    });
  }

  /// Widget to show the player score
  Widget myScore(Leaderboard leaderboard) {
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
    if (leaderboard != null && leaderboard.rank == 1) {
      color = Colors.yellow;
    }
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                padding: EdgeInsets.all(0.0),
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    color: color,
                    border:
                        new Border.all(color: Colors.black, width: 0.1),
                    borderRadius:
                        new BorderRadius.all(Radius.circular(21.0))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                  child: Text(
                      leaderboard == null
                          ? ""
                          : leaderboard.rank.toString(),
                      style: TextStyle(
                          color: Colors.purple,
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                )),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        NetworkImage('http://lorempixel.com/400/200/')),
              ),
              Text(leaderboard == null ? "" : leaderboard.player.name,
                  style: TextStyle(
                      color: Colors.purple,
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(leaderboard == null ? "" : leaderboard.score.toString(),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Colors.purple[600],
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.w500)),
            ),
            flex: 1,
          )
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
          padding: const EdgeInsets.all(4.0),
          child: Text(text,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  fontWeight: FontWeight.w400)),
        ));
  }
}
