import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_dr_flutter/components/last_update_bar.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/todo_notification.dart';
import 'package:vesalius_dr_flutter/models/notification_count_model.dart';
import 'package:vesalius_dr_flutter/models/notifications_search_model.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'drug_verification.dart';

class TodoNotifications extends StatefulWidget {

  const TodoNotifications({super.key});

  @override
  State<TodoNotifications> createState() => _TodoNotificationsState();
}

class _TodoNotificationsState extends State<TodoNotifications> with AutomaticKeepAliveClientMixin<TodoNotifications> {
  List<TodoNotification> list = [];
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
      NotificationCountModel cm = Provider.of<NotificationCountModel>(context, listen: false);
      NotificationsSearchModel csm = Provider.of<NotificationsSearchModel>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      var lx = await getTodoNotificationList();
      String s = _getLastUpdateDate(lx);
      var ls = TodoNotification.getUniqueList(lx);
      cm.setTodoCount(ls.length);
      csm.setTodoList(ls, ls);

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

  String _getLastUpdateDate(List<TodoNotification> lx) {
    String s = '';
    if (lx.isNotEmpty) {
      TodoNotification o = lx[0];
      s = getLastUpdateDate(o.lastUpdateDate);
    }

    return s;
  }

  Widget buildContent() {
    if (Provider.of<NotificationsSearchModel>(context).todoList.isEmpty &&
        !isLoading) {
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
                  decoration: kInpatientDecoration,
                  child: Text(
                    'You do not have any To-Do at the moment.',
                    style: kInpatientCardTextStyle.copyWith(
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
                itemCount: k.todoList.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return const SizedBox(
                      height: 5.0,
                    );
                  } else {
                    TodoNotification o = k.todoList[i - 1];
                    return TodoNotificationCard(
                      reload: load,
                      todoNotification: o,
                    );
                  }
                }),
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

class TodoNotificationCard extends StatelessWidget {
  final void Function() reload;
  final TodoNotification todoNotification;

  const TodoNotificationCard({
    super.key,
    required this.reload,
    required this.todoNotification,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
      child: Material(
        elevation: 5.0,
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: kInpatientDecoration,
          child: InkWell(
            onTap: () async {
              final dlg = CustomDialog.of(context);
              if (todoNotification.notificationType == 'Discharge Summary') {
                await dlg.showCustomDialog(
                  'Please complete Discharge Summary process in VESALIUS',
                  AlertType.info
                );
              } else {
                bool b = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DrugVerification(prn: todoNotification.prn)));
                if (b) {
                  reload();
                }
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todoNotification.patientName,
                  style: kInpatientCardTextStyle.copyWith(
                    fontSize: 14.0,
                  )),
                Text(
                  todoNotification.notificationTypes,
                  style: kInpatientCardTextStyle.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
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
