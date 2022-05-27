import 'dart:async';

import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:quiver/pattern.dart';

import 'steps/type_in.dart';
import 'steps/users_step.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/**.feature")]
    ..reporters = [ProgressReporter(), TestRunSummaryReporter()]
    ..stepDefinitions = [TypeInStep(), UsersStep()]
    ..logFlutterProcessOutput = true
    ..verboseFlutterProcessLogs = true
    ..restartAppBetweenScenarios = true
    // ..targetAppWorkingDirectory = '../'
    ..targetAppPath = "test_driver/app.dart";

  return GherkinRunner().execute(config);
}
