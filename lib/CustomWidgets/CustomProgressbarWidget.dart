import 'package:flutter/material.dart';

class CustomProgressbarWidget {

  BuildContext _selfContext;
  // End progress bar
  stopAndEndProgressBar(context){
    try {
      Navigator.of(_selfContext).pop();
    }
    catch(error){}
  }

  // Start progress bar
  startProgressBar(context, String progressValue, Color color, Color color2){
    showDialog(context: context,
        builder: (BuildContext context){
      this._selfContext = context;
          return Container(
            child: Dialog(
              backgroundColor: color,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: <Widget>[
                    CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(
                        color2)),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(progressValue, style: TextStyle(color: color2, fontFamily: 'Raleway')),
                    )
                  ],),
                )
            ),
          );
        });
  }

}
