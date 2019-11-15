import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:Surprize/Resources/ErrorResources.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:Surprize/WebViewPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Surprize/LoginPage.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';

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

  ///cupertino route
  static cupertinoRoute(buildContext,pageName){
    return Navigator.push(
        buildContext,
        CupertinoPageRoute(
            builder: (context) => pageName));
  }

  ///cupertino route
  static void cupertinoRouteWithPushReplacement(buildContext,pageName){
    Navigator.pushReplacement(
        buildContext,
        CupertinoPageRoute(
            builder: (context) => pageName));
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

  /// Return login error string message based on error code.
  static getErrorCodeString(String errorCode){
    switch(errorCode){
      case "ERROR_INVALID_EMAIL":
        return ErrorResources.invalidEmailError;
      case "ERROR_USER_NOT_FOUND":
        return ErrorResources.noEmailError;
      case "ERROR_WRONG_PASSWORD":
        return ErrorResources.wrongPasswordError;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        return ErrorResources.emailAlreadyInUseError;
      default:
        return ErrorResources.defaultError;
    }
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

  /// Package info
  static Future<String> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version + "+" + packageInfo.buildNumber;
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

  static String validatePhone(String value){
    if(value.isEmpty){
      return 'Enter valid phone';
    }
    try{
      List values = value.split(" ");
      print(values.length);
      if(values.length != 1){
        return "Don't put space between numbers";
      }
    }
    catch(error){
      return null;
    }
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
                fontFamily: 'Raleway',
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
    DateFormat dateFormat =  DateFormat();

    String dateTime = dateFormat.add_yMd().add_jm().format(time);
    List<String> splitDateAndTime = dateTime.split(" ");
    return splitDateAndTime[0] + ", " + splitDateAndTime[1] + " " + splitDateAndTime[2];
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
        style: TextStyle(color: Colors.purple[800] ,fontSize: 18, fontFamily:'Raleway',fontWeight: FontWeight.w500));
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
      padding: const EdgeInsets.all(12.0),
      child: Text(heading,
          style: TextStyle(
              fontFamily: 'Raleway',
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500)),
    );
  }

  /// App header
  static Widget appHeaderDivider(){
    return Padding(
      padding: const EdgeInsets.only(top:1.0),
      child: Container(
        height: 8,
        color: Colors.grey[100],
      ),
    );
  }
  /// Method for logging out user
  logoutUser(context) {
    FirebaseAuth.instance.signOut().then((value) {
      try {
        Navigator.of(context).popUntil((route) => route.isFirst);
        AppHelper.cupertinoRouteWithPushReplacement(context, LoginPage());
      } catch (error) {
        print(error);
      }
    }).catchError((error) {
      print(error);
    });
  }

  /// Open image gallery
  static Future openImageGallery() async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    print("Picked file" + file.toString());
    return file;
  }

  /// Open image cropper
  static Future<File> cropImage(File imageFile, maxH, maxW) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      maxWidth: maxW,
      maxHeight: maxH,
    );
    return croppedFile;
  }

  /// Open image gallery, crop and return it
  static Future pickAndCropPhoto(maxHeight, maxWidth) async {
    File image = await AppHelper.openImageGallery();
    print("Image" + image.toString());
    try {
      var croppedImage = await AppHelper.cropImage(image, maxHeight, maxWidth);
      return croppedImage;
    }
    catch(error){
      print(error.toString());
    }

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

  Widget socialMediaWidget(context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Text("Finds us on:",style:TextStyle(
                fontFamily: 'Raleway',
                color: Colors.purple[800],
                fontSize: 18,
                fontWeight: FontWeight.w700)),
          ),
          imageIconButton(context)
        ]
    );
  }

  // Image icon button
  Widget imageIconButton(context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        imageButton(ImageResources.facebookIcon, (){
          AppHelper.cupertinoRoute(context, WebViewPage("Like us on facebook","https://www.facebook.com/Surprize-116204473109749/"));
        }),
        Padding(
          padding: const EdgeInsets.only(left:8.0, right: 8.0),
          child: imageButton(ImageResources.instagramIcon, (){
            AppHelper.cupertinoRoute(context, WebViewPage("Follow us on instagram","https://www.instagram.com/surprize.app/"));
          }),
        ),
        imageButton(ImageResources.twitterIcon, (){
          AppHelper.cupertinoRoute(context, WebViewPage("Follow us on twitter","https://twitter.com/AppSurprize"));
        })
      ],
    );
  }

  Widget imageButton(String image,Function onPressed){
    return GestureDetector(
        child:Image.asset(image, height: 30, width: 30),
        onTap: onPressed
    );
  }

  /// Check for internet connection
  static Future<bool> checkInternetConnection() async {
   try {
     final result = await InternetAddress.lookup('google.com');
     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
     }
   } on SocketException catch (_) {
     return false;
   }
   return null;
 }

  /// Get random number between min and max value
  static int getRandomNumberInBetweenValues(min, max){
    Random rnd = new Random();
    return min + rnd.nextInt(max - min);
  }


  /// Get list of random numbers
  static List<int> randomNumberList(int totalNumber, min, max){
    int i = 0;
    List<int> randomNumbers =[];
    while(i != totalNumber){
      int randomNumber = getRandomNumberInBetweenValues(min, max);
      if(!randomNumbers.contains(randomNumber)){
        randomNumbers.add(randomNumber);
        i++;
      }
    }
    return randomNumbers;
  }

 static Widget settingMenu(context, String name, IconData icon, Function onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Icon(
                    icon,
                    color: Colors.purple,
                  ),
                ),
                FlatButton(
                    child: Text(name,
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w300,
                            fontSize: 18,
                            color: Colors.black)),
                    onPressed: onPressed),
              ],
            )),
      ),
    );
  }
}