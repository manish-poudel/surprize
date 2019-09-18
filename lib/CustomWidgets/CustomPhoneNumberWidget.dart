import 'package:Surprize/Resources/CountryResources.dart';
import 'package:flutter/material.dart';

class CustomPhoneNumberWidget extends StatefulWidget {
  CustomPhoneNumberWidgetState _state;

  String _initialSelection;
  String _phoneNumber;
  Color color;
  Function validation;

  CustomPhoneNumberWidget(
      this._initialSelection, this._phoneNumber, this.color, {this.validation});

  @override
  State<StatefulWidget> createState() {
    _state = CustomPhoneNumberWidgetState(_phoneNumber);
    return _state;
  }

  String getCountryCode() {
    return _state.getCountryCode();
  }

  String getPhoneNumber() {
    return _state.getPhoneNumber();
  }
}

class CustomPhoneNumberWidgetState extends State<CustomPhoneNumberWidget> {
  String _phoneNumberValue;

  CountryNameAndCode selectedItem;

  Map<String, CountryNameAndCode> countryNameAndCode;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    countryNameAndCode = new Map();
    CountryResources.getCountryAndCodeList.forEach((map) {
      countryNameAndCode.putIfAbsent(map["code"],() => CountryNameAndCode(map["code"], map["name"]));
    });

    selectedItem = countryNameAndCode[widget._initialSelection];
    super.initState();
  }

  CustomPhoneNumberWidgetState(String phoneNumber) {
    controller.text = phoneNumber;
  }

  String getCountryCode() {
    return selectedItem.countryCode;
  }

  String getPhoneNumber() {
    String getPhoneNumber = controller.text;
    return getPhoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        countryCodeDropDown(),
        Expanded(
            child: TextFormField(
          decoration: InputDecoration(
            hintText: "Phone number",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple),
            ),
          ),
          style: TextStyle(fontFamily: 'Raleway', color: widget.color),
          controller: controller,
          keyboardType: TextInputType.number,
          validator: widget.validation,
          onSaved: (String val) {
            _phoneNumberValue = val;
          },
        ))
      ],
    );
  }


  // Country drop down
  Widget countryCodeDropDown() {
    return DropdownButton<CountryNameAndCode>(
      hint: Text("Phone code", style: TextStyle(fontFamily: 'Raleway')),
      underline: Container(
        height: 0,
        color: Colors.white,
      ),
      iconSize: 0,
      value: selectedItem,
      items: countryNameAndCode.values.toList().map((CountryNameAndCode code) {
        return new DropdownMenuItem(
            value: code,
            child: new Text(
                code.countryCode +
                    "   " +
                    code.countryName.substring(0, 3).toUpperCase(),
                style: TextStyle(fontFamily: 'Raleway')));
      }).toList(),
      onChanged: (CountryNameAndCode countryNameAndCode) {
        onChanged(countryNameAndCode);
      },
    );
  }

  // On drop down value changed
  void onChanged(CountryNameAndCode value) {
    setState(() {
      selectedItem = value;
    });
  }
}

class CountryNameAndCode {
  String countryCode;
  String countryName;

  CountryNameAndCode(this.countryCode, this.countryName);
}
