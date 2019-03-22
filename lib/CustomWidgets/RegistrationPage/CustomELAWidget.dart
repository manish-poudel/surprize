import 'package:flutter/material.dart';
import 'package:surprize/Resources/StringResources.dart';

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
    // TODO: implement build
    return Column(
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: StringResources.elaText,
            style: TextStyle(color: Colors.blueAccent)
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top:4.0),
          child: GestureDetector(
            child: RichText(text: TextSpan(
              text:StringResources.elaTextButton,
                style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: Colors.blue)
            )
            )
          ),
        )
      ],
    );
  }
}
