import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

class CustomPhoneNumberWidget extends StatefulWidget {

  CustomPhoneNumberWidgetState _state;

  String _initialSelection;
  String _phoneNumber;
  Color color;

  CustomPhoneNumberWidget(this._initialSelection, this._phoneNumber, this.color);

  @override
  State<StatefulWidget> createState() {
    _state = CustomPhoneNumberWidgetState(_phoneNumber);
    return _state;
  }

  String getCountryCode(){
    return _state.getCountryCode();
  }

  String getPhoneNumber(){
    return _state.getPhoneNumber();
  }

  String getCountryName() {
    return _state._countryName;
  }
}

class CustomPhoneNumberWidgetState extends State<CustomPhoneNumberWidget> {
  String _countryCode;
  String _countryName;

  final TextEditingController controller = TextEditingController();

  CustomPhoneNumberWidgetState(String phoneNumber){
    controller.text = phoneNumber;
  }

  String getCountryCode(){
    return _countryCode;
  }

  String getPhoneNumber(){
   String getPhoneNumber = controller.text;
   return getPhoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    String _phoneNumberValue;
    // TODO: implement build
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
           Expanded(
             child:TextFormField(
               style: TextStyle(fontFamily: 'Raleway', color:widget.color),
               controller: controller ,
               keyboardType: TextInputType.emailAddress,
                validator: validateMobile,
                  onSaved: (String val){
                    _phoneNumberValue = val;
                    },
                   decoration: InputDecoration.collapsed(
                 hintText: "Phone number",
                     hintStyle: TextStyle(color: Colors.grey)
               ),
             )
           )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: Container(height: 1, color: widget.color),
        )
      ],
    );
  }

  /*
  Validate mobile
   */
  static String validateMobile(String value) {
    if(value.isEmpty){
      return null;
    }
    if(double.tryParse(value) == null){
      return 'Enter correct digits';
    }
    return null;
  }

}
