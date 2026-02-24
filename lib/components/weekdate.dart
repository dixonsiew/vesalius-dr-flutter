import 'package:flutter/material.dart';
import 'package:vesalius_dr_flutter/constants.dart';

class WeekDate extends StatefulWidget {

  final DateTime selectedDate;
  final Function(DateTime) onWeekDateSelected;

  const WeekDate({
    super.key,
    required this.selectedDate,
    required this.onWeekDateSelected,
  });

  @override
  State<WeekDate> createState() => _WeekDateState();
}

class _WeekDateState extends State<WeekDate> {

  late DateTime first;
  late DateTime last;

  @override
  void initState() {
    super.initState();
    first = findFirstDateOfTheWeek(widget.selectedDate);
    last = findLastDateOfTheWeek(widget.selectedDate);
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    if (dateTime.weekday == DateTime.sunday) {
      return dateTime;
    }

    return dateTime.subtract(Duration(days: dateTime.weekday));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    if (dateTime.weekday == DateTime.saturday) {
      return dateTime;
    }

    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday - 1));
  }

  DateTime getNextday(DateTime dt) {
    return dt.add(const Duration(days: 1));
  }

  String getWeek(int x) {
    List<String> ls = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return ls[x];
  }

  List<Widget> getWeeks() {
    List<Widget> lx = [];
    DateTime a = findFirstDateOfTheWeek(widget.selectedDate);
    for (int i = 0; i < 7; i++) {
      DateTime b = a.add(Duration(days: i));
      lx.add(
        InkWell(
          onTap: () {
            widget.onWeekDateSelected(b);
          },
          borderRadius: BorderRadius.circular(50.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 13),
            decoration: BoxDecoration(
              color: b.compareTo(widget.selectedDate) == 0 ? const Color(0xFFA41D2B) : Colors.transparent,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  getWeek(i),
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: b.compareTo(widget.selectedDate) == 0 ? Colors.white : const Color(0xFFADADAD),
                  ),
                ),
                const SizedBox(height: 10),
                Text('${b.day}',
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: b.compareTo(widget.selectedDate) == 0 ? Colors.white : kTextColor5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return lx;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: getWeeks(),
    );
  }
}