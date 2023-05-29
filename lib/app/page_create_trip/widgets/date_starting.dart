import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateStarting extends StatelessWidget {
  DateStarting(
      {super.key,
      required this.date,
      required this.time,
      required this.updateDate,
      required this.updateTime,
      required this.context});
  BuildContext context;
  DateTime date;
  DateTime time;
  Function updateDate;
  Function updateTime;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: DefaultTextStyle(
        style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.0,
            color: Color.fromRGBO(44, 58, 71, 1)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _DatePickerItem(
                children: <Widget>[
                  const Text('Date'),
                  CupertinoButton(
// Display a CupertinoDatePicker in date picker mode.
                    onPressed: () => _showDialog(
                      CupertinoDatePicker(
                        initialDateTime: date,
                        use24hFormat: true,
                        mode: CupertinoDatePickerMode.date,
                        minimumDate: date,
                        maximumYear: date.year + 2,
// This is called when the user changes the date.
                        onDateTimeChanged: (DateTime newDate) {
                          updateDate(newDate);
                          updateTime(newDate);
                        },
                      ),
                    ),
                    child: Chip(
                      avatar: const Icon(
                        Icons.calendar_month_sharp,
                        color: Color.fromRGBO(48, 51, 107, 1),
                        size: 20,
                      ),
                      label: Text(
                        '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
              _DatePickerItem(
                children: <Widget>[
                  const Text('Heure de départ'),
                  CupertinoButton(
// Display a CupertinoDatePicker in time picker mode.
                    onPressed: () => _showDialog(
                      CupertinoDatePicker(
                        initialDateTime: time,
                        mode: CupertinoDatePickerMode.time,
                        minimumDate: time,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newTime) {
                          updateTime(newTime);
                        },
                      ),
                    ),
                    child: Chip(
                      avatar: const Icon(
                        Icons.timelapse_rounded,
                        color: Color.fromRGBO(48, 51, 107, 1),
                        size: 20,
                      ),
                      label: Text(
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// This class simply decorates a row of widgets.
class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}
