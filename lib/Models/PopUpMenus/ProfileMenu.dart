import 'package:flutter/cupertino.dart';

class ProfileMenu{

  final ProfileMenuType profileMenuType;
  final String title;
  final IconData icon;

  ProfileMenu({this.profileMenuType,this.title, this.icon});

}

enum ProfileMenuType{
  EDIT_PAGE,
}