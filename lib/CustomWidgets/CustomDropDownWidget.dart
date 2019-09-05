import 'package:flutter/material.dart';
class CustomDropDownWidget extends StatefulWidget {

  List<String> _listItems;
  String _selectedItem;
  String _label;
  CustomDropDownWidgetState _state;

  CustomDropDownWidget(this._listItems, this._selectedItem, this._label);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    _state = CustomDropDownWidgetState(_listItems, _label, this._selectedItem);
    return _state;
  }

  String selectedItem(){
    return _state._selectedItem;
  }
}
  class CustomDropDownWidgetState extends State<CustomDropDownWidget>{

  List<String> _listItems;
  String _label;
  String _selectedItem = 'Male';

  CustomDropDownWidgetState(this._listItems, this._label,this._selectedItem);

  String returnSelectedItem(){
    return _selectedItem;
  }

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