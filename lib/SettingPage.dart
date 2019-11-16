import 'package:Surprize/AccountPage.dart';
import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/PoliciesPage.dart';
import 'package:Surprize/ProfilePage.dart';
import 'package:Surprize/ReferralViewPage.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _appVersion = "";
  bool _showUpdateAvailableText = false;

  @override
  void initState() {
    super.initState();
    getPackageInfo();
  }

  /// Get app package info
  getPackageInfo() async {
    String appVersion = await AppHelper.getPackageInfo();
    setState(() {
      _appVersion = appVersion;
    });
    checkForUpdateAvailable();
  }

  /// Check for update available
  checkForUpdateAvailable(){
    Firestore.instance.collection(FirestoreResources.fieldAppVersionCollection).document(FirestoreResources.fieldAppLatestVersionDocument)
        .get().then((docSnapshot){
       String latestVersion = docSnapshot.data[FirestoreResources.fieldVersion];
       if(latestVersion != _appVersion){
         setState(() {
           _showUpdateAvailableText = true;
         });
       }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
        appBar: CustomAppBar("Settings", context),
        body: settingList(),
      ),
    );
  }

  Widget settingList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppHelper.settingMenu(context,"Profile", Icons.perm_identity,
            () => AppHelper.cupertinoRoute(context, ProfilePage())),
        AppHelper.settingMenu(context,"Account", Icons.account_circle,
                () => AppHelper.cupertinoRoute(context, AccountPage())),
        AppHelper.settingMenu(context,"Policies", Icons.info,
            () => AppHelper.cupertinoRoute(context, PoliciesPage())),
        AppHelper.settingMenu(context,"Referral", Icons.group_work,
                () => AppHelper.cupertinoRoute(context, ReferralViewPage())),
        settingButtonWithInfo("Update", Icons.update, () => _launchURL()),
        AppHelper.settingMenu(context,"Logout", Icons.call_missed_outgoing,
            () => AppHelper().logoutUser(context)),
      ],
    );
  }

  /// Launch url
  _launchURL() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.siliconguy.surprize';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget settingButtonWithInfo(String name, IconData icon, Function onPressed) {
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
                  Text(name,
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.black)),
                  Visibility(
                    visible: _appVersion.isNotEmpty,
                    child: Row(
                      children: <Widget>[
                        Text(
                          "current version: ",
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          _appVersion,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            onPressed: onPressed)
                    ],
                  ),
                ),
                Visibility(
                  visible: _showUpdateAvailableText,
                  child: Padding(
                    padding: const EdgeInsets.only(right:16.0),
                    child: Text("Update available",style: TextStyle(color:Colors.purple,fontWeight: FontWeight.w500),),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
