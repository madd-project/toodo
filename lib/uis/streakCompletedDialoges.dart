import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toodo/main.dart';
import 'package:toodo/uis/quotes.dart';
import 'package:workmanager/workmanager.dart';

const simpleTaskKey = "simpleTask";
const rescheduledTaskKey = "rescheduledTask";
const failedTaskKey = "failedTask";
const simpleDelayedTask = "simpleDelayedTask";
const simplePeriodicTask = "simplePeriodicTask";
const simplePeriodic1HourTask = "simplePeriodic1HourTask";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case simpleTaskKey:
        print("$simpleTaskKey was executed. inputData = $inputData");
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("test", true);
        print("Bool from prefs: ${prefs.getBool("test")}");
        break;
      case rescheduledTaskKey:
        final key = inputData['key'];
        final prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('unique-$key')) {
          print('has been running before, task is successful');
          return true;
        } else {
          await prefs.setBool('unique-$key', true);
          print('reschedule task');
          return false;
        }
        break;
      case failedTaskKey:
        print('failed task');
        return Future.error('failed');
      case simpleDelayedTask:
        final document =
            await getApplicationDocumentsDirectory(); // Getting the Path of App Directory
        Hive.init(document.path);
        await Hive.openBox(quotesCardname);

        quotesBox = Hive.box(quotesCardname);
        deleteQuotes();

        break;
      case simplePeriodicTask:
        print("$simplePeriodicTask was executed");
        break;
      case simplePeriodic1HourTask:
        print("$simplePeriodic1HourTask was executed");
        break;
      case Workmanager.iOSBackgroundTask:
        print("The iOS background fetch was triggered");
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        print(
            "You can access other plugins in the background, for example Directory.getTemporaryDirectory(): $tempPath");
        break;
    }

    return Future.value(true);
  });
}



//               Text("Plugin initialization",
//                   style: Theme.of(context).textTheme.headline),
//               RaisedButton(
//                   child: Text("Start the Flutter background service"),
//                   onPressed: () {
//                     Workmanager().initialize(
//                       callbackDispatcher,
//                       isInDebugMode: true,
//                     );
//                   }),
//               SizedBox(height: 16),
//               Text("One Off Tasks (Android only)",
//                   style: Theme.of(context).textTheme.headline),
//               //This task runs once.
//               //Most likely this will trigger immediately
//               PlatformEnabledButton(
//                 platform: _Platform.android,
//                 child: Text("Register OneOff Task"),
//                 onPressed: () {
//                   Workmanager().registerOneOffTask(
//                     "1",
//                     simpleTaskKey,
//                     inputData: <String, dynamic>{
//                       'int': 1,
//                       'bool': true,
//                       'double': 1.0,
//                       'string': 'string',
//                       'array': [1, 2, 3],
//                     },
//                   );
//                 },
//               ),
//               PlatformEnabledButton(
//                 platform: _Platform.android,
//                 child: Text("Register rescheduled Task"),
//                 onPressed: () {
//                   Workmanager().registerOneOffTask(
//                     "1-rescheduled",
//                     rescheduledTaskKey,
//                     inputData: <String, dynamic>{
//                       'key': Random().nextInt(64000),
//                     },
//                   );
//                 },
//               ),
//               PlatformEnabledButton(
//                 platform: _Platform.android,
//                 child: Text("Register failed Task"),
//                 onPressed: () {
//                   Workmanager().registerOneOffTask(
//                     "1-failed",
//                     failedTaskKey,
//                   );
//                 },
//               ),
//               //This task runs once
//               //This wait at least 10 seconds before running
//               PlatformEnabledButton(
//                   platform: _Platform.android,
//                   child: Text("Register Delayed OneOff Task"),
//                   onPressed: () {
//                     Workmanager().registerOneOffTask(
//                       "2",
//                       simpleDelayedTask,
//                       initialDelay: Duration(seconds: 1),
//                     );
//                   }),
//               SizedBox(height: 8),
//               Text("Periodic Tasks (Android only)",
//                   style: Theme.of(context).textTheme.headline),
//               //This task runs periodically
//               //It will wait at least 10 seconds before its first launch
//               //Since we have not provided a frequency it will be the default 15 minutes
//               PlatformEnabledButton(
//                   platform: _Platform.android,
//                   child: Text("Register Periodic Task"),
//                   onPressed: () {
//                     Workmanager().registerPeriodicTask(
//                       "3",
//                       simplePeriodicTask,
//                       initialDelay: Duration(seconds: 10),
//                     );
//                   }),
//               //This task runs periodically
//               //It will run about every hour
//               PlatformEnabledButton(
//                   platform: _Platform.android,
//                   child: Text("Register 1 hour Periodic Task"),
//                   onPressed: () {
//                     Workmanager().registerPeriodicTask(
//                       "5",
//                       simplePeriodic1HourTask,
//                       frequency: Duration(hours: 1),
//                     );
//                   }),
//               PlatformEnabledButton(
//                 platform: _Platform.android,
//                 child: Text("Cancel All"),
//                 onPressed: () async {
//                   await Workmanager().cancelAll();
//                   print('Cancel all tasks completed');
//         
