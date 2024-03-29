import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/config/constants.dart';
import 'package:todo_app/core/network_layer/firebase_utils.dart';
import 'package:todo_app/features/settings_provider.dart';
import 'package:todo_app/features/tasks/widgets/task_item_widget.dart';
import 'package:todo_app/models/task_model.dart';

class TasksView extends StatefulWidget {
  TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  DateTime _focusDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    var vm = Provider.of<SettingsProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: Stack(
            alignment: const Alignment(0, 2),
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
                width: mediaQuery.width,
                height: mediaQuery.height * 0.22,
                color: theme.primaryColor,
                child: Text(
                  "To Do List",
                  style: theme.textTheme.titleLarge,
                ),
              ),
              EasyInfiniteDateTimeLine(
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                focusDate: _focusDate,
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onDateChange: (selectedDate) {
                  setState(() {});
                  _focusDate = selectedDate;
                  vm.selectedDate = _focusDate;
                },
                timeLineProps: const EasyTimeLineProps(
                  separatorPadding: 15.0,
                ),
                showTimelineHeader: false,
                dayProps: EasyDayProps(
                  activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade500)),
                    dayNumStyle: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.primaryColor),
                    monthStrStyle: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.primaryColor),
                    dayStrStyle: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.primaryColor),
                  ),
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    dayNumStyle: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.black),
                    monthStrStyle: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.black),
                    dayStrStyle: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.black),
                  ),
                  todayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    dayNumStyle: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.black),
                    monthStrStyle: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.black),
                    dayStrStyle: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
        StreamBuilder<QuerySnapshot<TaskModel>>(
          stream: FirebaseUtils().getStreamDataFromFireStore(vm.selectedDate),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Column(
                children: [
                  Text(
                    "Something went wrong",
                  ),
                  SizedBox(height: 20),
                  Icon(Icons.refresh),
                ],
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Constants.theme.primaryColor,
                ),
              );
            }

            var tasksList =
                snapshot.data?.docs.map((e) => e.data()).toList() ?? [];

            return Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) =>
                    TaskItemWidget(taskModel: tasksList[index]),
                itemCount: tasksList.length,
              ),
            );
          },
        ),
        // FutureBuilder<List<TaskModel>>(
        //   future: FirebaseUtils().getDataFromFireStore(vm.selectedDate),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasError) {
        //       return const Column(
        //         children: [
        //           Text(
        //             "Something went wrong",
        //           ),
        //           SizedBox(height: 20),
        //           Icon(Icons.refresh),
        //         ],
        //       );
        //     }
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(
        //         child: CircularProgressIndicator(
        //           color: Constants.theme.primaryColor,
        //         ),
        //       );
        //     }
        //
        //     var tasksList = snapshot.data;
        //
        //     return Expanded(
        //       child: ListView.builder(
        //         padding: EdgeInsets.zero,
        //         itemBuilder: (context, index) =>
        //             TaskItemWidget(taskModel: tasksList![index]),
        //         itemCount: tasksList?.length ?? 0,
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }
}
