import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric UsersStep() {
  return given1('I have users:', (GherkinTable table, context) async {
    for (var row in table.rows) {
      var cols = row.columns.where((s) => s != null).map((s) => s!.trim()).toList();
      if (cols.length == 2) {
        print(cols[0] + ' ' + cols[1]);
        // FirebaseAuth.instance
        //     .createUserWithEmailAndPassword(email: cols[0].trim(), password: cols[1].trim());
      }
    }
  });
}
