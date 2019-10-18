import 'package:Surprize/ChangeCredentialPage.dart';
import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:Surprize/SendFeedbackPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  String email;
  bool isUserSignedInUsingEmailAndPassword;
  String errorString;
  bool errorInChange = false;
  bool loading = true;
  bool _isPendingVerification = false;

  @override
  void initState() {
    super.initState();
    email = UserMemory().getPlayer().email;
    determineUserLoginType();
  }

  determineUserLoginType(){
    FirebaseAuth.instance.currentUser().then((user) async {
      try{
        isUserSignedInUsingEmailAndPassword = user.providerData[1].providerId == "password";
      }
      catch(error){
        errorString = error.toString();
        errorInChange = true;
      }
      if(mounted) {
        setState(() {
          _isPendingVerification = !user.isEmailVerified;
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
        appBar: CustomAppBar("Account", context),
        body: inflateBody(),
      )
    );
  }


  Widget infoMessage(IconData icon, String message,String initialMessage){
    return Container(
        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: Colors.blueGrey[300], size: 64),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(message, textAlign:TextAlign.center,style: TextStyle(color: Colors.blueGrey,fontFamily: 'Raleway',fontWeight: FontWeight.w300,fontSize: 14)),
              ),
              FlatButton(
                  child: Text("Send",
                      style: TextStyle(color: Colors.grey,fontSize: 18)),
                  onPressed: () =>
                      AppHelper.cupertinoRoute(context, SendFeedbackPage(initialMessage)))
            ],
          )),
        )
    );
  }

  /// Inflate body
  inflateBody(){
    if(loading){
      return Center(child:CircularProgressIndicator());
    }
    if(errorInChange){
      return infoMessage(Icons.error, "Error occured. Click send to report an issue!",errorString);
    }
    else{
      return isUserSignedInUsingEmailAndPassword?accountBody():
     googleAccountBody();
    }
  }

  Widget googleAccountBody(){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: GestureDetector(
        child: Padding(
            padding: const EdgeInsets.only(left:16.0,top:8.0, bottom: 8.0),
            child: Row(
              children: <Widget>[
                Image.asset(ImageResources.googlebutton,height: MediaQuery.of(context).size.width * 0.1,width: MediaQuery.of(context).size.width * 0.1),
                FlatButton(
                    child: Text(
                      email,
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    onPressed: null)
              ],
            ),
          ),
      ),
    );
  }


  /// Account body
  Widget accountBody() {
    return Column(
      children: <Widget>[
        settingButtonWithInfo(email, Icons.email, () => AppHelper.cupertinoRoute(context, ChangeCredentialPage("EMAIL"))),
        AppHelper.settingMenu(context, "Change password", Icons.vpn_key, () => AppHelper.cupertinoRoute(context, ChangeCredentialPage("PASSWORD")))
      ],
    );
  }


  Widget settingButtonWithInfo(String email, IconData icon, Function onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:16.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        icon,
                        color: Colors.purple,
                      ),
                      FlatButton(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Change email",
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 18,
                                      color: Colors.black)),
                              Text(
                                email,
                                style: TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              Visibility(
                                visible:_isPendingVerification,
                                child: Text(
                                  "not verified",
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          onPressed: onPressed)
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

}
