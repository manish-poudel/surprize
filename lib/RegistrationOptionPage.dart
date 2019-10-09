import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/CustomWidgets/CustomProgressbarWidget.dart';
import 'package:Surprize/CustomWidgets/RegistrationPage/CustomELAWidget.dart';
import 'package:Surprize/Firestore/FirestoreOperations.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/Player.dart';
import 'package:Surprize/PlayerDashboard.dart';
import 'package:Surprize/ProfileSetUpPage.dart';
import 'package:Surprize/RegistrationPage.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'FirebaseMessaging/PushNotification/PushNotification.dart';

class RegistrationOptionPage extends StatefulWidget {
  @override
  _RegistrationOptionPageState createState() => _RegistrationOptionPageState();
}

class _RegistrationOptionPageState extends State<RegistrationOptionPage> {

  CustomELAWidget _customELAWidget = new CustomELAWidget();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CustomProgressbarWidget _customRegistrationProgressBar = new CustomProgressbarWidget();

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home:Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomPadding:false,
          appBar: CustomAppBar("Registration", context),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Container(
                    decoration: BoxDecoration(
                        image:DecorationImage(image: AssetImage(ImageResources.appBackgroundImage), fit: BoxFit.cover)
                    ),
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Image.asset(ImageResources.appMainLogo),
                    alignment: FractionalOffset.center
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                  child: Text("Choose sign up method",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Raleway')),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:32.0),
                  child: Center(
                    child: FlatButton(color:Colors.green,onPressed:()=> AppHelper.cupertinoRoute(context, RegistrationPage()),
                        child: Text("Sign up",
                            style: TextStyle(color:Colors.white,fontSize: 18,fontFamily: 'Raleway', fontWeight:FontWeight.w300))),
                  )),

                Center(
                  child: Text("or login using",
                      style: TextStyle(color:Colors.black,fontSize: 18.0, fontWeight: FontWeight.w400,fontFamily: 'Raleway' )
                  ),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(color:Colors.blueAccent,onPressed:()=>  signInWithFacebook(),
                            child: Text("facebook",
                                style: TextStyle(color:Colors.white,fontSize: 18,fontFamily: 'Raleway', fontWeight:FontWeight.w300))),
                        FlatButton(color:Colors.red,onPressed:()=> signInWithGoogle(),
                            child: Text("Gmail",
                                style: TextStyle(color:Colors.white,fontSize: 18,fontFamily: 'Raleway', fontWeight:FontWeight.w300)))
                      ],
                    ),
                  ),
                ),

                Center(
                  child: _customELAWidget,
                ),

              ],
            ),
          ),
        )
    );
  }

  // Sign in using facebook
  signInWithFacebook() async {
    try {
      _customRegistrationProgressBar.startProgressBar(context, "Registering...", Colors.white, Colors.black);
      var facebookLogin = new FacebookLogin();
      var result = await facebookLogin.logInWithReadPermissions(
          ['email', 'public_profile']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          AuthCredential credential = FacebookAuthProvider.getCredential(
              accessToken: result.accessToken.token);
          FirebaseAuth.instance.signInWithCredential(credential).then((
              authResult) {
            checkIfUserExists(authResult.user);
          });
          break;
        case FacebookLoginStatus.cancelledByUser:
          _customRegistrationProgressBar.stopAndEndProgressBar(context);
          break;
        case FacebookLoginStatus.error:
          _customRegistrationProgressBar.stopAndEndProgressBar(context);
          break;
      }
    }catch(error){

    }
  }

  // Sign in using google
  signInWithGoogle() async{
     GoogleSignIn googleSignIn = GoogleSignIn(
       scopes: ['email']
     );
     try{
       _customRegistrationProgressBar.startProgressBar(context, "Registering...", Colors.white, Colors.black);
       GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
       GoogleSignInAuthentication authentication = await googleSignInAccount.authentication;
       AuthCredential authCredential = GoogleAuthProvider.getCredential(idToken: authentication.idToken, accessToken: authentication.accessToken);

      FirebaseAuth.instance.signInWithCredential(authCredential).then((authResult){
        checkIfUserExists(authResult.user);
      });
      
     }catch(error){
       _customRegistrationProgressBar.stopAndEndProgressBar(context);
        print(error.toString());
     }
  }

  /// Register profile information
  registerProfileInformation(FirebaseUser user) {


    // Save user profile information to the database
    Player player = Player(
        user.uid,
        // Player Id
        user.displayName == null?"":user.displayName,
        // Player Name
        "",
        // Player DOB
        "",
        // Player Address
        "",
        // Player country
        "",
        // Player Gender
        user.email == null?"":user.email,
        // Player Email
        user.phoneNumber == null?"":user.phoneNumber,
        DateTime.now(),
        // Player membership date
        user.photoUrl == null?"":user.photoUrl // Player profile Image URL (To be updated later)
    );

    FirestoreOperations()
        .createData(FirestoreResources.userCollectionName, player.membershipId,
        player.toMap())
        .then((value) {

          saveUserToMemoryAndProceed(player, user);

          PushNotification().configure(context);
          PushNotification().saveToken(UserMemory().getPlayer().membershipId);

          Navigator.of(context).popUntil((route) => route.isFirst);
          AppHelper.cupertinoRouteWithPushReplacement(context, ProfileSetUpPage(user));

    }).catchError((error) {
      AppHelper.showSnackBar(error.toString(), _scaffoldKey);
    });
  }



  /// Check if user already exists
  checkIfUserExists(FirebaseUser user) async {
     Firestore.instance.collection(FirestoreResources.userCollectionName).document(user.uid).get().then((documentSnapshot){
       if(documentSnapshot.exists){
         Player player = Player.fromMap(documentSnapshot.data);
         saveUserToMemoryAndProceed(player, user);
         Navigator.of(context).popUntil((route) => route.isFirst);
         AppHelper.cupertinoRouteWithPushReplacement(context, PlayerDashboard());
       }
       else{
         registerProfileInformation(user);
       }
     });
  }

  /// Save user to memory and proceed.
  saveUserToMemoryAndProceed(Player player,FirebaseUser user){
    UserMemory().savePlayer(player);
    UserMemory().saveFirebaseUser(user);

    _customRegistrationProgressBar.stopAndEndProgressBar(context);
  }
}
