import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';

class CustomCountryPickerWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomCountryPickerWidgetState();
  }
}

class CustomCountryPickerWidgetState extends State<CustomCountryPickerWidget>{
  Country country;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 58.0,
      child: CountryPicker(
          onChanged: (Country country){
            setState(() {
              country = country;
            });
          }),
    );
  }

}