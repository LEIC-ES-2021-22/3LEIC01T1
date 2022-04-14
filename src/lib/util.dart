import 'package:duration/duration.dart';
import 'package:intl/intl.dart';

class Util {
  static List<String> maxTersity(Duration dur) {
    var n = dur.inSeconds;
    var txt = Intl.plural(dur.inSeconds, one: "Second", other: "Seconds");

    if ((n = dur.inWeeks) > 0) {
      txt = Intl.plural(dur.inWeeks, one: "Week", other: "Weeks");
    } else if ((n = dur.inDays) > 0) {
      txt = Intl.plural(dur.inDays, one: "Day", other: "Days");
    } else if ((n = dur.inHours) > 0) {
      txt = Intl.plural(dur.inHours, one: "Hour", other: "Hours");
    } else if ((n = dur.inMinutes) > 0) {
      txt = Intl.plural(dur.inMinutes, one: "Minute", other: "Minutes");
    } else {
      n = dur.inSeconds;
      txt = Intl.plural(dur.inSeconds, one: "Second", other: "Seconds");
    }

    return [n.toString(), txt];
  }

  static String formattedDuration(Duration dur) {
    final r = maxTersity(dur);
    return '${r[0]} ${r[1]}';
  }
}
