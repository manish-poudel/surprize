import 'package:Surprize/Models/QuizLetter/QuizLetter.dart';

class QuizLetterDisplay{

  String displayId;
  QuizLetter quizLetter;
  bool quizLetterLiked;
  bool initiallyExpanded;
  bool revealBody;

  QuizLetterDisplay(this.displayId,this.quizLetterLiked, this.quizLetter, this.initiallyExpanded, this.revealBody);

}