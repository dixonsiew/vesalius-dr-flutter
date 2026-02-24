import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/components/inner_page.dart';
import 'package:vesalius_dr_flutter/components/patients/patient_header.dart';
import 'package:vesalius_dr_flutter/constants.dart';

class LabResults extends StatefulWidget {

  static const String routeName = '/LabResults';

  final PatientHeader patientHeader;

  const LabResults({
    super.key,
    required this.patientHeader,
  });

  @override
  State<LabResults> createState() => _LabResultsState();
}

class _LabResultsState extends State<LabResults> {

  bool isLoading = false;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {

  }

  Future<void> onRefresh() async {
    load();
  }

  Widget buildContent() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: widget.patientHeader,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 20.0, right: 8.0, top: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '18.06.2021',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: kTextColor1,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            showMore();
                          },
                          splashRadius: 24.0,
                          icon: Image.asset(
                            'images/expand.png',
                            width: 16.0,
                            height: 16.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13.0),
                    Table(
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(2.0),
                        1: FlexColumnWidth(),
                        2: FlexColumnWidth(1.5),
                        3: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          children: [
                            Text(
                              'Test',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF7C7C7C),
                              ),
                            ),
                            Text(
                              'Result',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF7C7C7C),
                              ),
                            ),
                            Text(
                              'Standard',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF7C7C7C),
                              ),
                            ),
                            Text(
                              'Unit',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF7C7C7C),
                              ),
                            ),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Haemoglobin',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              '16.0',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              '13.5-18.0',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              'g/dL',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Glucose',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              '87.0',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              '65-125',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              'mg/dL',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Potassium',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              '4.67',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              '3.6-5.1',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              'g/dL',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    Text(
                      '+6 Tests',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 20.0, right: 8.0, top: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '11.01.2021',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: kTextColor1,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            
                          },
                          splashRadius: 24.0,
                          icon: Image.asset(
                            'images/expand.png',
                            width: 16.0,
                            height: 16.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13.0),
                    Table(
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(2.0),
                        1: FlexColumnWidth(),
                        2: FlexColumnWidth(1.5),
                        3: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          children: [
                            Text(
                              'Test',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF7C7C7C),
                              ),
                            ),
                            Text(
                              'Result',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF7C7C7C),
                              ),
                            ),
                            Text(
                              'Standard',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF7C7C7C),
                              ),
                            ),
                            Text(
                              'Unit',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF7C7C7C),
                              ),
                            ),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Haemoglobin',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              '16.0',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              '13.5-18.0',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              'g/dL',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Glucose',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              '80.0',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              '65-125',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              'mg/dL',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Potassium',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              '4.4',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              '13.5-18.0',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                            Text(
                              'g/dL',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    Text(
                      '+6 Tests',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Laboratory Results',
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          blur: kBlur,
          progressIndicator: const AppActivityIndicator(),
          child: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: onRefresh,
            color: kPrimaryColor,
            child: buildContent(),
          ),
        ),
      ),
    );
  }

  void showMore() async {
    await Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Laboratory Results',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: kTextColor1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  splashRadius: 24.0,
                  icon: Image.asset(
                    'images/minimize.png',
                    width: 16.0,
                    height: 16.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Table(
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(2.0),
                      1: FlexColumnWidth(1.5),
                      2: FlexColumnWidth(1.5),
                    },
                    children: [
                      TableRow(
                        children: [
                          Text(
                            'Patient Name',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                          Text(
                            'Sex',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                          Text(
                            'Age',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                      const TableRow(
                        children: [
                          SizedBox(height: 5.0),
                          SizedBox(height: 5.0),
                          SizedBox(height: 5.0),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text(
                            'Goh Chu Hang',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Female',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '48Y 2M',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Table(
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(4.0),
                      1: FlexColumnWidth(2.0),
                    },
                    children: [
                      TableRow(
                        children: [
                          Text(
                            'Date / Time of Collection',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                          Text(
                            'Date of Report',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                        ]
                      ),
                      const TableRow(
                        children: [
                          SizedBox(height: 5.0),
                          SizedBox(height: 5.0),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text(
                            '15.06.2021 @ 9:00 A.M.',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '18.06.2021',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Table(
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(4.0),
                    },
                    children: [
                      TableRow(
                        children: [
                          Text(
                            'PRN',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                      const TableRow(
                        children: [
                          SizedBox(height: 5.0),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text(
                            '0-000031',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25.0),
            Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(2.0),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(),
              },
              children: [
                TableRow(
                  children: [
                    Text(
                      'Test',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                    Text(
                      'Result',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                    Text(
                      'Standard',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                    Text(
                      'Unit',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Haemoglobin',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '16.0',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '13.5-18.0',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      'g/dL',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Glucose',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '80.0',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '65-125',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      'mg/dL',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Potassium',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '4.4',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '13.5-18.0',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      'g/dL',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Potassium',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '4.4',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '13.5-18.0',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      'g/dL',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Potassium',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '4.4',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '13.5-18.0',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      'g/dL',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Potassium',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '4.4',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '13.5-18.0',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      'g/dL',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Potassium',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '4.4',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '13.5-18.0',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      'g/dL',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Potassium',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '4.4',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '13.5-18.0',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      'g/dL',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Potassium',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '4.4',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '13.5-18.0',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      'g/dL',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Potassium',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '4.4',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '13.5-18.0',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      'g/dL',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Potassium',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '4.4',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '13.5-18.0',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      'g/dL',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Potassium',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '4.4',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '13.5-18.0',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      'g/dL',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      'Potassium',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '4.4',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      '13.5-18.0',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Text(
                      'g/dL',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}