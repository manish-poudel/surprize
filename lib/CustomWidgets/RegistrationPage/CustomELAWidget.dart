import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/WebViewPage.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/Resources/StringResources.dart';

class CustomELAWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomELAWidgetState();
  }
}

class CustomELAWidgetState extends State<CustomELAWidget> {

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: StringResources.elaText,
            style: TextStyle(color: Colors.black, fontSize:12,fontFamily: 'Roboto')
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => AppHelper.cupertinoRoute(context, WebViewPage('Terms and conditions','https://surprize-5b596.firebaseapp.com/Terms_and_condition.html')),
              child: Padding(
                padding: const EdgeInsets.only(top:4.0),
                child: GestureDetector(
                  child: RichText(text: TextSpan(
                    text:StringResources.elaTextButtonTermsAndCondition,
                      style: TextStyle(fontSize:12,fontWeight: FontWeight.bold,fontFamily: 'Raleway', decoration: TextDecoration.underline, color: Colors.black)
                  )
                  )
                ),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () => AppHelper.cupertinoRoute(context, WebViewPage('Privacy and policy','https://surprize-5b596.firebaseapp.com/Privacy_and_policy.html')),
              child: Padding(
                padding: const EdgeInsets.only(top:4.0),
                child: GestureDetector(
                    child: RichText(text: TextSpan(
                        text:StringResources.elaTextButtonPrivacyAndPolicy,
                        style: TextStyle(fontSize:12,fontWeight: FontWeight.bold,fontFamily: 'Raleway', decoration: TextDecoration.underline, color: Colors.black)
                    )
                    )
                ),
              ),
            )
          ],
        ),

      ],
    );
  }
}
