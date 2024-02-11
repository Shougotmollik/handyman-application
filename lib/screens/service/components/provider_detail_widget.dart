import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/disabled_rating_bar_widget.dart';
import 'package:handyman_admin_flutter/components/image_border_component.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/user_data.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/colors.dart';

class BookingDetailProviderWidget extends StatefulWidget {
  final UserData providerData;

  BookingDetailProviderWidget({required this.providerData});

  @override
  BookingDetailProviderWidgetState createState() => BookingDetailProviderWidgetState();
}

class BookingDetailProviderWidgetState extends State<BookingDetailProviderWidget> {
  UserData userData = UserData();

  int? flag;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    userData = widget.providerData;

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ImageBorder(
                src: widget.providerData.profileImage.validate(),
                height: 50,
                width: 50,
              ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.providerData.displayName}', style: boldTextStyle()),
                  4.height,
                  DisabledRatingBarWidget(rating: widget.providerData.providersServiceRating.validate()),
                ],
              ).expand(),
              if (widget.providerData.isVerifyProvider != null) Image.asset(ic_verified, height: 24, width: 24, color: verifyAcColor),
            ],
          ),
          16.height,
          TextIcon(
            spacing: 10,
            onTap: () {
              launchMail("${widget.providerData.email.validate()}");
            },
            prefix: Image.asset(ic_message, width: 14, height: 14, color: appStore.isDarkMode ? Colors.white : Colors.black),
            text: '${widget.providerData.email.validate()}',
          ),
          if (widget.providerData.address.validate().isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                TextIcon(
                  spacing: 10,
                  onTap: () {
                    launchMap("${widget.providerData.address.validate()}");
                  },
                  expandedText: true,
                  prefix: Image.asset(ic_location, width: 14, height: 16, color: appStore.isDarkMode ? Colors.white : Colors.black),
                  text: '${widget.providerData.address.validate()}',
                ),
              ],
            ),
          8.height,
          TextIcon(
            spacing: 10,
            onTap: () {
              launchCall(widget.providerData.contactNumber.validate());
            },
            prefix: Image.asset(calling, width: 14, height: 14, color: appStore.isDarkMode ? Colors.white : Colors.black),
            text: '${widget.providerData.contactNumber.validate()}',
          ),
        ],
      ),
    );
  }
}
