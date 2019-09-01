import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:surprize/Bloc/UserProfileBloc.dart';
import 'package:surprize/Models/Player.dart';
import 'package:surprize/Models/User.dart';
import 'package:surprize/Resources/ImageResources.dart';

import 'CustomWidgets/CustomAppBar.dart';

class ProfilePage extends StatefulWidget {

  String _userId;
  ProfilePage(this._userId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {

  Player _player;
  UserProfileBloc _userProfileBloc;
  double _screenHeight;

  @override
  void initState() {
  super.initState();

    _userProfileBloc = new UserProfileBloc(widget._userId);
    _userProfileBloc.userProfileEventSink.add(null);
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    // TODO: implement build
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
          appBar: CustomAppBar("Profile", context),
          body: Container(
              child: StreamBuilder(
                stream: _userProfileBloc.profile,
                builder: (BuildContext context, AsyncSnapshot<User> snapshot){
                  _player = snapshot.data;
                  if(_player == null){
                    return Padding(
                      padding: EdgeInsets.only(top: _screenHeight/2 - 92),
                      child: Center(child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(backgroundColor: Colors.purple),
                          Padding(
                            padding: const EdgeInsets.only(top:0.0),
                            child: Text("Retrieving profile ..."),
                          )
                        ],)
                      ),
                    );
                  }
                  return displayProfile();
                })
          )

        ));
  }


  Widget displayProfile(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              Center(child: profilePhotoContainer()),
              personalInformationHolder()
            ],
          ),
        ],
      ),
    );
  }


  Widget numberDisplayWidget(){
    return Container(
      color:Colors.grey[100],
      child: Column(
        children: <Widget>[
          Center(child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Text("Score",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontFamily: 'Roboto')),
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("20",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight:FontWeight.w200,
                    fontFamily: 'Roboto'))
          )
        ],
      ),
    );
  }

  /*
  User profile photo container
   */
  Widget profilePhotoContainer() {
      return Card(
        child: Container(
        color:Colors.purple[800],
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:16.0),
              child: Center(
                child: Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _player.profileImageURL.isEmpty?NetworkImage('http://lorempixel.com/400/200/'):
                             CachedNetworkImage(imageUrl: _player.profileImageURL),
                          fit: BoxFit.fill)),
                ))),

            Padding(
              padding: const EdgeInsets.only(top:16.0),
              child: Text(
                _player.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Roboto', fontSize: 24, fontWeight:FontWeight.w400, color: Colors.white),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                _player.address,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Roboto', fontSize: 18, fontWeight:FontWeight.w400, color: Colors.white),
              ),
            )
          ],
        ),

    ),
      );
  }

  Widget personalInformationHolder(){
    return  Card(
      child: Container(

              width: MediaQuery.of(context).size.width,
              child: Column(children: <Widget>[
                textWithIcon(Icons.email, _player.email, Colors.purple),
                textWithIcon(Icons.phone, _player.phoneNumber, Colors.purple),
                textWithIcon(Icons.calendar_today, _player.dob, Colors.purple),
                textWithIcon(Icons.place, _player.country, Colors.purple),
                textWithIcon(Icons.people_outline, _player.gender, Colors.purple),
              ]),
            ),
    );
  }

  /*
  Widget for text with icon
   */
  Widget textWithIcon(IconData iconData, String text, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left:8.0),
          child: Card(child: Icon(iconData, color: color)),
        ),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Roboto', fontSize: 18,  fontWeight:FontWeight.w300, color: color),
          ),
        )
      ],
    );
  }

 /* Container(
  child: Padding(
  padding: const EdgeInsets.only(top:16.0, bottom: 4.0),
  child: Padding(
  padding: const EdgeInsets.all(8.0),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: <Widget>[

  Container(
  width:100,
  child: Card(

  child: Padding(
  padding: const EdgeInsets.all(8.0),
  child: Text(
  "asdsadsadasdasdasdasdasdasdasdasdasdasd",
  textAlign: TextAlign.center,
  style: TextStyle(
  fontFamily: 'Roboto', fontSize: 18, fontWeight:FontWeight.w400, color: Colors.purple),
  ),
  ),
  ),
  ),

  Card(
  child: Padding(
  padding: const EdgeInsets.all(8.0),
  child: Text(
  _player.email,
  textAlign: TextAlign.center,
  style: TextStyle(
  fontFamily: 'Roboto', fontSize: 18, fontWeight:FontWeight.w400, color: Colors.purple),
  ),
  ),
  ),
  ],
  ),
  ),
  ))*/

}
