import 'package:flutter/material.dart';
import 'package:vesalius_dr_flutter/constants.dart';

class DrugAck extends StatefulWidget {

  final void Function(String, String, String) submitAck;
  final void Function(String, String, String) submitAckDiscontinue;
  final String accessionNo;
  final String notificationType;
  final String itemDesc;

  const DrugAck({
    super.key, 
    required this.submitAck,
    required this.submitAckDiscontinue,
    required this.accessionNo,
    required this.notificationType,
    required this.itemDesc,
  });

  @override
  State<DrugAck> createState() => _DrugAckState();
}

class _DrugAckState extends State<DrugAck> {
  
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  List<Widget> buildInput(BuildContext context) {
    List<Widget> lx = [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: widget.notificationType == 'Verbal Order' ? const AssetImage('images/pencil.png') : const AssetImage('images/discontinue.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            widget.itemDesc,
            style: const TextStyle(
              color: kTextColor,
              fontFamily: 'texgyreadventor',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      const SizedBox(height: 15.0),
      TextField(
        controller: textEditingController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
          hintText: 'Remark for Acknowledgement',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kTextColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
        ),
        style: const TextStyle(
          color: kTextColor,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFA6A6A6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: const BorderSide(
                    color: Color(0xFF203B8C),
                    width: 1.0,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ),
          const SizedBox(
            width:  10.0,
          ),
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: kTextColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: const BorderSide(
                    color: Color(0xFF203B8C),
                    width: 1.0,
                  ),
                ),
              ),
              onPressed: () {
                String s = textEditingController.text;
                widget.submitAck(s, widget.accessionNo, widget.notificationType);
              },
              child: const Text('Acknowledge'),
            ),
          ),
        ],
      ),
    ];

    if (widget.notificationType == 'Verbal Order') {
      lx.add(
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: kTextColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: const BorderSide(
                color: Color(0xFF203B8C),
                width: 1.0,
              ),
            ),
          ),
          onPressed: () {
            String s = textEditingController.text;
            widget.submitAckDiscontinue(s, widget.accessionNo, widget.notificationType);
          },
          child: const Text('Acknowledge and Discontinue'),
        ),
      );
    }

    return lx;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: kInpatientCardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: buildInput(context),
        ),
      ),
    );
  }
}