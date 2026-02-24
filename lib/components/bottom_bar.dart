import 'package:flutter/material.dart';
import 'package:vesalius_dr_flutter/constants.dart';

class BottomBar extends StatelessWidget {

  final int index;
  final void Function(int) onTap;

  const BottomBar({
    super.key,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final navBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
          child: Image.asset(
            index == 0 ? 'images/home.png' : 'images/home0.png',
            width: 16.0,
            height: 16.0,
            fit: BoxFit.cover,
          ),
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
          child: Image.asset(
            index == 1 ? 'images/patient.png' : 'images/patient0.png',
            width: 16.0,
            height: 16.0,
            fit: BoxFit.cover,
          ),
        ),
        label: 'Patients',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
          child: Image.asset(
            index == 2 ? 'images/appointment.png' : 'images/appointment0.png',
            width: 16.0,
            height: 16.0,
            fit: BoxFit.cover,
          ),
        ),
        label: 'Appointment',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
          child: Image.asset(
            index == 3 ? 'images/notification.png' : 'images/notification0.png',
            width: 16.0,
            height: 16.0,
            fit: BoxFit.cover,
          ),
        ),
        label: 'Notifications',
      ),
    ];
    final navBar = BottomNavigationBar(
      backgroundColor: kPrimaryColor,
      selectedLabelStyle: const TextStyle(
        fontFamily: kTitleFont,
        fontSize: 12.0,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.05,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: kTitleFont,
        fontSize: 12.0,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.05,
      ),
      items: navBarItems,
      currentIndex: index,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withValues(alpha: 0.65),
      onTap: (int i) {
        if (index != i) {
          onTap.call(i);
        }

        // if (i == 0 && index != i) {
        //   Navigator.pushNamedAndRemoveUntil(context, Home.routeName, (route) => false);
        // }

        // else if (i == 1 && index != i) {
        //   Navigator.pushNamedAndRemoveUntil(context, Patients.routeName, (route) => false);
        // }

        // else if (i == 2 && index != i) {
        //   Navigator.pushNamedAndRemoveUntil(context, Appointment.routeName, (route) => false);
        // }

        // else if (i == 3 && index != i) {
        //   Navigator.pushNamedAndRemoveUntil(context, Notifications.routeName, (route) => false);
        // }
      },
    );

    return Material(
      elevation: 5.0,
      color: kPrimaryColor,
      child: navBar,
    );
  }
}