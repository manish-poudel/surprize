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
import 'package:Surprize/SqliteDb/SQLiteManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                            style: TextStyle(color:Colors.white,fontSize: 18,fontFamily: 'Raleway', fontWeight:FontWeight.w400))),
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
                        FlatButton(color:const Color(0xFFD44638),onPressed:()=> signInWithGoogle(),
                            child: Text("Gmail",
                                style: TextStyle(color:Colors.white,fontSize: 18,fontFamily: 'Raleway', fontWeight:FontWeight.w400)))
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:32.0),
                  child: Center(
                    child: _customELAWidget,
                  ),
                ),

              ],
            ),
          ),
        )
    );
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
        AppHelper.showSnackBar("Could not login using google", _scaffoldKey);
     }
  }

  /// Register profile information
  registerProfileInformation(FirebaseUser user) {
    user.reload();

    // Save user profile information to the database
    Player player = Player(
        user.uid,
        // Player Id
        user.displayName == null?"Anonymous":user.displayName,
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
        user.photoUrl == null?"":user.photoUrl,
        user.isEmailVerified// Player profile Image URL (To be updated later)
    );

    FirestoreOperations()
        .createData(FirestoreResources.userCollectionName, player.membershipId,
        player.toMap())
        .then((value) {

      PushNotification().configure(context);
      PushNotification().saveToken(player.membershipId);

      SQLiteManager().insertProfile(user, player).then((value){
        saveUserToMemoryAndProceed(player, user);
        Navigator.of(context).popUntil((route) => route.isFirst);
        AppHelper.cupertinoRouteWithPushReplacement(context, ProfileSetUpPage(user));
      }).catchError((error){
        print("Error while saving player" + error.toString());
      });

    }).catchError((error) {
      print("error occured haii" + error.toString());
      AppHelper.showSnackBar(error.toString(), _scaffoldKey);
    });
  }



  /// Check if user already exists
  checkIfUserExists(FirebaseUser user) async {
    user.reload();
     Firestore.instance.collection(FirestoreResources.userCollectionName).document(user.uid).get().then((documentSnapshot){
       if(documentSnapshot.exists){
         Player player = Player.fromMap(documentSnapshot.data);
         player.accountVerified = user.isEmailVerified;
         saveUserToMemoryAndProceed(player, user);
         Navigator.of(context).popUntil((route) => route.isFirst);
         AppHelper.cupertinoRouteWithPushReplacement(context, PlayerDashboard());
       }
       else{
         registerProfileInformation(user);
       }
     });
  }

  /// Update email verification
  updateEmailVerification(Player player){
    Firestore.instance.collection(FirestoreResources.userCollectionName).document(player.membershipId)
        .updateData(player.toMap());
  }

  /// Save user to memory and proceed.
  saveUserToMemoryAndProceed(Player player,FirebaseUser user){
    UserMemory().savePlayer(player);
    UserMemory().saveFirebaseUser(user);
    updateEmailVerification(player);
    _customRegistrationProgressBar.stopAndEndProgressBar(context);
  }
}
