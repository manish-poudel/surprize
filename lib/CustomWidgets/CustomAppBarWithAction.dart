import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBarWithAction extends StatelessWidget with PreferredSizeWidget {
  String _appBarTitle;
  BuildContext _context;
  List<Widget> actions;
  CustomAppBarWithAction(this._appBarTitle, this._context, this.actions);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      backgroundColor: Colors.purple[800],
      actions: actions,
      leading: GestureDetector(
        child: Icon(Icons.arrow_back, color: Colors.white),
        onTap: () {
          Navigator.of(_context).pop();
        },
      ),
      title: Text(_appBarTitle, style: TextStyle(fontFamily: 'Raleway'),),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
