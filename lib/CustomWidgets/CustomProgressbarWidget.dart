import 'package:flutter/material.dart';
import 'package:surprize/Helper/AppColor.dart';
import 'package:surprize/Helper/AppHelper.dart';

class CustomProgressbarWidget {

  // End progress bar
  stopAndEndProgressBar(context){
    Navigator.of(context).pop();
  }

  // Start progress bar
  startProgressBar(context, String progressValue){
    showDialog(context: context,
        builder: (BuildContext context){
          return Dialog(
            backgroundColor: AppColor.colorPrimary,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(progressValue, style: TextStyle(color: Colors.white),),
                  )
                ],),
              )
          );
        });
  }

}
