import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/WebViewPage.dart';
import 'package:flutter/material.dart';

class PoliciesPage extends StatefulWidget {
  @override
  _PoliciesPageState createState() => _PoliciesPageState();
}

class _PoliciesPageState extends State<PoliciesPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
        appBar: CustomAppBar("Policy",context),
        body: settingList(),
      ),
    );
  }

  Widget settingList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        settingMenu("Terms and conditions",Icons.info, () => AppHelper.cupertinoRoute(context, WebViewPage('Terms and conditions','https://surprize-5b596.firebaseapp.com/Terms_and_condition.html'))),
        settingMenu("Privacy policy",Icons.data_usage,  () => AppHelper.cupertinoRoute(context, WebViewPage('Privacy and policy','https://surprize-5b596.firebaseapp.com/Privacy_and_policy.html'))),
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
