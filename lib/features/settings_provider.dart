import 'package:flutter/material.dart';
import 'package:todo_app/features/settings/pages/settings_view.dart';
import 'package:todo_app/features/tasks/pages/tasks_view.dart';

class SettingsProvider extends ChangeNotifier {
  List<Widget> screens = [
    TasksView(),
    SettingsView(),
  ];
  int currentIndex = 0;

  DateTime selectedDate = DateTime.now();

  selectDateTime(BuildContext context) async {
    var currentSelectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: selectedDate,
      currentDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (currentSelectedDate == null) return;

    selectedDate = currentSelectedDate;

    notifyListeners();
  }

  changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  ThemeMode currentTheme = ThemeMode.light;

  changeTheme(ThemeMode newMode) {
    if (currentTheme == newMode) return;
    currentTheme = newMode;
    notifyListeners();
  }

  bool isDark() {
    return currentTheme == ThemeMode.dark;
  }
}