import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/configs.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

Future<Color> getMaterialYouData() async {
  if (appStore.useMaterialYouTheme && await isAndroid12Above()) {
    primaryColor = await getMaterialYouPrimaryColor();
  } else {
    primaryColor = defaultPrimaryColor;
  }

  setStatusBarColor(primaryColor, delayInMilliSeconds: 3000);

  return primaryColor;
}
