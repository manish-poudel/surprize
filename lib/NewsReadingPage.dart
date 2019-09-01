import 'package:flutter/material.dart';

class NewsReadingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewsReadingPageState();
  }
}

class NewsReadingPageState extends State<NewsReadingPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                child: Icon(Icons.arrow_back, color: Colors.white),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text("News"),
            ),
          body:SingleChildScrollView(child: newsContent())
        ));
  }

  /// News content
  Widget newsContent(){
    return Container(
      child: Column(children: <Widget>[
        newsTitle(),
        newsImage(),
        newsBody()
      ],),
    );
  }

  /// Title of news
  Widget newsTitle(){
   return Padding(
     padding: const EdgeInsets.all(8.0),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: <Widget>[
         Text("Winner of popular app surprize has declared its first winner. ", style: TextStyle(color: Colors.black, fontFamily: 'Roboto' ,fontSize: 24, fontWeight: FontWeight.w500)),
         Padding(
           padding: const EdgeInsets.only(top:8.0),
           child: Text("12/1/2019", style: TextStyle(color: Colors.grey, fontFamily: 'Roboto' ,fontSize: 12, fontWeight: FontWeight.w500)),
         )
       ],
     ),
   );
  }

  /// News image
  Widget newsImage(){
    return Container(
        child: Column(
          children: <Widget>[
            Image.network('http://lorempixel.com/400/200/', height: 200),
            Container(
                height: 20,
                child: Text("Some random image short desc will be displayed here.", style: TextStyle(color: Colors.black, fontFamily: 'Roboto' ,fontSize: 14, fontWeight: FontWeight.w300))),
          ],
        ));
  }

  /// News body
  Widget newsBody(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text('Machine learning tasks are classified into several broad categories. \n\n In supervised learning, the algorithm builds a mathematical model from a set of data that contains both the inputs and the desired outputs. For example, if the task were determining whether an image contained a certain object, the training data for a supervised learning algorithm would include images with and without that object (the input), and each image would have a label (the output) designating whether it contained the object. In special cases, the input may be only partially available, or restricted to special feedback.[clarification needed] Semi-supervised learning algorithms develop mathematical models from incomplete training data, where a portion of the sample input doesnt have labels.Classification algorithms and regression algorithms are types of supervised learning. Classification algorithms are used when the outputs are restricted to a limited set of values. For a classification algorithm that filters emails, the input would be an incoming email, and the output would be the name of the folder in which to file the email. For an algorithm that identifies spam emails, the output would be the prediction of either "spam" or "not spam", represented by the Boolean values true and false. Regression algorithms are named for their continuous outputs, meaning they may have any value within a range. Examples of a continuous value are the temperature, length, or price of an object.In unsupervised learning, the algorithm builds a mathematical model from a set of data which contains only inputs and no desired output labels. Unsupervised learning algorithms are used to find structure in the data, like grouping or clustering of data points. Unsupervised learning can discover patterns in the data, and can group the inputs into categories, as in feature learning. Dimensionality reduction is the process of reducing the number of , or inputs, in a set of data.Active learning algorithms access the desired outputs (training labels) for a limited set of inputs based on a budget, and optimize the choice of inputs for which it will acquire training labels. When used interactively, these can be presented to a human user for labeling. Reinforcement learning algorithms are given feedback in the form of positive or negative reinforcement in a dynamic environment, and are used in autonomous vehicles or in learning to play a game against a human opponent.[2]:3 Other specialized algorithms in machine learning include topic modeling, where the computer program is given a set of natural language documents and finds other documents that cover similar topics. Machine learning algorithms can be used to find the unobservable probability density function in density estimation problems. Meta learning algorithms learn their own inductive bias based on previous experience. In developmental robotics, robot learning algorithms generate their own sequences of learning experiences, also known as a curriculum, to cumulatively acquire new skills through self-guided exploration and social interaction with humans. These robots use guidance mechanisms such as active learning, maturation, motor synergies, and imitation',
          style: TextStyle(color: Colors.black, fontFamily: 'Roboto' ,fontSize: 18, fontWeight: FontWeight.w300)
      ),
    );
  }
}