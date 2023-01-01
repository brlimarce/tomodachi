import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tomodachi/utility/palette.dart';

/// Returns a [LoadingIndicator] to indicate the
/// progress of a certain process.
Center Loader() {
  return const Center(
      child: LoadingIndicator(
    indicatorType: Indicator.ballRotateChase,
    colors: [Palette.ORANGE, Palette.RED, Palette.GREEN, Palette.BLUE],
    strokeWidth: 2,
    backgroundColor: Colors.transparent,
  ));
}

/// Display the [LoadingIndicator].
showLoader(BuildContext context) {
  context.loaderOverlay.show();
}

/// Hide the [LoadingIndicator] with a
/// delay of two (2) seconds.
hideLoader(BuildContext context, {isDelay = false}) async {
  // Add a delay of 2 seconds if desired.
  if (isDelay) {
    await Future.delayed(const Duration(seconds: 2));
  }

  // Hide the loading indicator.
  context.loaderOverlay.hide();
}
