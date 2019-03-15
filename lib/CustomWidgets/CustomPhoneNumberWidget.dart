import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

class CustomPhoneNumberWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomPhoneNumberWidgetState();
  }
}

class CustomPhoneNumberWidgetState extends State<CustomPhoneNumberWidget> {
  String countryCode;
  final TextEditingController controller = TextEditingController();

  String getCountryCode(){
    return countryCode;
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
                  countryCode = code.toString();
                },
                initialSelection: 'USA',
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
