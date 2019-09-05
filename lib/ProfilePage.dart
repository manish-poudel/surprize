import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surprize/CustomWidgets/CustomAppBarWithAction.dart';
import 'package:surprize/EditProfilePage.dart';
import 'package:surprize/Memory/UserMemory.dart';
import 'package:surprize/Models/Player.dart';

import 'CustomWidgets/CustomRecentActiviyWidget.dart';
import 'Helper/AppHelper.dart';
import 'Models/Activity.dart';
import 'Models/PopUpMenus/ProfileMenu.dart';
import 'Resources/ImageResources.dart';
import 'UserProfileManagement/UserBLOC.dart';
import 'UserProfileManagement/UserProfile.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  Player _player = UserMemory().getPlayer();
  double _screenHeight;
  double _imageUploadProgressValue;
  bool _isImageLoading = false;
  UserBLOC _userBLOC;

  List<ProfileMenu> _popUpMenuChoice = [ProfileMenu(profileMenuType:ProfileMenuType.EDIT_PAGE,
      title: "Edit Profile",
      icon: Icons.edit)];

  @override
  void initState() {
    super.initState();
    _userBLOC = UserBLOC();
    _userBLOC.init();
    _userBLOC.playerEventSink.add("Player");
    getRecentActivityList();
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
            appBar: CustomAppBarWithAction("Profile", context, appBarActions()
            ),
            body: SingleChildScrollView(
                child: StreamBuilder(
                        stream: _userBLOC.player,
                        builder: (BuildContext context, AsyncSnapshot<Player> playerSnapshot){
                          _player = playerSnapshot.data;
                          print("Player" + _player.toString());
                            if(_player == null){
                             return noProfileDisplay();
                            }
                          return displayProfile();
                        }))));
  }

  /// App bar actions
  List<Widget> appBarActions(){
   return [
      PopupMenuButton<ProfileMenu>(
          onSelected: _OnPopUpMenuItemSelected,
          itemBuilder: (BuildContext context){
              return _popUpMenuChoice.map((ProfileMenu menu){
                return PopupMenuItem<ProfileMenu>(
                  value: menu,
                  child:ListTile(leading: Icon(menu.icon), title:Text(menu.title))
                );
              }).toList();
          },
      )
   ];
  }

  /// If pop up menu item is selected
  void _OnPopUpMenuItemSelected(ProfileMenu value){
    if(value.profileMenuType == ProfileMenuType.EDIT_PAGE){
      Navigator.push(
          context,
          CupertinoPageRoute(
          builder: (context) => EditProfilePage()));
    }
  }


  @override
  void dispose() {
    super.dispose();
    _userBLOC.dispose();
  }

  /// If no profile exists
  Widget noProfileDisplay() {
    return Padding(
      padding: EdgeInsets.only(top: _screenHeight / 2 - 92),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(backgroundColor: Colors.purple),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: CircularProgressIndicator(),
          )
        ],
      )),
    );
  }

  Widget displayProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(child: profilePhotoContainer()),
        personalInformationHolder(),
        AppHelper.appHeaderDivider(),
        AppHelper.appSmallHeader("Recent Activities"),
        Container(child: recentActivityList()),
      ],
    );
  }

  Widget numberDisplayWidget() {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: <Widget>[
          Center(
              child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Text("Score",
                style: TextStyle(
                    color: Colors.black, fontSize: 18.0, fontFamily: 'Roboto')),
          )),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("20",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w200,
                      fontFamily: 'Roboto')))
        ],
      ),
    );
  }

  var image = "";
  /*
  User profile photo container
   */
  Widget profilePhotoContainer() {
    return Container(
      color: Colors.purple[800],
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /// Photo of player
          circularPhotoContainer(),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              _player.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              _player.country,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  /// Circular photo container
  Widget circularPhotoContainer() {
    return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Center(
          child: GestureDetector(
            onTap: () => pickPhoto(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _player.profileImageURL.isEmpty
                              ? AssetImage(
                                  ImageResources.emptyUrlPlaceHolderImage)
                              : CachedNetworkImageProvider(
                                  _player.profileImageURL),
                          fit: BoxFit.fill)),
                  child:      /// Image upload progress
                  Visibility(
                      visible: _isImageLoading,
                      child: CircularProgressIndicator(
                          value: _imageUploadProgressValue,
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.purple[600]))),
                ),
              ],
            ),
          ),
        ));
  }

  /// Profile information holder
  Widget personalInformationHolder() {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(children: <Widget>[
          textWithIcon(Icons.email, _player.email, Colors.purple),
          textWithIcon(Icons.phone, _player.phoneNumber, Colors.purple),
          textWithIcon(Icons.calendar_today, _player.dob, Colors.purple),
          textWithIcon(Icons.place, _player.address, Colors.purple),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: textWithIcon(
                Icons.people_outline, _player.gender, Colors.purple),
          ),
        ]),
      ),
    );
  }

  /*
  Widget for text with icon
   */
  Widget textWithIcon(IconData iconData, String text, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Card(child: Icon(iconData, color: color)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              text,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.purple[800]),
            ),
          ),
        )
      ],
    );
  }

  List<Activity> _recentActivityList = List();

  /// Get all recent activity list
  Widget recentActivityList() {
    if (_recentActivityList.length == 0)
      return Center(
          child: Text("No recent activities",
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey)));

    /// Sort the recent activity list
    _recentActivityList.sort((Activity activity, Activity activity2) =>
        activity2.id.compareTo(activity.id));

    return Container(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _recentActivityList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CustomRecentActivityWidget(_recentActivityList[index]),
            );
          }),
    );
  }

  /// Get and listen recent activity list
  void getRecentActivityList() {
    UserProfile().getActivity(_player.membershipId, (Activity activity) {
      setState(() {
        _recentActivityList.add(activity);
      });
    });
  }

  /// Method to pick photo
  pickPhoto() async {
    File image = await AppHelper.pickAndCropPhoto(520, 520);
    if (image != null) {
      uploadImage(image);
    }
  }

  /// Upload image to server
  uploadImage(File url) {
    StorageUploadTask uploadTask =
        UserProfile().uploadFileToStorage(url, _player.membershipId);
    listenImageUploadProgress(uploadTask);
  }

  /// Listen for image upload progress
  void listenImageUploadProgress(StorageUploadTask uploadTask) {
    /// Uploading events
    uploadTask.events.listen((event) {
      setState(() {
        _isImageLoading = true;
        _imageUploadProgressValue = event.snapshot.bytesTransferred.toDouble() /
            event.snapshot.totalByteCount.toDouble();
      });
    });

    /// If upload is completed
    uploadTask.onComplete.then((snapshot) {
      snapshot.ref.getDownloadURL().then((url) {
        afterImageUploaded(url);
      });
    });
  }

  /// After image is uploaded to database
  void afterImageUploaded(String url) {
    UserProfile()
        .addProfileImageToFirestore(_player.membershipId, url)
        .then((value) {
      setState(() {
        _isImageLoading = false;
        _player.profileImageURL = url;
        UserMemory().getPlayer().profileImageURL = url;
      });
    });
  }
}
