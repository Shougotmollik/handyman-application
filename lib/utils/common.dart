import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:handyman_admin_flutter/components/html_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:html/parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/colors.dart';

/// DO NOT CHANGE THIS PACKAGE NAME
bool get isIqonicProduct => currentPackageName == APP_PACKAGE_NAME;

Widget get trailing {
  return ic_arrow_right.iconImage(size: 16);
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'assets/flag/ic_us.png'),
    LanguageDataModel(id: 2, name: 'Hindi', languageCode: 'hi', fullLanguageCode: 'hi-IN', flag: 'assets/flag/ic_india.png'),
    LanguageDataModel(id: 3, name: 'Arabic', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'assets/flag/ic_ar.png'),
    LanguageDataModel(id: 4, name: 'French', languageCode: 'fr', fullLanguageCode: 'fr-FR', flag: 'assets/flag/ic_fr.png'),
    LanguageDataModel(id: 5, name: 'German', languageCode: 'de', fullLanguageCode: 'de-DE', flag: 'assets/flag/ic_de.png'),
  ];
}

Decoration cardDecoration(BuildContext context, {Color? color, bool showBorder = true}) {
  return boxDecorationWithRoundedCorners(
    borderRadius: radius(),
    backgroundColor: color ?? context.scaffoldBackgroundColor,
    border: showBorder ? Border.all(color: context.dividerColor, width: 1.0) : null,
  );
}

Decoration categoryDecoration(BuildContext context, {Color? color, bool showBorder = true}) {
  return boxDecorationWithRoundedCorners(
    borderRadius: radius(),
    backgroundColor: color ?? context.cardColor,
    border: showBorder ? Border.all(color: context.dividerColor, width: 1.0) : null,
  );
}

InputDecoration inputDecoration(BuildContext context, {Widget? prefixIcon, String? hint, Color? fillColor, String? counterText, double? borderRadius}) {
  return InputDecoration(
    contentPadding: EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: hint,
    labelStyle: secondaryTextStyle(),
    alignLabelWithHint: true,
    counterText: counterText,
    prefixIcon: prefixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: primaryColor, width: 0.0),
    ),
    filled: true,
    fillColor: fillColor ?? context.cardColor,
  );
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

String formatDate(String? dateTime, {String format = DATE_FORMAT_1}) {
  if (dateTime.validate().isNotEmpty) {
    return DateFormat(format).format(DateTime.parse(dateTime.validate()));
  } else {
    return '';
  }
}

String durationToString(int minutes) {
  var d = Duration(minutes: minutes);
  List<String> parts = d.toString().split(':');
  return '${parts[0].padLeft(2, '0')} :${parts[1].padLeft(2, '0')} min';
}

bool get isRTL => RTL_LANGUAGES.contains(appStore.selectedLanguageCode);

bool get isUserTypeAdmin => appStore.userType == USER_TYPE_ADMIN;

bool get isUserTypeHandyman => appStore.userType == USER_TYPE_HANDYMAN;

bool get isUserTypeProvider => appStore.userType == USER_TYPE_PROVIDER;

bool isTaxTypePercent(String? type) => type.validate() == PERCENT;

bool get isCurrencyPositionLeft => getStringAsync(CONFIGURATION_TYPE_CURRENCY_POSITION, defaultValue: CURRENCY_POSITION_LEFT) == CURRENCY_POSITION_LEFT;

bool get isCurrencyPositionRight => getStringAsync(CONFIGURATION_TYPE_CURRENCY_POSITION, defaultValue: CURRENCY_POSITION_LEFT) == CURRENCY_POSITION_RIGHT;

Brightness getStatusBrightness({required bool val}) {
  return val ? Brightness.light : Brightness.dark;
}

String getPaymentStatusText(String? status, String? method) {
  if (status!.isEmpty) {
    return locale.pending;
  } else if (status == SERVICE_PAYMENT_STATUS_PAID) {
    return locale.paid;
  } else if (status == PAYMENT_STATUS_ADVANCE) {
    return locale.advancePaid;
  } else if (status == SERVICE_PAYMENT_STATUS_PENDING && method == PAYMENT_METHOD_COD) {
    return locale.pendingApproval;
  } else if (status == SERVICE_PAYMENT_STATUS_PENDING) {
    return locale.pending;
  } else if (status == SERVICE_PAYMENT_STATUS_PENDING_BY_ADMIN) {
    return locale.pendingByAdmin;
  } else {
    return "";
  }
}

String buildPaymentStatusWithMethod(String status, String method) {
  return '${getPaymentStatusText(status, method)}${status == SERVICE_PAYMENT_STATUS_PAID ? ' ${locale.by} $method' : ''}';
}

Color getRatingBarColor(int rating) {
  if (rating == 1 || rating == 2) {
    return ratingBarColor;
  } else if (rating == 3) {
    return Color(0xFFff6200);
  } else if (rating == 4 || rating == 5) {
    return Color(0xFF73CB92);
  } else {
    return ratingBarColor;
  }
}

void ifNotTester(BuildContext context, VoidCallback callback) {
  if (appStore.userEmail.trim() != DEMO_ADMIN_EMAIL) {
    callback.call();
  } else {
    toast(locale.demoUserCannotBe);
  }
}

void launchUrlCustomTab(String? url) {
  if (url.validate().isNotEmpty) {
    custom_tabs.launch(
      url!,
      customTabsOption: custom_tabs.CustomTabsOption(
        enableDefaultShare: true,
        enableInstantApps: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        toolbarColor: primaryColor,
      ),
      safariVCOption: custom_tabs.SafariViewControllerOption(
        preferredBarTintColor: primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  }
}

void checkIfLink(BuildContext context, String value, {String? title}) {
  if (value.validate().isEmpty) return;

  String temp = parseHtmlString(value.validate());
  if (temp.startsWith("http")) {
    launchUrlCustomTab(temp.validate());
  } else if (temp.validateEmail()) {
    launchMail(temp);
  } else if (temp.validatePhone() || temp.startsWith('+')) {
    launchCall(temp);
  } else {
    HtmlWidget(postContent: value, title: title).launch(context);
  }
}

void launchMap(String? url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl(GOOGLE_MAP_PREFIX + url!, launchMode: LaunchMode.externalApplication);
  }
}

Future<void> commonLaunchUrl(String address, {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    toast('Invalid URL: $address');
  });
}

void launchCall(String? url) {
  if (url.validate().isNotEmpty) {
    if (isIOS)
      commonLaunchUrl('tel://' + url!, launchMode: LaunchMode.externalApplication);
    else
      commonLaunchUrl('tel:' + url!, launchMode: LaunchMode.externalApplication);
  }
}

void launchMail(String? url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl('mailto:' + url!, launchMode: LaunchMode.externalApplication);
  }
}

// Logic For Calculate Time
String calculateTimer(int secTime) {
  int hour = 0, minute = 0;
  //int hour = 0, minute = 0, seconds = 0;

  hour = secTime ~/ 3600;

  minute = ((secTime - hour * 3600)) ~/ 60;

  //seconds = secTime - (hour * 3600) - (minute * 60);

  String hourLeft = hour.toString().length < 2 ? "0" + hour.toString() : hour.toString();

  String minuteLeft = minute.toString().length < 2 ? "0" + minute.toString() : minute.toString();

  String minutes = minuteLeft == '00' ? '01' : minuteLeft;

  String result = "$hourLeft:$minutes";

  return result;
}

Future<List<File>> getMultipleImageSource({bool isCamera = true}) async {
  final pickedImage = await ImagePicker().pickMultiImage();
  return pickedImage.map((e) => File(e.path)).toList();
}

Future<File> getCameraImage({bool isCamera = true}) async {
  final pickedImage = await ImagePicker().pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
  return File(pickedImage!.path);
}
