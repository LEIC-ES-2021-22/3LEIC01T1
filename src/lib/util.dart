import 'package:duration/duration.dart';
import 'package:intl/intl.dart';

class FlooredDuration {
  DurationTersity tersity;
  int amount;

  FlooredDuration(this.tersity, this.amount);

  static FlooredDuration fromDuration(Duration dur) {
    for (final t in DurationTersity.list) {
      var n = dur.inUnit(t);
      // stop at seconds
      if (n > 0 || t == DurationTersity.second) {
        return FlooredDuration(t, n);
      }
    }

    throw Never;
  }



  String pluralizedTersity() {
    return Intl.plural(amount, one: tersity.name, other: tersity.name + 's');
  }

  String formatted() {
    return '$amount ${tersity.name[0].toUpperCase()}${pluralizedTersity().substring(1).toLowerCase()}';
  }

  @override
  String toString() {
    return formatted();
  }
}
