import 'package:Surprize/CustomWidgets/CustomDropDownWidget.dart';
import 'package:Surprize/Resources/CountryResources.dart';
import 'package:flutter/material.dart';

class CustomCountryPickerWidget extends StatefulWidget {

  _CustomCountryPickerWidgetState state;
  String initialSelection;

  CustomCountryPickerWidget(this.initialSelection);

  getValue(){
   return state.getPickedValue();
  }

  @override
  _CustomCountryPickerWidgetState createState() {
    state = _CustomCountryPickerWidgetState();
    return state;
  }
}

class _CustomCountryPickerWidgetState extends State<CustomCountryPickerWidget> {

  List<String> country;
  CustomDropDownWidget customDropDownWidget;

  getPickedValue(){
    return customDropDownWidget.selectedItem();
  }


  @override
  void initState() {
    super.initState();
    country = new List();
    CountryResources.getCountryAndCodeList.forEach((map){
      country.add(map["name"].toString());
    });
    customDropDownWidget = CustomDropDownWidget(country, widget.initialSelection, "Select country", Colors.black, Colors.white);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: customDropDownWidget,
        ));
  }
}
