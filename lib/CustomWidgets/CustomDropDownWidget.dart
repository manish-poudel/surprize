import 'package:flutter/material.dart';
class CustomDropDownWidget extends StatefulWidget {

  List<String> _listItems;
  String _label;

  CustomDropDownWidget(this._listItems, this._label);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomDropDownWidgetState(_listItems, _label);
  }
}
  class CustomDropDownWidgetState extends State<CustomDropDownWidget>{

  List<String> _listItems;
  String _label;
  String _selectedItem = 'Male';

  CustomDropDownWidgetState(this._listItems, this._label);

  void onChanged(String value){
    setState(() {
      _selectedItem = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        hint:Text(_label),
        value: _selectedItem,
        items:  _listItems.map((String value){
          return new DropdownMenuItem<String>(
              value:value,
              child: new Text(value));
        }).toList(),
        onChanged: (String value){
          onChanged(value);
        },
      ),
    );
  }

}