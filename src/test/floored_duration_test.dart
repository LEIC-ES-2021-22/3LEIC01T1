import 'package:duration/duration.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remind_me_up/util.dart';

void main() {
  group('FlooredDuration', () {
    test('day singular', () {
      final str = FlooredDuration(DurationTersity.day, 1).toString();
      expect(str, '1 Day');
    });

    test('day plural', () {
      final str = FlooredDuration(DurationTersity.day, 2).toString();
      expect(str, '2 Days');
    });

    test('week singular', () {
      final str = FlooredDuration(DurationTersity.week, 1).toString();
      expect(str, '1 Week');
    });

    test('week plural', () {
      final str = FlooredDuration(DurationTersity.week, 2).toString();
      expect(str, '2 Weeks');
    });

    test('fromDuration 0', () {
      final dur = FlooredDuration.fromDuration(
        const Duration(days: 1, minutes: 9),
      );
      expect(dur, FlooredDuration(DurationTersity.day, 1));
    });

    test('fromDuration 1', () {
      final dur = FlooredDuration.fromDuration(
        const Duration(days: 1, hours: 23, minutes: 59),
      );
      expect(dur, FlooredDuration(DurationTersity.day, 1));
    });

    test('fromDuration test with tersity overflow', () {
      final dur = FlooredDuration.fromDuration(
        const Duration(days: 1, hours: 23, minutes: 60),
      );
      expect(dur, FlooredDuration(DurationTersity.day, 2));
    });

    test('fromDuration zero', () {
      final dur = FlooredDuration.fromDuration(
        const Duration(),
      );
      expect(dur, FlooredDuration(DurationTersity.second, 0));
    });

    test('fromDuration less than a second', () {
      final dur = FlooredDuration.fromDuration(
        const Duration(milliseconds: 23, microseconds: 2323),
      );
      expect(dur, FlooredDuration(DurationTersity.second, 0));
    });

    test('fromDuration negative 0', () {
      final dur = FlooredDuration.fromDuration(
        const Duration(days: -1),
      );
      expect(dur, FlooredDuration(DurationTersity.day, 1));
    });

    test('fromDuration negative 1', () {
      final dur = FlooredDuration.fromDuration(
        const Duration(hours: -4),
      );
      expect(dur, FlooredDuration(DurationTersity.hour, 4));
    });
  });
}
