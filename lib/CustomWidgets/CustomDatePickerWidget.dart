import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'CustomTextButtonWidget.dart';

class CustomDatePickerWidget extends StatefulWidget{

  CustomDatePickerWidgetState _customDatePickerWidgetState;

  String getSelectedDate(){
    return _customDatePickerWidgetState.currentDate;
  }

  bool isProperlyValidated(){
   return _customDatePickerWidgetState.isProperlyValidate();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    _customDatePickerWidgetState = CustomDatePickerWidgetState();
    return _customDatePickerWidgetState;
  }
}

class CustomDatePickerWidgetState extends State<CustomDatePickerWidget>{

  String currentDate = "DOB";
  bool _properDateSelected = false;
  bool _showValidation = false;

  /*
  Check for proper validation. If not, also set validation message.
   */
  bool isProperlyValidate(){
    if(!_properDateSelected){
      setState(() {
          _showValidation = true;
      });
    }
    return _properDateSelected;
  }

  void changeDate(int year, int month, int date){
    setState(() {
      currentDate = year.toString() + "/" + month.toString() + "/" + date.toString();
      _properDateSelected = true;
      _showValidation = false;
    });
  }

  String getCurrentDate(){
    return currentDate;
  }
  /*
 Open date picker
  */
  void openDatePicker(){
    DatePicker.showDatePicker(
      context,
      locale: 'i18n',
      showTitleActions: true,
      minYear: 1970,
      maxYear: 2020,
      initialYear: 2018,
      initialMonth: 6,
      initialDate: 21,
      cancel: Text('Cancel'),
      confirm: Text('Confirm'),
      dateFormat: 'yyyy-mm-dd',
      onChanged: (year, month, date) {

      },
      onConfirm: (year, month, date) {
        changeDate(year, month, date);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height:58.0,
            decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4.0))
            ),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon:Icon(Icons.calendar_today, color: Colors.red),
                  tooltip: 'Set date',
                  onPressed: openDatePicker ,
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(currentDate,
                      style: TextStyle(fontSize: 16.0)
                  ),
                )
              ],
            ),
          ),
          Visibility(visible: _showValidation, child: Padding(
            padding: const EdgeInsets.only(top:8.0, left: 16.0),
            child: Text("Enter DOB from calendar", style:
                TextStyle(color:Colors.red, fontSize: 11.0)),
          )),
        ],
      ),
      onTap: (){
        openDatePicker();
      },
    );
  }

}

