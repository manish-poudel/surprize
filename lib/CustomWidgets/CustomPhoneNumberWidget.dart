import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

class CustomPhoneNumberWidget extends StatefulWidget {

  CustomPhoneNumberWidgetState _state;

  String _initialSelection;
  String _phoneNumber;

  CustomPhoneNumberWidget(this._initialSelection, this._phoneNumber);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
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
    return Container(
      height: 58.0,
      decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4.0))
      ),
      child: Row(
        children: <Widget>[
         CountryCodePicker(
                onChanged: (code) {
                  _countryCode = code.toString();
                  _countryName = code.name;
                },
                initialSelection: widget._initialSelection,
         ),
         Expanded(
           child:TextFormField(
             controller: controller ,
             keyboardType: TextInputType.emailAddress,
              validator: validateMobile,
                onSaved: (String val){
                  _phoneNumberValue = val;
                  },
                 decoration: InputDecoration.collapsed(
               hintText: "Phone number"
             ),
           )
         )
        ],
      ),
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
