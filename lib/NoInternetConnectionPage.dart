
import 'package:Surprize/Dashboard.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Models/NoNetwork.dart';
import 'package:Surprize/OfflineQuizLetterView.dart';
import 'package:Surprize/PlayerDashboard.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoInternetConnectionPage extends StatefulWidget {

  Source _source;

  NoInternetConnectionPage(this._source);

  @override
  _NoInternetConnectionPageState createState() => _NoInternetConnectionPageState();
}

class _NoInternetConnectionPageState extends State<NoInternetConnectionPage> {

  var subscription;

  @override
  void initState() {
    super.initState();
    checkForNetworkConnection();
  }


  checkForNetworkConnection(){
    print("Checking....");
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
        AppHelper.checkInternetConnection().then((val){
          if(val){
           handleOnNetworkConnection();
          }
        });
      }});
  }


  @override
  void dispose() {
    subscription.cancel();
    subscription = null;
    super.dispose();
  }


  /// Handle after network connection arrives
  handleOnNetworkConnection(){
    switch(widget._source){
      case Source.SPLASH_SCREEN:
        Future.delayed(Duration(seconds: 5),() => Dashboard(context).nav());
        break;
      case Source.PLAYER_DASHBOARD:
        Future.delayed(Duration(seconds: 5),() => Dashboard(context).nav());
        break;
      default:

    }
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
          appBar: AppBar(title: Text("No Internet Connection",style: TextStyle(fontFamily: 'Raleway'))),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                  Icon(Icons.signal_wifi_off,size: 60, color: Colors.grey),
                  Text("Seems like you don't have active internet connection!",style: TextStyle(color: Colors.grey,fontFamily: 'Raleway')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Until it gets back, you can check out your favourite quiz letters",style: TextStyle(color: Colors.grey,fontFamily: 'Raleway')),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.refresh, color:Colors.white),
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: Text("Refresh",style: TextStyle(color: Colors.white),),
                              ),
                            ],
                          ),
                          color: Colors.purple,
                          onPressed: (){
                           checkForNetworkConnection();
                          },
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                      ),
                      RaisedButton(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.favorite, color:Colors.white),
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: Text("Quiz Letters",style: TextStyle(color: Colors.white),),
                              ),
                            ],
                          ),
                          color: Colors.purple,
                          onPressed: (){
                              AppHelper.cupertinoRoute(context, OfflineQuizLetterView());
                          },
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

}
