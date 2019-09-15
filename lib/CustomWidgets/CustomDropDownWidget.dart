import 'package:flutter/material.dart';
class CustomDropDownWidget extends StatefulWidget {

  List<String> _listItems;
  String _selectedItem;
  String _label;
  CustomDropDownWidgetState _state;
  Color _color;
  Color _canvasColor;

  CustomDropDownWidget(this._listItems, this._selectedItem, this._label, this._color, this._canvasColor);

  @override
  State<StatefulWidget> createState() {
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
    return Theme(
        data: new ThemeData(
            canvasColor: widget._canvasColor,
            hintColor: widget._color),
      child: DropdownButton<String>(
        hint:Text(_label,style: TextStyle(fontFamily: 'Raleway')),
        underline: Container(
          height: 1,
          color: widget._color,
        ),
        iconSize: 0,
        value: _selectedItem,
        items:  _listItems.map((String value){
          return new DropdownMenuItem<String>(
              value:value,
              child: new Text(value,style: TextStyle(fontFamily: 'Raleway',color: widget._color)));
        }).toList(),
        onChanged: (String value){
          onChanged(value);
        },
      ),
    );
  }

}