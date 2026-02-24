import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vesalius_dr_flutter/components/weekdate.dart';
import 'package:vesalius_dr_flutter/constants.dart';

class Appointment extends StatefulWidget {
  
  static const String routeName = '/Appointment';

  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {

  late DateTime selectedDateWeekly;
  late DateTime selectedDateMonthly;
  String currentMonthWeekly = '';
  String currentMonthMonthly = '';
  bool isCalendarVisible = false;
  // bool _isCalendarVisible = false;
  bool hideCalendar = false;
  bool isMonthly = false;
  // late ScrollController scrollController;

  @override
  void initState() {
    // scrollController = ScrollController();
    // scrollController.addListener(() {
    //   /* print(scrollController.offset);
    //   if (isMonthly && _isCalendarVisible) {
    //     if (scrollController.offset >= 330 && !scrollController.position.outOfRange) {
    //       setState(() {
    //         isCalendarVisible = false;
    //         hideCalendar = true;
    //       });
    //     }

    //     if (scrollController.offset <= 45 && !scrollController.position.outOfRange) {
    //       setState(() {
    //         isCalendarVisible = true;
    //         hideCalendar = false; 
    //       });
    //     }
    //   }

    //   else if (!isMonthly && _isCalendarVisible) {
    //     if (scrollController.offset >= 150 && !scrollController.position.outOfRange) {
    //       setState(() {
    //         isCalendarVisible = false;
    //       });
    //     }

    //     if (scrollController.offset <= 45 && !scrollController.position.outOfRange) {
    //       setState(() {
    //         isCalendarVisible = true;
    //       });
    //     }
    //   }

    //   else if (!_isCalendarVisible) {
    //     if (scrollController.offset >= 60 && !scrollController.position.outOfRange) {
    //       setState(() {
    //         hideCalendar = true;
    //       });
    //     }

    //     if (scrollController.offset <= 45 && !scrollController.position.outOfRange) {
    //       setState(() {
    //         hideCalendar = false;
    //       });
    //     }
    //   } */
      
    //   // if (scrollController.offset <= scrollController.position.minScrollExtent && !scrollController.position.outOfRange) {
        
    //   // }
    // });
    super.initState();
    load();
  }

  void load() async {
    setState(() {
      selectedDateWeekly = DateTime.now();
      selectedDateMonthly = DateTime.now();
      currentMonthWeekly = formatWeekly(selectedDateWeekly);
      currentMonthMonthly = formatWeekly(selectedDateMonthly);
      // currentMonth = DateFormat.yMMMM().format(selectedDate);
    });
  }

  Widget tick() {
    return Image.asset(
      'images/tick.png',
      width: 16.0,
      height: 16.0,
      fit: BoxFit.cover,
    );
  }

  String formatWeekly(DateTime dt) {
    return formatDate(dt, [d, ' ', MM, ' ', yyyy, ', ', DD]);
  }

  void showFilter() async {
    bool currIsMonthly = isMonthly;
    bool? b = await Get.dialog(StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        contentPadding: const EdgeInsets.only(top: 13.0, bottom: 30.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: IconButton(
                  onPressed: () => Get.back(),
                  splashRadius: 22.0,
                  iconSize: 28.0,
                  icon: const Icon(
                    Icons.close,
                    color: kTextColor2,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Sort Appointment By',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF01274A),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            InkWell(
              onTap: () {
                setState(() {
                  currIsMonthly = false;
                });
                Navigator.pop(context, currIsMonthly);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Weekly',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF01274A),
                        ),
                      ),
                    ),
                    currIsMonthly ? Container() : tick(),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  currIsMonthly = true;
                });
                Navigator.pop(context, currIsMonthly);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Monthly',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF01274A),
                        ),
                      ),
                    ),
                    currIsMonthly == false ? Container() : tick(),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
    if (b != null) {
      setState(() {
        isMonthly = b;
        if (isMonthly) {
          currentMonthMonthly = DateFormat.yMMMM().format(selectedDateMonthly);
        }

        else {
          currentMonthWeekly = formatWeekly(selectedDateWeekly);
        }
      });
    }
  }

  /* CalendarCarousel<Event> getWeeklyCalendar1() {
    final calendarCarousel = CalendarCarousel<Event>(
      height: 75.0,
      weekFormat: true,
      showHeader: false,
      todayBorderColor: const Color(0xFFA41D2B),
      todayButtonColor: const Color(0xFFA41D2B),
      selectedDayBorderColor: const Color(0xFFA41D2B),
      selectedDayButtonColor: const Color(0xFFA41D2B),
      daysTextStyle: const TextStyle(
        fontFamily: kBodyFont,
        color: Colors.black,
      ),
      todayTextStyle: const TextStyle(
        fontFamily: kBodyFont,
      ),
      selectedDayTextStyle: const TextStyle(
        fontFamily: kBodyFont,
      ),
      weekdayTextStyle: const TextStyle(
        fontFamily: kBodyFont,
        fontWeight: FontWeight.w600,
        color: Color(0xFFADADAD),
        letterSpacing: 0.05,
      ),
      weekendTextStyle: const TextStyle(
        fontFamily: kBodyFont,
        fontWeight: FontWeight.w600,
        color: kTextColor5,
        letterSpacing: 0.05,
      ),
      iconColor: Colors.black,
      daysHaveCircularBorder: true,
      selectedDateTime: selectedDateMonthly,
      targetDateTime: selectedDateMonthly,
    );

    return calendarCarousel;
  } */

  CalendarCarousel<Event> getCalendar() {
    final calendarCarousel = CalendarCarousel<Event>(
      height: 280.0,
      showHeader: false,
      showOnlyCurrentMonthDate: true,
      headerTextStyle: const TextStyle(
        fontFamily: kBodyFont,
        fontSize: 16.0,
        color: Color(0xFF8C8C8C),
      ),
      todayBorderColor: Colors.transparent,
      todayButtonColor: Colors.transparent,
      selectedDayBorderColor: kPrimaryColor,
      selectedDayButtonColor: kPrimaryColor,
      daysTextStyle: kTextStyle1.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: kTextColor5,
      ),
      todayTextStyle: kTextStyle1.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w800,
        color: kPrimaryColor,
      ),
      selectedDayTextStyle: kTextStyle1.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w800,
      ),
      weekdayTextStyle: kTextStyle1.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFADADAD),
      ),
      weekendTextStyle: kTextStyle1.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: kTextColor5,
      ),
      iconColor: Colors.black,
      daysHaveCircularBorder: true,
      selectedDateTime: selectedDateMonthly,
      targetDateTime: selectedDateMonthly,
      onDayPressed: (date, events) {
        setState(() {
          selectedDateMonthly = date;
        });
      },
    );

    return calendarCarousel;
  }

  Widget buildWeekly() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          hideCalendar ? const SizedBox.shrink() : const SizedBox(height: 27.0),
          hideCalendar ? const SizedBox.shrink() : 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 17.0),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      isCalendarVisible = !isCalendarVisible;
                      //_isCalendarVisible = isCalendarVisible;
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: kPrimaryColor,
                  ),
                  child: Row(
                    children: [
                      Text(
                        currentMonthWeekly,
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          isCalendarVisible ? 'images/up.png' : 'images/down.png',
                          width: 10.0,
                          height: 5.48,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 16.0,
                    height: 16.0,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          selectedDateWeekly = selectedDateWeekly.subtract(const Duration(days: 7));
                          currentMonthWeekly = formatWeekly(selectedDateWeekly);
                        });
                      },
                      padding: EdgeInsets.zero,
                      splashRadius: 20.0,
                      icon: Image.asset(
                        'images/left.png',
                        width: 16.0,
                        height: 16.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 25.0),
                    child: SizedBox(
                      width: 16.0,
                      height: 16.0,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            selectedDateWeekly = selectedDateWeekly.add(const Duration(days: 7));
                            currentMonthWeekly = formatWeekly(selectedDateWeekly);
                          });
                        },
                        padding: EdgeInsets.zero,
                        splashRadius: 20.0,
                        icon: Image.asset(
                          'images/right.png',
                          width: 16.0,
                          height: 16.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Visibility(
            visible: isCalendarVisible & !hideCalendar,
            maintainState: true,
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 12.0),
              child: WeekDate(
                selectedDate: selectedDateWeekly,
                onWeekDateSelected: (DateTime dt) {
                  setState(() {
                    selectedDateWeekly = dt;
                    currentMonthWeekly = formatWeekly(dt);
                  });
                },
              ),
            ),
          ),
          hideCalendar ? const SizedBox.shrink() : const SizedBox(height: 35.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFdbdbdb).withValues(alpha: 0.35),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        hideCalendar = !hideCalendar;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      width: 50.0,
                      height: 4.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDADADA),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  'Upcoming Appointment',
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: kTextColor1,
                  ),
                ),
                const SizedBox(height: 22.0),
                Row(
                  children: [
                    SizedBox(
                      width: 35.0,
                      child: Text(
                        '09:00',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    Container(
                      width: 5.0,
                      height: 5.0,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 1.0,
                        color: const Color(0xFFFFD4D4),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 49.0),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: kBgColor2.withValues(alpha: 0.7),
                        blurRadius: 7.0,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 5.0),
                    padding: const EdgeInsets.only(top: 15.0, bottom: 12.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 15.0),
                          child: Row(
                            children: [
                              Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFD4D4),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'images/avatar.png',
                                    width: 11.94,
                                    height: 14.08,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Goh Chu Hang',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF2E2E2E),
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      '00-000021',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        color: kTextColor5,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                'View Profile',
                                style: kTextStyle1.copyWith(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryColor,
                                  decoration: TextDecoration.underline,
                                  decorationColor: kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1.0,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          color: const Color(0xFFDBDBDB).withValues(alpha: 0.45),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/information.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                'Female',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '48Y 2M',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/phone.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '010-2235674',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/clock.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '9:00 AM',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          margin: const EdgeInsets.only(left: 20.0),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD4D4),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Text(
                            'Cardiovascular Surgery',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w800,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            
                const SizedBox(height: 22.0),
                Container(
                  margin: const EdgeInsets.only(left: 49.0),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: kBgColor2.withValues(alpha: 0.7),
                        blurRadius: 7.0,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 5.0),
                    padding: const EdgeInsets.only(top: 15.0, bottom: 12.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 15.0),
                          child: Row(
                            children: [
                              Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFD4D4),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'images/avatar.png',
                                    width: 11.94,
                                    height: 14.08,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Aliff Hazim',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF2E2E2E),
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      '12-000021',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        color: kTextColor5,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                'View Profile',
                                style: kTextStyle1.copyWith(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryColor,
                                  decoration: TextDecoration.underline,
                                  decorationColor: kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1.0,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          color: const Color(0xFFDBDBDB).withValues(alpha: 0.45),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/information.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                'Male',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '28Y 1M',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/phone.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '014-2435674',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/clock.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '4:00 PM',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          margin: const EdgeInsets.only(left: 20.0),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD4D4),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Text(
                            'Cardiovascular Surgery',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w800,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            
                const SizedBox(height: 22.0),
                Row(
                  children: [
                    SizedBox(
                      width: 35.0,
                      child: Text(
                        '14:00',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: kTextColor2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 1.0,
                        color: const Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 49.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0076FF),
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: kBgColor2.withValues(alpha: 0.7),
                        blurRadius: 7.0,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 5.0),
                    padding: const EdgeInsets.only(top: 15.0, bottom: 12.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 15.0),
                          child: Row(
                            children: [
                              Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFD4D4),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'images/avatar.png',
                                    width: 11.94,
                                    height: 14.08,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Goh Chu Hang',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF2E2E2E),
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      '00-000021',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        color: kTextColor5,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                'View Profile',
                                style: kTextStyle1.copyWith(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryColor,
                                  decoration: TextDecoration.underline,
                                  decorationColor: kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1.0,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          color: const Color(0xFFDBDBDB).withValues(alpha: 0.45),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/information.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                'Female',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '48Y 2M',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/phone.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '010-2235674',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/clock.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '9:00 AM',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          margin: const EdgeInsets.only(left: 20.0),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3EDFF),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Text(
                            'Outpatient Appointment',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0076FF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMonthly() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          hideCalendar ? const SizedBox.shrink() : const SizedBox(height: 27.0),
          hideCalendar ? const SizedBox.shrink() : 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 17.0),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      isCalendarVisible = !isCalendarVisible;
                      //_isCalendarVisible = isCalendarVisible;
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: kPrimaryColor,
                  ),
                  child: Row(
                    children: [
                      Text(
                        currentMonthMonthly,
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          isCalendarVisible ? 'images/up.png' : 'images/down.png',
                          width: 10.0,
                          height: 5.48,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 16.0,
                    height: 16.0,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          selectedDateMonthly = DateTime(selectedDateMonthly.year, selectedDateMonthly.month - 1, selectedDateMonthly.day);
                          currentMonthMonthly = DateFormat.yMMMM().format(selectedDateMonthly);
                        });
                      },
                      padding: EdgeInsets.zero,
                      splashRadius: 20.0,
                      icon: Image.asset(
                        'images/left.png',
                        width: 16.0,
                        height: 16.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 25.0),
                    child: SizedBox(
                      width: 16.0,
                      height: 16.0,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            selectedDateMonthly = DateTime(selectedDateMonthly.year, selectedDateMonthly.month + 1, selectedDateMonthly.day);
                            currentMonthMonthly = DateFormat.yMMMM().format(selectedDateMonthly);
                          });
                        },
                        padding: EdgeInsets.zero,
                        splashRadius: 20.0,
                        icon: Image.asset(
                          'images/right.png',
                          width: 16.0,
                          height: 16.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Visibility(
            visible: isCalendarVisible & !hideCalendar,
            maintainState: true,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
              child: Container(
                color: Colors.white,
                child: getCalendar(),
              ),
            ),
          ),
          hideCalendar ? const SizedBox.shrink() : const SizedBox(height: 35.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFDBDBDB).withValues(alpha: 0.35),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        hideCalendar = !hideCalendar;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      width: 50.0,
                      height: 4.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDADADA),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  'Upcoming Appointment',
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: kTextColor1,
                  ),
                ),
                const SizedBox(height: 22.0),
                Row(
                  children: [
                    SizedBox(
                      width: 30.0,
                      child: Text(
                        'SUN 1',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 19.0),
                    Container(
                      width: 5.0,
                      height: 5.0,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 1.0,
                        color: const Color(0xFFFFD4D4),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 49.0),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: kBgColor2.withValues(alpha: 0.7),
                        blurRadius: 7.0,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 5.0),
                    padding: const EdgeInsets.only(top: 15.0, bottom: 12.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 15.0),
                          child: Row(
                            children: [
                              Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFD4D4),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'images/avatar.png',
                                    width: 11.94,
                                    height: 14.08,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Goh Chu Hang',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF2E2E2E),
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      '00-000021',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        color: kTextColor5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'View Profile',
                                style: kTextStyle1.copyWith(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryColor,
                                  decoration: TextDecoration.underline,
                                  decorationColor: kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1.0,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          color: const Color(0xFFDBDBDB).withValues(alpha: 0.45),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/information.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                'Female',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '48Y 2M',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/phone.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '010-2235674',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/clock.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '9:00 AM',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          margin: const EdgeInsets.only(left: 20.0),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD4D4),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Text(
                            'Cardiovascular Surgery',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w800,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            
                const SizedBox(height: 15.0),
                Container(
                  margin: const EdgeInsets.only(left: 49.0),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: kBgColor2.withValues(alpha: 0.7),
                        blurRadius: 7.0,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 5.0),
                    padding: const EdgeInsets.only(top: 15.0, bottom: 12.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 15.0),
                          child: Row(
                            children: [
                              Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFD4D4),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'images/avatar.png',
                                    width: 11.94,
                                    height: 14.08,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Aliff Hazim',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF2E2E2E),
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      '12-000021',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        color: kTextColor5,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                'View Profile',
                                style: kTextStyle1.copyWith(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryColor,
                                  decoration: TextDecoration.underline,
                                  decorationColor: kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1.0,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          color: const Color(0xFFDBDBDB).withValues(alpha: 0.45),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/information.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                'Male',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '28Y 1M',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/phone.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '014-2435674',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/clock.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '4:00 PM',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          margin: const EdgeInsets.only(left: 20.0),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD4D4),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Text(
                            'Cardiovascular Surgery',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w800,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    SizedBox(
                      width: 30.0,
                      child: Text(
                        'MON 2',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: kTextColor2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 19.0),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 1.0,
                        color: kBgColor2,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 49.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0076FF),
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: kBgColor2.withValues(alpha: 0.7),
                        blurRadius: 7.0,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 5.0),
                    padding: const EdgeInsets.only(top: 15.0, bottom: 12.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 15.0),
                          child: Row(
                            children: [
                              Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFD4D4),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'images/avatar.png',
                                    width: 11.94,
                                    height: 14.08,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Goh Chu Hang',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF2E2E2E),
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      '00-000021',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        color: kTextColor5,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                'View Profile',
                                style: kTextStyle1.copyWith(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryColor,
                                  decoration: TextDecoration.underline,
                                  decorationColor: kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1.0,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          color: const Color(0xFFDBDBDB).withValues(alpha: 0.45),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/information.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                'Female',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '48Y 2M',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/phone.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '010-2235674',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 21.0, right: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/clock.png',
                                width: 14.0,
                                height: 14.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '9:00 AM',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          margin: const EdgeInsets.only(left: 20.0),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3EDFF),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Text(
                            'Outpatient Appointment',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0076FF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent() {
    if (isMonthly) {
      return buildMonthly();
    }

    return buildWeekly();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        backgroundColor: kBgColor1,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Text(
            'Appointment',
            style: kTextStyle1.copyWith(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: kTextColor1,
            ),
          ),
        ),
        elevation: 2.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              onPressed: showFilter,
              icon: Image.asset(
                'images/filter.png',
                width: 24.0,
                height: 24.0,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: kBgColor1,
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}