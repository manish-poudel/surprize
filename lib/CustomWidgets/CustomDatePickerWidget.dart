import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'CustomTextButtonWidget.dart';

class CustomDatePickerWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomDatePickerWidgetState();
  }
}

class CustomDatePickerWidgetState extends State<CustomDatePickerWidget>{

  String currentDate = "DOB";

  void changeDate(int year, int month, int date){
    setState(() {
      currentDate = year.toString() + "/" + month.toString() + "/" + date.toString();
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
      child: Container(
        height: 58.0,
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
      onTap: (){
        openDatePicker();
      },
    );
  }

}

