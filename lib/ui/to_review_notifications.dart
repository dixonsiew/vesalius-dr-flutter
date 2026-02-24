import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vesalius_dr_flutter/components/last_update_bar.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/review.dart';
import 'package:vesalius_dr_flutter/models/notification_count_model.dart';
import 'package:vesalius_dr_flutter/models/notifications_search_model.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/ui/review_detail.dart';

class ToReviewNotifications extends StatefulWidget {
  const ToReviewNotifications({super.key});

  @override
  State<ToReviewNotifications> createState() => _ToReviewNotificationsState();
}

class _ToReviewNotificationsState extends State<ToReviewNotifications>
    with AutomaticKeepAliveClientMixin<ToReviewNotifications> {
  List<Review> list = [];
  String lastUpdateDate = '';
  bool isLoading = false;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

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
      NotificationCountModel cm = Provider.of<NotificationCountModel>(context, listen: false);
      NotificationsSearchModel csm = Provider.of<NotificationsSearchModel>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      var lx = await getReviewList(formatCurrentDate());
      String s = _getLastUpdateDate(lx);
      var ls = Review.getUniqueList(lx);
      cm.setReviewCount(ls.length);
      csm.setReviewList(ls, lx);

      setState(() {
        list = ls;
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

  String _getLastUpdateDate(List<Review> lx) {
    String s = '';
    if (lx.isNotEmpty) {
      Review o = lx[0];
      s = getLastUpdateDate(o.lastUpdateDate);
    }

    return s;
  }

  Widget buildContent() {
    if (Provider.of<NotificationsSearchModel>(context).reviewList.isEmpty && !isLoading) {
      return SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Material(
                elevation: 5.0,
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: kOutpatientDecoration,
                  child: Text(
                    'You do not have any Review at the moment.',
                    style: kOutpatientCardTextStyle.copyWith(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Consumer<NotificationsSearchModel>(
        builder: (context, k, child) {
          return Scrollbar(
            child: ListView.builder(
              itemCount: k.reviewList.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return const SizedBox(
                    height: 5.0,
                  );
                } else {
                  Review o = k.reviewList[i - 1];
                  return ToReviewNotificationCard(
                    reload: load,
                    review: o,
                    list: k.allreviewList
                        .where((x) => x.patientName == o.patientName)
                        .toList(),
                  );
                }
              },
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
      bottomNavigationBar: lastUpdateDate.isEmpty
          ? null
          : LastUpdateBar(lastUpdateDate: lastUpdateDate),
    );
  }
}

class ToReviewNotificationCard extends StatelessWidget {
  final void Function() reload;
  final Review review;
  final List<Review> list;

  const ToReviewNotificationCard({super.key, 
    required this.reload,
    required this.review,
    required this.list,
  });

  List<Widget> buildInvestigationTypes() {
    List<Widget> lx = [
      Text(review.patientName,
        style: kInpatientCardTextStyle.copyWith(
          fontSize: 14.0,
      )),
    ];
    for (String i in review.investigationTypes!.keys) {
      List<String> li = review.investigationTypes![i] ?? [];
      Widget icon = const FaIcon(
        FontAwesomeIcons.xRay,
        color: kAppBarIconColor,
      );
      if (i == 'DI') {
        icon = const FaIcon(
          FontAwesomeIcons.personDotsFromLine,
          color: kAppBarIconColor,
        );
      } else if (i == 'LABS') {
        icon = const FaIcon(
          FontAwesomeIcons.vials,
          color: kAppBarIconColor,
        );
      }

      for (String x in li) {
        var row = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            const SizedBox(
              width: 10.0,
            ),
            Text(
              x,
              style: kInpatientCardTextStyle.copyWith(
                fontSize: 14.0,
              ),
            ),
          ],
        );
        lx.add(row);
      }
    }

    return lx;
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
            onTap: () async {
              bool b = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ReviewDetail(
                    review: review,
                    list: list,
                  )));
              if (b) {
                reload();
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildInvestigationTypes(),
            ),
          ),
        ),
      ),
    );
  }
}
