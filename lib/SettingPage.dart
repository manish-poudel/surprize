import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/PoliciesPage.dart';
import 'package:Surprize/ProfilePage.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
        appBar: CustomAppBar("Settings",context),
        body: settingList(),
      ),
    );
  }

  Widget settingList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
       settingMenu("Profile", Icons.perm_identity, () => AppHelper.cupertinoRoute(context, ProfilePage())),
        settingMenu("Policies",Icons.info, () => AppHelper.cupertinoRoute(context, PoliciesPage())),
        settingMenu("Logout",Icons.call_missed_outgoing, () => AppHelper().logoutUser(context)),
      ],
    );
  }

  Widget settingMenu(String name, IconData icon, Function onPressed){
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(bottom:8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:16.0),
                  child: Icon(icon, color: Colors.purple,),
                ),
                FlatButton(child: Text(name,style: TextStyle(fontFamily: 'Raleway', fontWeight:FontWeight.w300,fontSize:18,color: Colors.black)),onPressed: onPressed),
              ],
            )),
      ),
    );
  }
}
