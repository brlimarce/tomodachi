import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tomodachi/utility/palette.dart';

/// Formats [Timestamp] into a [Date] string to
/// be displayed in the app.
String formatDate(Timestamp time) {
  DateFormat formatter = DateFormat('MMMM dd, yyyy');
  return formatter.format(time.toDate());
}

/// Format a presentable version of the [Timestamp].
String formatTimestamp(Timestamp time) {
  DateFormat formatter = DateFormat('MM/dd/yyyy, hh:mm a');
  return formatter.format(time.toDate());
}

/// Returns a customized [Widget] for displaying
/// the error from [Stream].
Widget displayStreamError(AsyncSnapshot snapshot) {
  return Center(
      child: Text('Error: ${snapshot.error}',
          style: const TextStyle(
              color: Palette.RED, fontWeight: FontWeight.w700)));
}

/// Displays a loading indicator while fetching
/// data from Firebase.
Widget displaySmallLoader() {
  return const Center(child: CircularProgressIndicator());
}

/// Returns a customized [Widget] for displaying a
/// message for no data in the stream.
Widget displayNoStream(AsyncSnapshot snapshot) {
  return const Center(
      child:
          Text('No data found', style: TextStyle(fontWeight: FontWeight.w700)));
}
