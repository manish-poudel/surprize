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
             decoration: InputDecoration.collapsed(
               hintText: "Phone number"
             ),
           )
         )
        ],
      ),
    );
  }
}
