import 'package:flutter/material.dart';

/***
 * Custom text field  widget with a label
 */

class CustomLabelTextFieldWidget extends StatefulWidget {

  String _value = "";
  String _label = "";
  _CustomLabelTextFieldWidgetState _state;
  Color _color = Colors.white;
  Function _validation;

  CustomLabelTextFieldWidget(String label, String value, Color color, {Function validation}) {
    _value = value;
    _label = label;
    _color = color;
    _validation = validation;
  }

  String getValue() {
    return _state.getValue();
  }

   setValue(String value){
    value = value;
    _state.setValue(value);
  }

  @override
  State<StatefulWidget> createState() {
    _state =  _CustomLabelTextFieldWidgetState(_label, _color, _validation, _value);
    return _state;
  }

}

class _CustomLabelTextFieldWidgetState
    extends State<CustomLabelTextFieldWidget> {
  String _label = "";
  Function _validation;
  String _value = "";
  Color _color = Colors.white;
  final textcontroller = TextEditingController();

  _CustomLabelTextFieldWidgetState(String label, Color color, Function validation, value) {
    _label = label;
    _color = color;
    _validation = validation;
      textcontroller.text = _value = value;
  }

  String getValue() {
    return textcontroller.text;
  }

   setValue(String value){
    setState(() {
      textcontroller.text = value;
      _value = value;
    });
  }

  @override
  Widget build(context) {
    return Container(
        child: Row(children: <Widget>[
      Flexible(
          child: TextFormField(
        controller: textcontroller,
        keyboardType: TextInputType.emailAddress,
        validator: _validation,
        onSaved: (String val){
          _value = val;
        },
        decoration: InputDecoration(
            filled: true,
            border: InputBorder.none,
            enabled: true,
            labelText: _label,
            fillColor: _color,
            enabledBorder:
                OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.white,width: 1.0))),
      ))
    ]));
  }

}
