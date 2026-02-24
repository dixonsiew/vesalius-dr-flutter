import 'package:flutter/material.dart';

class LastUpdateBar extends StatelessWidget {
  
  final String lastUpdateDate;

  const LastUpdateBar({
    super.key, 
    required this.lastUpdateDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Last Update: ',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'texgyreadventor',
              fontSize: 12.0,
            ),
          ),
          Text(
            lastUpdateDate,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'texgyreadventor',
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}