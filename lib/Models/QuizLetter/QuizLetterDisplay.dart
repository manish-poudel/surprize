import 'package:Surprize/Models/QuizLetter/QuizLetter.dart';

class QuizLetterDisplay{

  QuizLetter quizLetter;
  bool quizLetterLiked;
  bool initiallyExpanded;
  bool revealBody;

  QuizLetterDisplay(this.quizLetterLiked, this.quizLetter, this.initiallyExpanded, this.revealBody);
}