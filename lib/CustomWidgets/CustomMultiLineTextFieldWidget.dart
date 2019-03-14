import 'package:flutter/material.dart';

/***
 * Custom text field  widget with a label
 */

class CustomMultiLineTextFieldWidget extends StatefulWidget{

  String _label ="";
  CustomMultiLineTextFieldWidgetState _state;
  Color _color = Colors.white;

  CustomMultiLineTextFieldWidget(String label, Color color){
    _label = label;
    _color = color;
  }


  String getValue()
  {
    return _state.getValue();
  }

  State<StatefulWidget> createState(){
    _state = new CustomMultiLineTextFieldWidgetState(_label, _color);
    return _state;
  }
}

class CustomMultiLineTextFieldWidgetState extends State <CustomMultiLineTextFieldWidget>
{
  String _label = "";
  String _value ="";
  Color _color = Colors.white;
  final textFldcontroller = TextEditingController();

  CustomMultiLineTextFieldWidgetState(String label, Color color){
    _label = label;
    _color = color;
  }

  String getValue()
  {
    return textFldcontroller.text;
  }

  @override
  Widget build(context) {
    return Container(child: Row(
        children:<Widget>[
          Flexible(child:
          TextField(controller: textFldcontroller,
            decoration: InputDecoration(
                filled: true,
                enabled: true,
                labelText:_label,
                fillColor: _color,
                border:InputBorder.none,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.0)
                )

            ),
          maxLines: null,
            keyboardType: TextInputType.multiline,
          )


          )
        ]

    ));
  }
}

