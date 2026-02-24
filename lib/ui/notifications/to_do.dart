import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/components/last_update_bar.dart';
import 'package:vesalius_dr_flutter/components/no_record.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/notifications/to_do_ctrl.dart';
import 'package:vesalius_dr_flutter/controllers/notifications_ctrl.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/todo_notification.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';

import 'to_do_detail.dart';

class ToDo extends StatefulWidget {

  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> with AutomaticKeepAliveClientMixin<ToDo> {

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final TodoCtrl ctrl = Get.put(TodoCtrl());
  final NotificationsCtrl notificationsCtrl = Get.put(NotificationsCtrl());

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      final lx = await getTodoNotificationList();
      String s = _getLastUpdateDate(lx);
      final ls = TodoNotification.getUniqueList(lx);
      notificationsCtrl.setTodoCount(ls.length);
      ctrl.init();
      ctrl.setList(ls);
      ctrl.setLastUpdateDate(s);
      ctrl.setIsLoading(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleError(error, load);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      await showCustomDialog(error.toString(), AlertType.error);
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

  Widget buildList() {
    return Obx(() => ctrl.list.isEmpty ? const NoRecord(text: 'You do not have any to-do at the moment.') :
    Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: ctrl.lastUpdateDate.isNotEmpty ? 44.0 : 0),
          child: Scrollbar(
            child: ListView.builder(
              itemCount: ctrl.list.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const SizedBox(height: 25.0);
                }

                return ToDoItem(
                  reload: load,
                  data: ctrl.list[index - 1],
                );
              },
            ),
          ),
        ),
        if (ctrl.lastUpdateDate.isNotEmpty) ...[
          Align(
            alignment: Alignment.bottomCenter,
            child: LastUpdateBar(ctrl.lastUpdateDate),
          ),
        ],
      ],
    ));
  }

  Widget buildContent() {
    return Obx(() => ctrl.isLoading ? Container() : buildList());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() =>
      ModalProgressHUD(
        inAsyncCall: ctrl.isLoading,
        blur: kBlur,
        progressIndicator: const AppActivityIndicator(),
        child: RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: onRefresh,
          color: kPrimaryColor,
          child: buildContent(),
        ),
      ),
    );
  }
}

class ToDoItem extends StatelessWidget {
  
  final void Function() reload;
  final TodoNotification data;

  const ToDoItem({
    super.key,
    required this.reload,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
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
        child: InkWell(
          onTap: () async {
            if (data.notificationType == 'Discharge Summary') {
              showCustomDialog('Please complete Discharge Summary process in VESALIUS', AlertType.info);
            }

            else {
              bool b = await Get.to(() => ToDoDetail(prn: data.prn)) ?? false;
              if (b) {
                reload();
              }
            }
          },
          borderRadius: BorderRadius.circular(5.0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD4D4),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/avatar-2.png',
                      width: 18.65,
                      height: 22.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.patientName,
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2E2E2E),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.ideographic,
                        children: [
                          Image.asset(
                            'images/drugs.png',
                            width: 14.0,
                            height: 14.0,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              data.notificationTypes,
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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