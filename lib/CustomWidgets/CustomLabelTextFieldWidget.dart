import 'package:flutter/material.dart';

/***
 * Custom text field  widget with a label
 */

class CustomLabelTextFieldWidget extends StatefulWidget {

  String _label = "";
  _CustomLabelTextFieldWidgetState _state;
  Color _color = Colors.white;
  Function _validation;

  CustomLabelTextFieldWidget(String label, Color color, {Function validation}) {
    _label = label;
    _color = color;
    _validation = validation;
  }

  String getValue() {
    return _state.getValue();
  }

  State<StatefulWidget> createState() {
    _state = new _CustomLabelTextFieldWidgetState(_label, _color, _validation);
    return _state;
  }
}

class _CustomLabelTextFieldWidgetState
    extends State<CustomLabelTextFieldWidget> {
  String _label = "";
  Function _validation;
  String _value = "";
  Color _color = Colors.white;
  final textFldcontroller = TextEditingController();

  _CustomLabelTextFieldWidgetState(String label, Color color, Function validation) {
    _label = label;
    _color = color;
    _validation = validation;
  }

  String getValue() {
    return textFldcontroller.text;
  }

  @override
  Widget build(context) {
    return Container(
        child: Row(children: <Widget>[
      Flexible(
          child: TextFormField(

        controller: textFldcontroller,
        keyboardType: TextInputType.emailAddress,
        validator: _validation,
        onSaved: (String val){
          _value = val;
        },
        decoration: InputDecoration(
            filled: true,
            border: UnderlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            enabled: true,
            labelText: _label,
            fillColor: _color,
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(width: 0.0))),
      ))
    ]));
  }

}
