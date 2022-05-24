import 'dart:async';
import 'package:gherkin/gherkin.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';

import 'steps/type_in.dart';
import 'steps/users_step.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [RegExp('features/*.*.feature')]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      // JsonReporter(path: './report.json')
    ]
    ..stepDefinitions = [UsersStep(), TypeInStep()]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";

  return GherkinRunner().execute(config);
}
