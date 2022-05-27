import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';

StepDefinitionGeneric TypeInStep() {
  return when2<String, String, FlutterWorld>('I type {string} in {string}',
      (text, key, context) async {
    final locator = find.byValueKey(key);
    await FlutterDriverUtils.enterText(context.world.driver, locator, text);
  });
}
