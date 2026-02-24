import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_dr_flutter/components/last_update_bar.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/outpatient.dart';
import 'package:vesalius_dr_flutter/models/patient_count_model.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';
import 'outpatient_list.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Outpatient extends StatefulWidget {

  const Outpatient({super.key});

  @override
  State<Outpatient> createState() => _OutpatientState();
}

class _OutpatientState extends State<Outpatient> with AutomaticKeepAliveClientMixin<Outpatient> {

  List<OutpatientQueueSummary> list = [];
  String lastUpdateDate = '';
  bool isLoading = false;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final dlg = CustomDialog.of(context);
    try {
      PatientCountModel cm = Provider.of<PatientCountModel>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      var lx = await getOutpatientQueueSummaryList();
      cm.setOutpatientCount(getOutpatientCount(lx));
      var regd = lx.firstWhere((x) => x.queueCriteria == 'Registered', orElse: () => OutpatientQueueSummary(imageName: 'Regd.png', linkName: 'regd', queueCount: 0, queueCriteria: 'Registered'));
      var seen = lx.firstWhere((x) => x.queueCriteria == 'Seen', orElse: () => OutpatientQueueSummary(imageName: 'Seen.png', linkName: 'seen', queueCount: 0, queueCriteria: 'Seen'));
      var appt = lx.firstWhere((x) => x.queueCriteria == 'Appointment', orElse: () => OutpatientQueueSummary(imageName: 'Appt.png', linkName: 'appt', queueCount: 0, queueCriteria: 'Appointment'));
      var kiv = lx.firstWhere((x) => x.queueCriteria == 'KIV', orElse: () => OutpatientQueueSummary(imageName: 'KIV.png', linkName: 'kiv', queueCount: 0, queueCriteria: 'KIV'));

      String s = await _getLastUpdateDate(lx);

      setState(() {
        if (lx.isEmpty) {
          list = [
            OutpatientQueueSummary(imageName: 'Regd.png', linkName: 'regd', queueCount: 0, queueCriteria: 'Registered'),
            OutpatientQueueSummary(imageName: 'Seen.png', linkName: 'seen', queueCount: 0, queueCriteria: 'Seen'),
            OutpatientQueueSummary(imageName: 'Appt.png', linkName: 'appt', queueCount: 0, queueCriteria: 'Appointment'),
            OutpatientQueueSummary(imageName: 'KIV.png', linkName: 'kiv', queueCount: 0, queueCriteria: 'KIV')
          ];
        }

        else {
          list = [regd, seen, appt, kiv];
        }
        
        lastUpdateDate = s;
        isLoading = false;
      });
    }
    
    on DioException catch (error) {
      setState(() {
        isLoading = false;
      });
      dlg.handleError(error, load);
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
      dlg.showCustomDialog(error.toString(), AlertType.error);
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  int getOutpatientCount(List<OutpatientQueueSummary> lx) {
    int n = 0;
    for (var o in lx) {
      if (o.queueCriteria != 'KIV') {
        n += o.queueCount;
      }
    }

    return n;
  }

  Future<String> _getLastUpdateDate(List<OutpatientQueueSummary> lx) async {
    String s = '';
    if (lx.isNotEmpty) {
      try {
        var x = lx.firstWhereOrNull((o) => o.queueCount > 0);
        var ls = await getOutpatientQueueDetailList(x?.queueCriteria ?? '');
        if (ls.isNotEmpty) {
          OutpatientQueueDetail o = ls[0];
          s = getLastUpdateDate(o.lastUpdateDate);
        }
      }

      catch (_) {}
    }

    return s;
  }

  Widget buildContent() {
    // if (list.isEmpty) {
    //   return Container(
    //     width: double.infinity,
    //     padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
    //     child: Card(
    //       elevation: 5.0,
    //       color: kOutpatientCardColor,
    //       child: Padding(
    //         padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
    //         child: Text(
    //           'You do not have any registed cases at the moment.',
    //           style: TextStyle(
    //             color: Colors.black,
    //             fontFamily: 'texgyreadventor',
    //             fontSize: 16.0,
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    return Scrollbar(
      child: ListView.builder(
        itemCount: list.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return const SizedBox(
              height: 5.0,
            );
          }

          else {
            OutpatientQueueSummary o = list[i - 1];
            return OutpatientCard(
              imageName: o.imageName, 
              queueCriteria: o.queueCriteria, 
              queueCount: o.queueCount, 
              linkName: o.linkName,
            );
          }
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const CupertinoActivityIndicator(radius: 15.0),
        child: RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: onRefresh,
          child: buildContent(),
        ),
      ),
      bottomNavigationBar: lastUpdateDate.isEmpty ? null : LastUpdateBar(lastUpdateDate: lastUpdateDate),
    );
  }
}

class OutpatientCard extends StatelessWidget {

  final String queueCriteria;
  final num queueCount;
  final String imageName;
  final String? linkName;
  
  const OutpatientCard({
    super.key, 
    required this.queueCriteria,
    required this.queueCount,
    required this.imageName,
    required this.linkName,
  });

  String getTitle() {
    String s = 'Arrived / Inprogress List';
    if (linkName == 'seen') {
      s = 'Seen List';
    } else if (linkName == 'appt') {
      s = 'Appointment List';
    } else if (linkName == 'kiv') {
      s = 'KIV List';
    }

    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
      child: Material(
        elevation: 5.0,
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: kOutpatientDecoration,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => OutpatientList(
                    queueCriteria: queueCriteria,
                    title: getTitle(),
                  )));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: AssetImage('images/$imageName'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      queueCriteria == 'Registered' ? 'Arrived / Inprogress' : queueCriteria,
                      style: kOutpatientCardTextStyle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: Text(
                    '$queueCount',
                    style: kOutpatientCardTextStyle.copyWith(
                      fontSize: 24.0,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}