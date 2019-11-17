import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/Firestore/FirestoreOperations.dart';
import 'package:Surprize/GoogleAds/GoogleAdManager.dart';
import 'package:Surprize/Helper/AppHelper.dart';

import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/DailyQuizChallenge/DLeaderboard.dart';
import 'package:Surprize/Models/DailyQuizChallenge/QuizPlay.dart';
import 'package:Surprize/Models/Player.dart';
import 'package:Surprize/Models/SurprizeLeaderboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/Leaderboard/LeaderboardManager.dart';
import 'package:Surprize/Models/Leaderboard.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

import 'package:Surprize/Models/DailyQuizChallenge/enums/PlayState.dart';

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

  bool _weeklyScorerLeaderboardLoaded = false;
  bool _allTimeScorerLeaderboardLoaded = false;


  Map<String, Leaderboard> _allTimeScorerMap = new Map();
  Map<String, Leaderboard> _weeklyScorerMap = new Map();
  Map<String, DLeaderboard> _todayWinners = new Map();
  Map<String, DLeaderboard> _yesterdayWinners = new Map();

  String surprizeGameDateSelection = "Latest";
  Map<String, SurprizeLeaderboard> _latestSurprizePlayers = new Map();
  Map<String, SurprizeLeaderboard> _beforeLatestSurrpizePlayers = new Map();


  DateTime latestSurprizeDate;
  DateTime beforeLatestSurprizeDate;

  double _screenWidth;

  int _selectedIndex = 0;

  List<Widget> _leaderboardOptions;


  @override
  Widget build(BuildContext context) {
    _leaderboardOptions = <Widget>[
      _displayChallengeWinners(),
      _weeklyScoreBody(),
      _allTimeScoreBody()
    ];

    _screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
            appBar: CustomAppBar("Leaderboard", context),
            bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.games,
                        color: Colors.purple,
                      ),
                      title: Text("Challengers",
                          style: TextStyle(fontFamily: 'Raleway'))),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.view_week, color: Colors.purple),
                      title: Text("Weekly Score",
                          style: TextStyle(fontFamily: 'Raleway'))),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.score, color: Colors.purple),
                      title: Text("All Time Score",
                          style: TextStyle(fontFamily: 'Raleway'))),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.purple,
                onTap: _onItemSelected),
            body: _leaderboardOptions.elementAt(_selectedIndex)));
  }

  /// On bottom navigation bar selected
  _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Challenge winners
  Widget _displayChallengeWinners() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.purple[800],
        appBar: TabBar(indicatorColor: Colors.white, tabs: [
          Tab(
              child: Text("Daily Quiz Challenge",
                  style: TextStyle(fontFamily: 'Raleway'))),
          Tab(
              child: Text("Surprize Challenge",
                  style: TextStyle(fontFamily: 'Raleway'))),
        ]),
        body: Container(
          color: Colors.white,
          child: TabBarView(
            children: <Widget>[_dailyQuizWinnerBody(), _surprizeWinnerBody()],
          ),
        ),
      ),
    );
  }

  /// Daily quiz winner body
  Widget _dailyQuizWinnerBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: Center(child: showDQCList())),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 5.0),
                  blurRadius: 10.0),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              timeDropDownMenu(),
              playerTypeForDQC(),
            ],
          ),
        ),
      ],
    );
  }

  /// Get dqc score
  getDQCScorers() {
    /// Today winners
    Firestore.instance
        .collection(FirestoreResources.collectionDailyQuizChallenge)
        .document(FirestoreResources.docChallengeOfToday)
        .collection(FirestoreResources.docChallengePlayerList)
        .snapshots()
        .listen((querySnapshot) {
      querySnapshot.documents.forEach((documentSnapshot) {
        DLeaderboard dLeaderboard = DLeaderboard.fromMap(documentSnapshot.data);
        if (_todayWinners.containsKey(dLeaderboard.playerId)) {
          _todayWinners.remove(dLeaderboard.playerId);
        }
        setState(() {
          print("The laderboard" + dLeaderboard.playerName.toString());
          _todayWinners.putIfAbsent(dLeaderboard.playerId, () => dLeaderboard);
        });
      });
    });

    /// Yesterday
    Firestore.instance
        .collection(FirestoreResources.collectionDailyQuizChallenge)
        .document(FirestoreResources.docChallengeOfYesterday)
        .collection(FirestoreResources.docChallengePlayerList)
        .snapshots()
        .listen((querySnapshot) {
      querySnapshot.documents.forEach((documentSnapshot) {
        DLeaderboard dLeaderboard = DLeaderboard.fromMap(documentSnapshot.data);
        if (_yesterdayWinners.containsKey(dLeaderboard.playerId)) {
          _yesterdayWinners.remove(dLeaderboard.playerId);
        }
        _yesterdayWinners.putIfAbsent(
            dLeaderboard.playerId, () => dLeaderboard);
      });
    });
  }

  /// Get player data
  Future<Player> getProfileData(String id) async {
    DocumentSnapshot documentSnapshot = await FirestoreOperations()
        .getDocumentSnapshot(FirestoreResources.userCollectionName, id)
        .get();
    Player player = Player.fromMap(documentSnapshot.data);
    return player;
  }

  String lastQuizName;
  DateTime lastPlayedOn;

  /// Get surprize Player
  getSurprizePlayer() async {
    await Firestore.instance.collection(FirestoreResources.leaderboardCollection).document(FirestoreResources.leaderboardDaily).
        snapshots().listen((documentSnapshot){

          latestSurprizeDate = AppHelper.convertToDateTime(documentSnapshot.data['latestQuizDate']);
          beforeLatestSurprizeDate = AppHelper.convertToDateTime(documentSnapshot.data['beforeLatestQuizDate']);
    });

    /// Get latest surprize players
    Firestore.instance.collection(FirestoreResources.leaderboardCollection).document(FirestoreResources.leaderboardDaily)
    .collection(FirestoreResources.leaderboardSubCollectionLatestQuiz).snapshots().listen((querySnapshot){

      querySnapshot.documents.forEach((docSnapshot) async {
                Player player = await getProfileData(docSnapshot.documentID);
                if(_latestSurprizePlayers.containsKey(player.membershipId)){
                  _latestSurprizePlayers.remove(player.membershipId);
                }

                setState(() {
                  _latestSurprizePlayers.putIfAbsent(player.membershipId, () => SurprizeLeaderboard(QuizPlay.fromMap(docSnapshot.data),player));
                });
      });

    });

    /// Get before latest surprize players
    Firestore.instance.collection(FirestoreResources.leaderboardCollection).document(FirestoreResources.leaderboardDaily)
        .collection(FirestoreResources.leaderboardSubCollectionBeforeLatestQuiz).snapshots().listen((querySnapshot){

      querySnapshot.documents.forEach((docSnapshot) async {
        Player player = await getProfileData(docSnapshot.documentID);
        if(_beforeLatestSurrpizePlayers.containsKey(player.membershipId)){
          _beforeLatestSurrpizePlayers.remove(player.membershipId);
        }
        setState(() {
          _beforeLatestSurrpizePlayers.putIfAbsent(player.membershipId, () => SurprizeLeaderboard(QuizPlay.fromMap(docSnapshot.data),player));
        });
      });

    });
  }

  Widget showSurprizePlayerList() {
    List<SurprizeLeaderboard> playerLeaderboard = getSurprizePlayerList();
    if(playerLeaderboard.length > 1) {
      playerLeaderboard.sort((leaderboard1, leaderboard2) {
        if (leaderboard1.quizPlay.score == null) {
          leaderboard1.quizPlay.score = -1;
        }
        if (leaderboard2.quizPlay.score == null) {
          leaderboard2.quizPlay.score = -1;
        }
        return leaderboard2.quizPlay.score.compareTo(
            leaderboard1.quizPlay.score);
      });
    }
    if (playerLeaderboard.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[Text(_playerTypeDropdownValueForSurprize == "All players"?"No players":"No winners", style: TextStyle(fontFamily: 'Raleway'))],
      );
    }
    return ListView.builder(
        itemCount: playerLeaderboard.length,
        itemBuilder: (BuildContext context, int index) {
          SurprizeLeaderboard leaderboard = playerLeaderboard[index];

          return Padding(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: Container(
                  color: Colors.white,
                  child: Card(
                      color: Colors.white,
                      child: leaderboard != null?challengePlayerDisplayCard(
                        leaderboard.player != null && leaderboard.player.name.isNotEmpty?leaderboard.player.name:"",
                        leaderboard.player != null?leaderboard.player.profileImageURL:"",
                        leaderboard.quizPlay != null && leaderboard.quizPlay.score != null?leaderboard.quizPlay.score.toString():"",
                        leaderboard.quizPlay != null || leaderboard.quizPlay.playState != null?leaderboard.quizPlay.playState == PlayState.WON:false,
                        leaderboard != null?(index + 1):-1,

                      ):Container(height:0, width:0))));
        });
  }

  /// Show dqc list
  Widget showDQCList() {
    List<DLeaderboard> playersLeaderboard = getPlayersForDQC();
    if(playersLeaderboard.length > 1) {
      playersLeaderboard.sort((leaderboard1, leaderboard2) =>
          leaderboard2.score.compareTo(leaderboard1.score));
    }
    if (playersLeaderboard.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[Text(_playerTypeDropdownValue == "All players"?"No players":"No winners",style: TextStyle(fontFamily: 'Raleway'))],
      );
    }
    return ListView.builder(
        itemCount: playersLeaderboard.length,
        itemBuilder: (BuildContext context, int index) {

          DLeaderboard leaderboard = playersLeaderboard[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 1.0),
            child: Container(
                color: Colors.white,
                child: Card(
                    color: Colors.white,
                    child: leaderboard != null?challengePlayerDisplayCard(
                    leaderboard.playerName != null || leaderboard.playerName.isNotEmpty?leaderboard.playerName:"",
                    leaderboard.playerUrl != null || leaderboard.playerUrl.isNotEmpty?leaderboard.playerUrl:"",
                    leaderboard.score != null?leaderboard.score.toString():"",
                    leaderboard.won != null?leaderboard.won:false,
                    leaderboard != null?(index + 1):-1,

          ):Container(height:0, width:0))));
        });
  }

  /// Challenge player display card
  challengePlayerDisplayCard(String name, String profileUrl, String score, bool won, int rank) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                 rank.toString(),
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
                  child:profileUrl.isEmpty
                      ? Image.asset(
                    ImageResources.emptyUserProfilePlaceholderImage,
                    height: 32,
                    width: 32,
                  )
                      : FadeInImage.assetNetwork(
                      image: profileUrl,
                      height: 32,
                      width: 32,
                      placeholder:
                      ImageResources.emptyUserProfilePlaceholderImage)),
            ),
          ),
          Flexible(
            child: Container(
              width: _screenWidth * 0.5,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: won == true? ClipOval(
                  child: Image.asset(
                    ImageResources.achievementTrophy,
                    height:16,
                    width: 16,
                  )):Container(height: 0,width: 0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:4.0),
                        child: Container(
                          width: _screenWidth * 0.40,
                          child: Text(
                             name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontFamily: 'Raleway',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            flex: 3,
          ),
          Padding(
            padding: EdgeInsets.only(left: score.length == 1?8:0),
            child: Text(score != "-1"?score:"  ",
                style: TextStyle(
                    color: Colors.purple,
                    fontFamily: 'Raleway',
                    fontSize: 21,
                    fontWeight: FontWeight.w500)),
          )
        ],
      ),
    );
  }

  List<DLeaderboard> getPlayersForDQC() {
    if (dropdownValue == "Today") {
      return _todayWinners.values.where((dLeaderboard) {
        if (_playerTypeDropdownValue == "All players") {
          return true;
        }
        return dLeaderboard.won;
      }).toList();
    }
    if (dropdownValue == "Yesterday") {
      return _yesterdayWinners.values.where((dLeaderboard) {
        if (_playerTypeDropdownValue == "All players") {
          return true;
        }
        return dLeaderboard.won;
      }).toList();
    }
  }

  List<SurprizeLeaderboard> getSurprizePlayerList() {

    if(surprizeGameDateSelection == "Latest") {
      return _latestSurprizePlayers.values.where((leaderboard) {
        if (_playerTypeDropdownValueForSurprize == "All players") {
          return true;
        }
        return leaderboard.quizPlay.playState == PlayState.WON;
      }).toList();
    }
    return _beforeLatestSurrpizePlayers.values.where((leaderboard) {
      if (_playerTypeDropdownValueForSurprize == "All players") {
        return true;
      }
      return leaderboard.quizPlay.playState == PlayState.WON;
    }).toList();
  }

  String dropdownValue = "Today";
  Widget timeDropDownMenu() {
    return DropdownButton<String>(
      value: dropdownValue,
      elevation: 16,
      style: TextStyle(color: Colors.white),
      underline: SizedBox(),
      iconSize: 21,
      iconEnabledColor: Colors.purple,
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Today', 'Yesterday']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.purple,
                  fontSize: 15,
                  fontFamily: 'Raleway')),
        );
      }).toList(),
    );
  }

  String _playerTypeDropdownValue = "All players";
  Widget playerTypeForDQC() {
    return DropdownButton<String>(
      value: _playerTypeDropdownValue,
      elevation: 16,
      style: TextStyle(color: Colors.purple),
      underline: SizedBox(),
      iconSize: 21,
      iconEnabledColor: Colors.purple,
      onChanged: (String newValue) {
        setState(() {
          _playerTypeDropdownValue = newValue;
        });
      },
      items: <String>['All players', 'Winners']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.purple,
                  fontSize: 16,
                  fontFamily: 'Raleway')),
        );
      }).toList(),
    );
  }

  String _playerTypeDropdownValueForSurprize = "All players";
  Widget playerTypeForSurprize() {
    return DropdownButton<String>(
      value: _playerTypeDropdownValueForSurprize,
      elevation: 16,
      style: TextStyle(color: Colors.purple),
      underline: SizedBox(),
      iconSize: 21,
      iconEnabledColor: Colors.purple,
      onChanged: (String newValue) {
        setState(() {
          _playerTypeDropdownValueForSurprize = newValue;
        });
      },
      items: <String>['All players', 'Winners']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.purple,
                  fontSize: 16,
                  fontFamily: 'Raleway')),
        );
      }).toList(),
    );
  }

  Widget dateSelectionForSurprize() {
    return DropdownButton<String>(
      value: surprizeGameDateSelection,
      elevation: 16,
      style: TextStyle(color: Colors.purple),
      underline: SizedBox(),
      iconSize: 21,
      iconEnabledColor: Colors.purple,
      onChanged: (String newValue) {
        setState(() {
          surprizeGameDateSelection = newValue;
        });
      },
      items: <String>['Latest', 'Previous']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.purple,
                  fontSize: 16,
                  fontFamily: 'Raleway')),
        );
      }).toList(),
    );
  }

  /// Surprize winner body
  Widget _surprizeWinnerBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: Center(child: showSurprizePlayerList())),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 5.0),
                  blurRadius: 10.0),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              dateSelectionForSurprize(),
              playerTypeForSurprize(),
            ],
          ),
        ),
      ],
    );
  }

  /// Weekly score body for leaderboard page
  _weeklyScoreBody() {
    if (!_weeklyScorerLeaderboardLoaded)
      return Center(child: CircularProgressIndicator());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: _allTimeScorerMap.length == 0
                ? Center(
                    child: Text("Empty leaderboard",
                        style: TextStyle(fontFamily: 'Raleway')))
                : showTopScorers(_weeklyScorerMap.values.toList())),
        myScore(_weeklyScorerMap[widget._playerId]),
      ],
    );
  }

  /// All time score body for leaderboard page
  _allTimeScoreBody() {
    if (!_allTimeScorerLeaderboardLoaded)
      return Center(child: CircularProgressIndicator());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: _allTimeScorerMap.length == 0
                ? Center(
                    child: Text("Empty leaderboard",
                        style: TextStyle(fontFamily: 'Raleway')))
                : showTopScorers(_allTimeScorerMap.values.toList())),
        myScore(_allTimeScorerMap[widget._playerId]),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getAllTimeScorer();
    getWeeklyScorer();
    getDQCScorers();
    getSurprizePlayer();
    GoogleAdManager().showLeaderboardInterstitialAd(0.0, AnchorType.bottom);
  }

  /// Get all time scorer
  void getAllTimeScorer() {
    LeaderboardManager().getScorer(FirestoreResources.leaderboardAllTime,
        FirestoreResources.fieldLeaderBoardScore, (Leaderboard leaderboard) {
      setState(() {
        _allTimeScorerLeaderboardLoaded = true;
        if (leaderboard != null) {
          _allTimeScorerMap.putIfAbsent(
              leaderboard.player.membershipId, () => leaderboard);
        }
      });
    });
  }

  /// Get all time scorer
  void getWeeklyScorer() {
    LeaderboardManager().getScorer(FirestoreResources.leaderboardWeekly,
        FirestoreResources.fieldLeaderBoardScore, (leaderboard) {
      setState(() {
        if (leaderboard != null) {
          _weeklyScorerMap.putIfAbsent(
              leaderboard.player.membershipId, () => leaderboard);
        }
        _weeklyScorerLeaderboardLoaded = true;
      });
    });
  }

  /// Widget to show the player score
  Widget myScore(Leaderboard leaderboard) {
    if (leaderboard == null) {
      leaderboard = new Leaderboard(0, UserMemory().getPlayer(), 0,
          UserMemory().firebaseUser.isEmailVerified);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black, offset: Offset(4.0, 18.0), blurRadius: 26.0),
        ],
      ),
      child: playerScoreHolder(leaderboard, Colors.purple),
    );
  }

  /// Widget to populate top scorer
  Widget showTopScorers(List<Leaderboard> topScorerLeaderboardList) {
    if (topScorerLeaderboardList.length == 0)
      return Center(
          child: Text("Empty leaderboard",
              style: TextStyle(fontFamily: 'Raleway')));
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
                    child: playerScoreHolder(
                        topScorerLeaderboardList[index], Colors.purple))),
          );
        },
    );
  }

  /// Widget to hold each player score
  Widget playerScoreHolder(Leaderboard leaderboard, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  leaderboard == null || leaderboard.rank == 0
                      ? "-"
                      : leaderboard.rank.toString(),
                  style: TextStyle(
                      color: color,
                      fontFamily: 'Raleway',
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipOval(
                  child: leaderboard.player.profileImageURL.isEmpty
                      ? Image.asset(
                          ImageResources.emptyUserProfilePlaceholderImage,
                          height: 32,
                          width: 32,
                        )
                      : FadeInImage.assetNetwork(
                          image: leaderboard.player.profileImageURL,
                          height: 32,
                          width: 32,
                          placeholder:
                              ImageResources.emptyUserProfilePlaceholderImage)),
            ),
          ),
          Flexible(
            child: Container(
              width: _screenWidth * 0.5,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                      leaderboard == null ? "" : leaderboard.player.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: color,
                          fontFamily: 'Raleway',
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ),
            flex: 3,
          ),
          Text(leaderboard == null ? "0" : leaderboard.score.toString(),
              style: TextStyle(
                  color: color,
                  fontFamily: 'Raleway',
                  fontSize: 21,
                  fontWeight: FontWeight.w500)),
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
