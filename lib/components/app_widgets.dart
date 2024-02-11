import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/spin_kit_chasing_dots.dart';
import 'package:handyman_admin_flutter/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

Widget placeHolderWidget({String? placeHolderImage, double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment}) {
  return PlaceHolderWidget(
    height: height,
    width: width,
    alignment: alignment ?? Alignment.center,
  );
}

String commonPrice(num price) {
  var formatter = NumberFormat('#,##,000.00');
  return formatter.format(price);
}

class LoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(color: primaryColor);
  }
}
