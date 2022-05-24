import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric UsersStep() {
  return given1('I have users:', (GherkinTable table, context) async {
    for (var row in table.rows) {
      var cols = row.columns.where((s) => s != null).map((s) => s!.trim()).toList();
      if (cols.length == 2) {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: cols[0].trim(), password: cols[1].trim());
      }
    }
  });
}
