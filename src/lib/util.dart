import 'package:duration/duration.dart';
import 'package:intl/intl.dart';

class Util {
  static RoundedDuration maxTersity(Duration dur) {
    for (final t in DurationTersity.list) {
      var n = dur.inUnit(t);
      // stop at seconds
      if (n > 0 || t == DurationTersity.second) {
        return RoundedDuration(t, n);
      }
    }

    throw Never;
  }
}

class RoundedDuration {
  DurationTersity tersity;
  int amount;

  RoundedDuration(this.tersity, this.amount);

  String pluralizedTersity() {
    return Intl.plural(amount, one: tersity.name, other: tersity.name + 's');
  }

  String formatted() {
    return '$amount ${tersity.name[0].toUpperCase()}${pluralizedTersity().substring(1).toLowerCase()}';
  }
}
