import 'package:flutter/material.dart';
import 'package:surprize/Helper/AppColor.dart';

/***
 * Definitions of various elements and styles used throughout the application
 */

/***
 * Section Divider
 */
class SectionDivider extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Divider(color: const Color(0xFF1E88E5), height: 50.0,);
  }
}

/**App Bar features **/
const AppBarBgColor = const Color(0xFF0D47A1);

/***
 * Custom raised Button features
**/
const double ButtonFontSize = 18.0;
const ButtonTextColor = const Color (0xFFFFFFFF);
const ButtonBgColor = const Color (0xFF82B1FF);

class CustomRaisedButton extends RaisedButton
{
  CustomRaisedButton(String label, Function onpressed, Color color) : super
      (onPressed: onpressed,
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
       child: Text(label, style: TextStyle(fontSize: ButtonFontSize, color: Colors.white)),
       color:color,
       );
}