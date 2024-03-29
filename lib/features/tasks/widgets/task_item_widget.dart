import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/config/constants.dart';
import 'package:todo_app/core/network_layer/firebase_utils.dart';
import 'package:todo_app/core/services/snack_bar_service.dart';
import 'package:todo_app/models/task_model.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskModel taskModel;

  const TaskItemWidget({
    super.key,
    required this.taskModel,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFE4A49),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.265,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                EasyLoading.show();
                FirebaseUtils().deleteTask(taskModel).then((value) {
                  EasyLoading.dismiss();
                  SnackBarService.showSuccessMessage(
                      "Task deleted successfully");
                });
              },
              backgroundColor: const Color(0xFFFE4A49),
              borderRadius: BorderRadius.circular(12),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          height: 115,
          width: mediaQuery.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 90,
                decoration: BoxDecoration(
                  color: taskModel.isDone == true
                      ? Colors.green
                      : theme.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      taskModel.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: taskModel.isDone == true
                            ? Colors.green
                            : theme.primaryColor,
                      ),
                    ),
                    Text(
                      taskModel.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.alarm,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          DateFormat.yMMMMd().format(taskModel.dateTime),
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (taskModel.isDone)
                Text(
                  "Done !",
                  style: Constants.theme.textTheme.titleLarge
                      ?.copyWith(color: Colors.green, fontSize: 24),
                ),
              if (!taskModel.isDone)
                InkWell(
                  onTap: () {
                    EasyLoading.show();
                    FirebaseUtils().updateTask(taskModel).then((value) {
                      EasyLoading.dismiss();
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 2),
                      decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 35,
                        color: Colors.white,
                      )),
                )
            ],
          ),
        ),
      ),
    );
  }
}
