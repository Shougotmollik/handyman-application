import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/colors.dart';

class TotalWidget extends StatelessWidget {
  final String title;
  final String total;
  final String icon;
  final double? height;
  final double? width;
  final Color? color;

  TotalWidget({required this.title, required this.total, required this.icon, this.height, this.width, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: cardDecoration(context, showBorder: true),
      width: context.width() / 2 - 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: context.width() / 2 - 94,
                child: Marquee(child: Text(total.validate(), style: boldTextStyle(color: primaryColor, size: 16), maxLines: 1)),
              ),
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appStore.isDarkMode ? cardDarkColor : primaryColor.withOpacity(0.1),
                ),
                child: Image.asset(icon, width: width ?? 18, height: width ?? 18, color: primaryColor),
              ),
            ],
          ),
          8.height,
          Marquee(child: Text(title, style: secondaryTextStyle(size: 12))),
        ],
      ),
    );
  }
}
