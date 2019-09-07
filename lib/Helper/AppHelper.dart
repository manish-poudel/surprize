import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Surprize/LoginPage.dart';
class AppHelper{
  /*
  Pop and removed current page, and push with new page
   */
  static void popAndPushReplacement(context, String dest){
    try {
      Navigator.of(context).pushReplacementNamed(dest);
    }
    catch(error){
      print(error);
    }
  }

  /*
  Pop current page
   */
  static void pop(context){
    try {
      Navigator.of(context).pop();
    }
    catch(error){
      print(error);
    }
  }

  /*
  Pop and just pushed new page without removing it.
   */
  static void push(context, String dest){
    try {
      Navigator.of(context).pushNamed(dest);
    }
    catch(error){
      print(error);
    }
  }

  /*
  Go to new page.
   */
 static void goToPage(context, bool removePage, String destPage){
    if(removePage == true) {
      popAndPushReplacement(context, destPage);
    }
    if(removePage == false){
     push(context, destPage);
    }
  }

  /*
  String to int conversion
   */
  static int stringToIntConversion(String value)
  {
    int intValue = 0;
    try{
      intValue = int.parse(value);
    }
    catch(error){
      intValue = 0;
      print(error);
    }
    return intValue;
  }

  /***
   * Email validation
   */
  static String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  /*
  validate name
   */
 static String validateName(String value) {
   if(value.isEmpty){
     return 'Enter valid name';
   }
    if (value.length < 3)
      return 'Name must be more than 2 character';
    else
      return null;
  }

  /*
  Show Snackbar
   */
  static void showSnackBar(String value, GlobalKey<ScaffoldState> scaffoldKey){
    scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }

  /*
  Text with icon
   */
 static Widget textWithIcon(IconData icon, String text, double padding, double textSize,  Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, color: color),
        Padding(
          padding:  EdgeInsets.only(left: padding),
          child: Text(
            text,
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: textSize,
                color: color),
          ),
        ),
      ],
    );
  }

  static DateTime convertToDateTime(time){
   DateTime convertedDateTime;
      try{
        Timestamp timestamp = time;
        convertedDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
      }
      catch(error) {
        print("DATE TIME CONVERSION ERROR: " + convertedDateTime.toString());
      }
      return convertedDateTime;
  }

  static String dateToReadableString(DateTime time){
   return time.year.toString() + "/" + time.month.toString() + "/" + time.day.toString()
       + ", " + addLeadZeroToNumber(time.hour)  + ":" + addLeadZeroToNumber(time.minute);
  }

  static String addLeadZeroToNumber(int time){
   String readableTime = time.toString();
   if(time < 9){
     return readableTime.padLeft(2,"0");
   }
   return readableTime;
  }


  /// Button with text widget
  Widget buttonText(String text) {
    return Text(text,
        style: TextStyle(color: Colors.purple[800], fontFamily: 'Roboto' ,fontSize: 18, fontWeight: FontWeight.w500));
  }

  /// Flat button with route
  Widget flatButtonWithRoute(Icon icon, Function function, String text) {
    return GestureDetector(
      onTap: () => function(),
      child: Container(
        color:Colors.grey[100],
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left:16.0),
              child: icon
            ),
            Padding(
              padding: const EdgeInsets.only(left:16.0),
              child: FlatButton(onPressed: function, child: buttonText(text)),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget for app small header
 static Widget appSmallHeader(String heading){
   return Padding(
     padding: const EdgeInsets.all(16.0),
     child: Text(heading,
         style: TextStyle(
             fontFamily: 'Roboto',
             color: Colors.black54,
             fontSize: 18,
             fontWeight: FontWeight.w500)),
   );
  }

  /// App header
  static Widget appHeaderDivider(){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        height: 8,
        color: Colors.grey[200],
      ),
    );
  }
  /// Method for logging out user
   logoutUser(context) {
    FirebaseAuth.instance.signOut().then((value) {
      try {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage()));
      } catch (error) {
        print(error);
      }
    }).catchError((error) {
      print(error);
    });
  }

  /// Open image gallery
  static Future openImageGallery() async {
    var file = await ImagePicker.pickImage(source: ImageSource.gallery);
    return file;
  }

  /// Open image cropper
  static Future<File> cropImage(File imageFile, maxH, maxW) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: maxW,
      maxHeight: maxH,
    );
    return croppedFile;
  }

  /// Open image gallery, crop and return it
  static Future pickAndCropPhoto(maxHeight, maxWidth) async {
    var image = await AppHelper.openImageGallery();
    var croppedImage = await AppHelper.cropImage(image, maxHeight, maxWidth);
    return croppedImage;
  }

  /// Get date from list
  static List<int> getDateListFromString(String dob, String splitBy){
   List<int> dobList = new List();
   try {
     dob.split(splitBy).forEach((value) {
       dobList.add(int.parse(value));
     });
   }
   catch(error){
     print(error.toString());
     return [DateTime.now().year,DateTime.now().month,DateTime.now().day];
   }
  return dobList;
 }
}