import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:tomodachi/utility/helper.dart';

void main() {
  group('DateTime Functions', () {
    test('Format the date correctly.', () {
      DateTime date = DateTime(2021, 10, 3);
      String result = formatDate(Timestamp.fromDate(date));
      expect(result, 'October 03, 2021');
    });

    test('Format the date with timestamp correctly.', () {
      DateTime date = DateTime(2021, 2, 7);
      String result = formatTimestamp(Timestamp.fromDate(date));
      expect(result, '02/07/2021, 12:00 AM');
    });
  });
}