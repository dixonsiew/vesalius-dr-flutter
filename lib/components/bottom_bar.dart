import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vesalius_dr_flutter/constants.dart';

class BottomBar extends StatefulWidget {

  final int index;
  final void Function(int) onTap;

  const BottomBar({
    super.key, 
    required this.index,
    required this.onTap,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int index = 0;

  @override
  void initState() {
    super.initState();
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    final navBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: FaIcon(
          FontAwesomeIcons.hospitalUser,
          color: kAppBarIconColor,
        ),
        label: 'MY PATIENTS',
      ),
      const BottomNavigationBarItem(
        icon: FaIcon(
          FontAwesomeIcons.notesMedical,
          color: kAppBarIconColor,
        ),
        label: 'MY NOTIFICATIONS',
      ),
    ];
    final navBar = BottomNavigationBar(
      selectedLabelStyle: const TextStyle(
        fontFamily: 'texgyreadventor',
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'texgyreadventor',
      ),
      items: navBarItems,
      currentIndex: index,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF203B8C),
      onTap: (int i) {
        setState(() {
          index = i;
          widget.onTap.call(i);
        });
      },
    );

    return Material(
      elevation: 10.0,
      color: Colors.white,
      child: navBar,
    );
  }
}