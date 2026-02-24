import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_dr_flutter/components/last_update_bar.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/inpatient.dart';
import 'package:vesalius_dr_flutter/models/patient_count_model.dart';
import 'package:vesalius_dr_flutter/models/patient_search_model.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';
import 'patient_detail.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Inpatient extends StatefulWidget {

  const Inpatient({super.key});

  @override
  State<Inpatient> createState() => _InpatientState();
}

class _InpatientState extends State<Inpatient> with AutomaticKeepAliveClientMixin<Inpatient> {

  List<InpatientQueueDetail> list = [];
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
      PatientSearchModel csm = Provider.of<PatientSearchModel>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      var lx = await getInpatientDetailList();
      cm.setInpatientCount(lx.length);
      lx.sort((a, b) {
        int i = a.ward.toLowerCase().compareTo(b.ward.toLowerCase());
        if (i == 0) {
          String n1 = getPatientName(a);
          String n2 = getPatientName(b);
          return n1.compareTo(n2);
        }

        else {
          return i;
        }
      });
      csm.setInpatientList(lx);
      String s = _getLastUpdateDate(lx);

      setState(() {
        list = lx;
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

  String getPatientName(InpatientQueueDetail o) {
    return '${o.title} ${o.firstName} ${o.middleName} ${o.lastName}'.trim().toLowerCase();
  }

  String _getLastUpdateDate(List<InpatientQueueDetail> lx) {
    String s = '';
    if (lx.isNotEmpty) {
      InpatientQueueDetail o = lx[0];
      s = getLastUpdateDate(o.lastUpdateDate);
    }

    return s;
  }

  Widget buildContent() {
    return SafeArea(
      child: Consumer<PatientSearchModel>(
        builder: (context, k, child) {
          return Scrollbar(
            child: ListView.builder(
              itemCount: k.inpatientList.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return const SizedBox(
                    height: 15.0,
                  );
                }

                else {
                  InpatientQueueDetail o = k.inpatientList[i - 1];
                  return InpatientCard(inpatientQueueDetail: o);
                }
              }
            ),
          );
        },
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

class InpatientCard extends StatelessWidget {

  final InpatientQueueDetail inpatientQueueDetail;
  
  const InpatientCard({
    super.key, 
    required this.inpatientQueueDetail,
  });

  String get image {
    String s = 'M-icon';

    if (inpatientQueueDetail.sexCode.toLowerCase() == 'm') {
      return s;
    }

    else if (inpatientQueueDetail.sexCode.toLowerCase() == 'f') {
      s = 'W-icon';
    }

    else if (inpatientQueueDetail.sexCode.toLowerCase() == 'u') {
      s = 'U-icon';
    }

    return s;
  }

  Widget get vipImage {
    if (inpatientQueueDetail.vipFlag.toLowerCase() == 'yes') {
      return Container(
        width: 20.0,
        height: 20.0,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
            image: AssetImage('images/red-corner.png'),
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
      child: Material(
        elevation: 5.0,
        child: Container(
          decoration: kInpatientDecoration,
          child: Stack(
            children: [
              vipImage,
              Container(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => PatientDetail(
                          prn: inpatientQueueDetail.prn,
                          patientType: PatientType.inpatient,
                        )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('images/$image.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                inpatientQueueDetail.prn,
                                style: kInpatientCardTextStyle,
                              ),
                              Text(
                                '${inpatientQueueDetail.title} ${inpatientQueueDetail.firstName} ${inpatientQueueDetail.middleName} ${inpatientQueueDetail.lastName}'.trimLeft(),
                                style: kInpatientCardTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${inpatientQueueDetail.sexDesc}    ${inpatientQueueDetail.age}',
                                style: kInpatientCardTextStyle,
                              ),
                              Text(
                                inpatientQueueDetail.nationality,
                                style: kInpatientCardTextStyle,
                              ),
                              Text(
                                '${inpatientQueueDetail.ward} / ${inpatientQueueDetail.bed}',
                                style: kInpatientCardTextStyle,
                              ),
                              Text(
                                '${inpatientQueueDetail.admissionDate} ${inpatientQueueDetail.admissionTime}',
                                style: kInpatientCardTextStyle,
                              ),
                            ],
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
      ),
    );
  }
}