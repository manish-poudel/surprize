import 'package:Surprize/DQCGamePlayPage.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetter.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuestionRetrievePage extends StatefulWidget {
  @override
  _QuestionRetrievePageState createState() => _QuestionRetrievePageState();
}

class _QuestionRetrievePageState extends State<QuestionRetrievePage> {

  List <QuizLetter> _questions = new List();

  @override
  void initState() {
    super.initState();
    getQuestions();
  }


  /// Retrieve all questions
  getQuestions() async {
    getQuestion(4, FirestoreResources.collectionEasyQuestion ,(_){
      getQuestion(3, FirestoreResources.collectionMediumQuestion, (_){
        getQuestion(3, FirestoreResources.collectionHardQuestion, (_){
          print("Quesiton lenth" + _questions.length.toString());
          if(_questions.length < 10){

            int howMuch = (10 - _questions.length);
            for(int i = 0; i < (10 - howMuch); i++ ){
              print("how much lenght" + howMuch.toString());
              _questions.add(_questions[0]);
            }
          }
          AppHelper.cupertinoRouteWithPushReplacement(context, DQCGamePlayPage(_questions));
        });
      });
    });
  }


  /// Get easy question
  Future<Null> getQuestion(int totalNumber, String collection, Function afterRetrieve)  async {
      Stream<QuerySnapshot> questions = Firestore.instance.collection(FirestoreResources.collectionDailyQuizChallenge).document(FirestoreResources.docChallengeOfToday)
          .collection(collection).snapshots();
      await questions.listen((questions){
          List<int> questionIndex = AppHelper.randomNumberList(totalNumber, 0, 6);
          int i = 0;
          questions.documents.forEach((documentSnapshot){
            if(questionIndex.contains(i)){
              _questions.add(QuizLetter.fromMap(documentSnapshot.data));
            }
            i++;
          });
         afterRetrieve(null);
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: new AssetImage(ImageResources.appBackgroundImage),
                  fit: BoxFit.fill)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(backgroundColor: Colors.purple),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Loading questions ...", style: TextStyle(color: Colors.white, fontFamily: 'Raleway')),
                ),
              ],
            )
          )
        ),
      ),
    );
  }
}
