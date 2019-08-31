import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  String _appBarTitle;
  BuildContext _context;
  CustomAppBar(this._appBarTitle, this._context);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back, color: Colors.white),
          onTap: () {
            Navigator.of(_context).pop();
          },
        ),
        title: Text(_appBarTitle),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
