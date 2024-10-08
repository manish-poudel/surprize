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
  bool showText;
  bool enabled = true;

  CustomLabelTextFieldWidget(String label, String value, Color color, bool showText,{Function validation,bool enabled}) {
    _value = value;
    _label = label;
    _color = color;
    _validation = validation;
    this.showText = showText;
    this.enabled = enabled;
  }

  void changeEnabled(bool val){
    enabled = val;
    _state.changeEnable(val);
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
    _state =  _CustomLabelTextFieldWidgetState(_label, _color, _validation, _value, enabled);
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
  bool enabled;

  _CustomLabelTextFieldWidgetState(String label, Color color, Function validation, value, bool enabled) {
    _label = label;
    _color = color;
    _validation = validation;
      textcontroller.text = _value = value;
      this.enabled = enabled;
  }

  changeEnable(bool val){
    setState(() {
     enabled = val;
    });
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
    return TextFormField(
      style: TextStyle(fontFamily: 'Raleway', color: _color),
    controller: textcontroller,
    keyboardType: TextInputType.emailAddress,
    validator: _validation,
    obscureText: widget.showText,
    enabled: enabled == null?true:enabled,
    onSaved: (String val){
    _value = val;
    },
        decoration: InputDecoration(
          fillColor: _color,
          hintText: _label,
          hintStyle: TextStyle(color:Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: _color),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),
          ),
        )
    );
  }

}
