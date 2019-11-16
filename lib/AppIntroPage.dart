
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/PlayerDashboard.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class AppIntroPage extends StatefulWidget {

  String source;
  AppIntroPage(this.source);
  @override
  _AppIntroPageState createState() => _AppIntroPageState();
}

class _AppIntroPageState extends State<AppIntroPage> {

  List<Slide> slides = new List();

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      colorDot: Colors.white,
      onSkipPress: this.onDonePress,
    );
  }

  @override
  void initState() {
    super.initState();
    createSlide();
  }

  createSlide(){

    Slide helpIntroSlideFirstTime = Slide(
        maxLineTitle: 2,
        pathImage: ImageResources.helpQuickTour,
        title: "Welcome to Surprize! \n \n",
        description: "Before launching app, let us give you a quick tour!",
        backgroundColor: Colors.purple[800]
    );

    Slide helpIntroSlide = Slide(
        maxLineTitle: 2,
        title: "A Quick Guide To Using Application \n \n",
        description: "Swipe or click next to start",
        backgroundColor: Colors.purple[800]
    );

    Slide slideSurprizeChallenge = Slide(
        title: "Surprize Challenge",
        description: "Surprize Challenge allows you to play quiz and earn cash prize. "
            "Game time will be notified in the app and you will get notification before the game starts. \n \n"
            "Tips\n \n "
            "1. You can select answer only once. \n "
            "2. You will get 10 seconds for each question. \n "
            "3. Don't click back button or exit the game until the game is completed. \n "
            "4. Once the game is completed, you will be able to see your score report. \n"
            "5. Watching video ad at the end can earn you extra 10 points. ",
        pathImage: ImageResources.helpSurprize,
        backgroundColor: Colors.purple[800]
    );


    Slide slideDailyQuizChallenge = Slide(
        title: "Daily Quiz Challenge",
        description: "Daily Quiz Challenge allows you to play quiz and earn cash prize. The game is opened for a period of 24 hours and can only be played once.\n\n"
            "Tips\n \n "
            "1. You can select answer only once. \n "
            "2. You will get 10 seconds for each question. \n "
            "3. Don't click back button or exit the game until the game is completed. \n ",
        pathImage: ImageResources.helpDQC,
        backgroundColor: Colors.purple[800]
    );


    Slide slideSurprizeChallengeNavigate = Slide(
      title: "Opening Surprize Challenge",
        maxLineTitle: 2,
      description: "During game time, it should start automatically when you open the app. However, button will pop up at dashboard. Click on it to navigate by yourself.",
        pathImage: ImageResources.helpSurprizeButton,
        backgroundColor: Colors.purple[800]
    );


    Slide slideDailyQuizChallengeNavigate = Slide(
        title: "Opening Daily Quiz Challenge",
        maxLineTitle: 2,
        description: "You can simply click on the Daily Quiz Challenge display card on dashboard to play the game. "
            ,
        pathImage: ImageResources.helpDQCButton,
        backgroundColor: Colors.purple[800]
    );

    Slide slideQuizLetters = Slide(
        title: "Quiz Letters",
        description: "Quiz letters is a fun way to play quiz and test your knowledge on different subject with interesting facts."
            "\n \n You will be provided with new quiz letter every day. Play them to increase your chance of winning Surprize Challenge."
            ,
        pathImage: ImageResources.helpQuizLetter,
        backgroundColor: Colors.purple[800]
    );
    Slide slideQuizLettersOpening = Slide(
        title: "Opening Quiz Letters",
        description: "You will get latest Quiz Letter on your dashboard. To open it, simply click 'Play more'."
        ,
        pathImage: ImageResources.helpQuizLetterOpening,
        backgroundColor: Colors.purple[800]
    );

    Slide slideEventHelp = Slide(
        title: "Events",
        description: "Upcoming events like Daily Quiz Challenge, App update etc. will be displayed on your dashboard. \n \n You can "
            "set alarm for the events by clicking on the circular alarm icon as shown in the image."
        ,
        pathImage: ImageResources.helpEvent,
        backgroundColor: Colors.purple[800]
    );

    slides.add(widget.source =="FIRST_TIME_USER"?helpIntroSlideFirstTime:helpIntroSlide);
    slides.add(slideDailyQuizChallenge);
    slides.add(slideDailyQuizChallengeNavigate);
    slides.add(slideSurprizeChallenge);
    slides.add(slideSurprizeChallengeNavigate);
    slides.add(slideQuizLetters);
    slides.add(slideQuizLettersOpening);
    slides.add(slideEventHelp);
  }

  onDonePress() {
    widget.source == "FIRST_TIME_USER"?AppHelper.cupertinoRouteWithPushReplacement(context, PlayerDashboard()):Navigator.of(context).pop();
  }
}
