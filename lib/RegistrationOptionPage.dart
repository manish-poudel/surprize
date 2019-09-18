import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/CustomWidgets/RegistrationPage/CustomELAWidget.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/RegistrationPage.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:Surprize/SplashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegistrationOptionPage extends StatefulWidget {
  @override
  _RegistrationOptionPageState createState() => _RegistrationOptionPageState();
}

class _RegistrationOptionPageState extends State<RegistrationOptionPage> {

  CustomELAWidget _customELAWidget = new CustomELAWidget();

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home:Scaffold(
          resizeToAvoidBottomPadding:false,
          appBar: CustomAppBar("Registration", context),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Container(
                    decoration: BoxDecoration(
                      color: Colors.purple[800],
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
                    child: FlatButton(color:Colors.green,onPressed:()=> AppHelper.cupertinoRouteWithPushReplacement(context, RegistrationPage()),
                        child: Text("Create account",
                            style: TextStyle(color:Colors.white,fontSize: 18,fontFamily: 'Raleway', fontWeight:FontWeight.w300))),
                  )),

                Center(
                  child: Text("or sign up using",
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
      var facebookLogin = new FacebookLogin();
      var result = await facebookLogin.logInWithReadPermissions(
          ['email', 'public_profile']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          AuthCredential credential = FacebookAuthProvider.getCredential(
              accessToken: result.accessToken.token);
          FirebaseAuth.instance.signInWithCredential(credential).then((
              authResult) {
            AppHelper.cupertinoRouteWithPushReplacement(
                context, SplashScreen());
          });
          break;
        case FacebookLoginStatus.cancelledByUser:
          break;
        case FacebookLoginStatus.error:
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
       GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
       GoogleSignInAuthentication authentication = await googleSignInAccount.authentication;
       AuthCredential authCredential = GoogleAuthProvider.getCredential(idToken: authentication.idToken, accessToken: authentication.accessToken);

      FirebaseAuth.instance.signInWithCredential(authCredential).then((authResult){
        AppHelper.cupertinoRouteWithPushReplacement(
            context, SplashScreen());
      });
      
     }catch(error){
        print(error.toString());
     }
  }
}
