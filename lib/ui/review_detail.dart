import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:vesalius_dr_flutter/components/app_drawer.dart';
import 'package:vesalius_dr_flutter/components/bottom_bar.dart';
import 'package:vesalius_dr_flutter/components/patient_profile_info.dart';
import 'package:vesalius_dr_flutter/components/row_data.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/auth_manager.dart';
import 'package:vesalius_dr_flutter/models/patient_data.dart';
import 'package:vesalius_dr_flutter/models/review.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'main_layout.dart';
import 'review.dart';

class ReviewDetail extends StatefulWidget {
  static const String routeName = 'ReviewDetail_list';

  final Review review;
  final List<Review> list;

  const ReviewDetail({
    super.key,
    required this.review,
    required this.list,
  });

  @override
  State<ReviewDetail> createState() => _ReviewDetailState();
}

class _ReviewDetailState extends State<ReviewDetail> {
  PatientInfo? patientInfo;
  List<Review> list = [];
  List<Review> _list = [];
  bool isLoading = false;
  bool isSearch = false;
  final searchController = TextEditingController();
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    list = widget.list;
    _list = widget.list;
    load();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void load() async {
    final dlg = CustomDialog.of(context);
    try {
      setState(() {
        isLoading = true;
      });
      var o = await getPatientData(widget.review.prn);
      setState(() {
        patientInfo = PatientInfo(
          prn: o.prn,
          name: o.name,
          sexCode: o.sexCode,
          sexDesc: o.sexDesc,
        );
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

  void removeFromList(String a) {
    var q = list.where((o) => o.accessionNo != a);
    var lx = q.toList();
    setState(() {
      list = lx;
      _list = lx;
    });
    if (lx.isEmpty) {
      Navigator.pop(context);
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context);
    }
  }

  void filterList(String s) {
    if (s.isEmpty) {
      setState(() {
        list = _list;
      });
    } else {
      String r = s.toLowerCase();
      var q = _list.where((o) {
        return o.investigationType.toLowerCase().contains(r) ||
            o.serviceDesc.toLowerCase().contains(r) ||
            o.remark.toLowerCase().contains(r);
      });
      setState(() {
        list = q.toList();
      });
    }
  }

  void submitReview(String a, String p) async {
    final dlg = CustomDialog.of(context);
    try {
      var o = {
        'accessionNo': a,
        'prn': p,
        'reviewDoctor': AuthManager.mcr,
        'reviewDate': formatCurrentDate(),
        'reviewTime': formatCurrentTime()
      };
      final nav = Navigator.of(context);
      await submitReviewAck(o);
      await dlg.showCustomDialog('Review request has been submitted to VESALIUS.', AlertType.info);
      if (list.length < 2) {
        nav.pop();
        nav.pop(true);
      } else {
        removeFromList(a);
      }
    } catch (error) {
      if (error is DioException) {
        if (error.type == DioExceptionType.badResponse) {
          DioException e = error;
          if (e.response?.statusCode == 400) {
            await dlg.showCustomDialog('Review has been Submitted in VESALIUS.', AlertType.info);
            return;
          }
        }

        dlg.handleError(error, () => submitReview(a, p));
      }

      dlg.showCustomDialog(error.toString(), AlertType.error);
    }
  }

  Widget? buildLeading() {
    if (isSearch) {
      return IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: kAppBarIconColor,
        ),
        onPressed: () {
          setState(() {
            isSearch = false;
          });
        },
      );
    }

    return null;
  }

  List<Widget> buildActions() {
    List<Widget> lx = [];
    if (!isSearch) {
      lx.add(IconButton(
        icon: const Icon(
          Icons.search,
          color: kAppBarIconColor,
        ),
        onPressed: () {
          setState(() {
            isSearch = true;
          });
        },
      ));
    }

    lx.add(IconButton(
      onPressed: () {
        drawerKey.currentState?.openEndDrawer();
      },
      icon: const Icon(
        Icons.menu,
        color: kAppBarIconColor,
      ),
    ));

    return lx;
  }

  Widget buildTitle() {
    if (!isSearch) {
      return const Text(
        'Report Details',
        style: kAppBarTitleTextStyle,
      );
    }

    return Material(
      elevation: 20.0,
      borderRadius: BorderRadius.circular(5.0),
      shadowColor: Colors.black,
      child: TextField(
        controller: searchController,
        autofocus: true,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(
            Icons.search,
            color: kAppBarIconColor,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 3.0,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        onChanged: (String s) {
          filterList(s);
        },
      ),
    );
  }

  Widget buildContent() {
    if (patientInfo == null) {
      return Container();
    }

    if (list.isEmpty && !isLoading) {
      return SafeArea(
        child: ListView(
          children: [
            PatientProfileInfo(patientInfo: patientInfo),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: Material(
                elevation: 5.0,
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 15.0, top: 15.0, bottom: 15.0),
                  decoration: kOutpatientDecoration,
                  child: Text(
                    'No record found.',
                    style: kInpatientCardTextStyle.copyWith(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Scrollbar(
        child: ListView.builder(
            itemCount: list.length + 2,
            itemBuilder: (context, i) {
              if (i == 0) {
                return PatientProfileInfo(patientInfo: patientInfo);
              } else if (i == 1) {
                return const SizedBox(
                  height: 10.0,
                );
              } else {
                Review o = list[i - 2];
                return ReviewDetailCard(
                  review: o,
                  submitReview: submitReview,
                );
              }
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.black,
        ),
        automaticallyImplyLeading: !isSearch,
        leading: buildLeading(),
        iconTheme: const IconThemeData(
          color: kAppBarIconColor, //change your color here
        ),
        actions: buildActions(),
        title: buildTitle(),
        backgroundColor: Colors.white,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const CupertinoActivityIndicator(radius: 15.0),
        child: buildContent(),
      ),
      bottomNavigationBar: BottomBar(
        index: 0,
        onTap: (int i) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainLayout(index: i)), (route) => false);
        },
      ),
      endDrawer: const AppDrawer(),
    );
  }
}

class ReviewDetailCard extends StatefulWidget {
  final Review review;
  final void Function(String, String) submitReview;

  const ReviewDetailCard({
    super.key,
    required this.review,
    required this.submitReview,
  });

  @override
  State<ReviewDetailCard> createState() => _ReviewDetailCardState();
}

class _ReviewDetailCardState extends State<ReviewDetailCard> {
  bool isDownloading = false;
  double? percent;

  List<Widget> buildRows(BuildContext context) {
    Review review = widget.review;
    List<Widget> lx = [
      Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: RowData(
          label: 'Type',
          text: review.investigationType,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: RowData(
          label: 'Description',
          text: review.serviceDesc,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: RowData(
          label: 'OrderDate',
          text: review.orderDate,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: RowData(
          label: 'ResultDate',
          text: review.resultDate,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: RowData(
          label: 'ReportType',
          text: review.reportType,
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: RowData(
          label: 'Result',
          text: '',
        ),
      ),
    ];

    lx.add(const Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: RowData(
        label: 'Result',
        text: '',
      ),
    ));

    if (review.reportType != 'PDF') {
      lx.add(
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Text(
            review.result ?? '',
            style: kAllergiesCardTextStyle,
          ),
        )
      );
    } else if (review.reportType == 'PDF') {
      lx.add(Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: TextButton.icon(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            backgroundColor: kTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: const BorderSide(
                color: Color(0xFF203B8C),
                width: 1.0,
              ),
            ),
          ),
          icon: const FaIcon(
            FontAwesomeIcons.filePdf,
            color: Colors.white,
          ),
          label: const Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              'View Report in PDF',
              style: TextStyle(
                fontFamily: 'texgyreadventor',
                color: Colors.white,
              ),
            ),
          ),
          onPressed: () async {
            setState(() {
              isDownloading = true;
              percent = 0;
            });
            var dir = await getApplicationDocumentsDirectory();
            String fp = '${dir.path}/${review.accessionNo}-${review.prn}.pdf';
            File file = await getInvestigationReportPdf(review.accessionNo, fp,
                (received, total) {
              if (total != -1) {
                double pct = (received / total * 100);
                setState(() {
                  percent = pct;
                });

                //print((received / total * 100).toStringAsFixed(0) + "%");
              }
            });
            setState(() {
              isDownloading = false;
            });
            //print(file.path);
            await OpenFilex.open(file.path);
          },
        ),
      ));

      if (isDownloading) {
        lx.add(
          LinearPercentIndicator(
            lineHeight: 14.0,
            percent: (percent ?? 0) / 100.0,
            center: Text(
              '${percent?.toStringAsFixed(0) ?? 0} %',
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
            barRadius: const Radius.circular(16.0),
            backgroundColor: Colors.grey,
            progressColor: kTextColor,
          )
        );
      }
    }

    return lx;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
      child: Material(
        elevation: 5.0,
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: kOutpatientDecoration,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: ReviewSubmit(
                      submitReview: widget.submitReview,
                      accessionNo: widget.review.accessionNo,
                      prn: widget.review.prn,
                      serviceDesc: widget.review.serviceDesc,
                    ),
                  ),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildRows(context),
            ),
          ),
        ),
      ),
    );
  }
}
