import 'package:add_2_calendar/add_2_calendar.dart';

class CalendarEventManagement{

  addEventToCalendar(String title, String description, DateTime startDate, DateTime enDate){
    final Event event = Event(
        title: title,
        description: description,
        startDate: startDate,
        endDate: enDate
    );

    Add2Calendar.addEvent2Cal(event);
  }
}