import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/components/back_widget.dart';
import 'package:handyman_admin_flutter/components/user_info_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/provider_info_model.dart';
import 'package:handyman_admin_flutter/model/user_data.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class ProviderInfoScreen extends StatefulWidget {
  final int? providerId;

  ProviderInfoScreen({this.providerId});

  @override
  ProviderInfoScreenState createState() => ProviderInfoScreenState();
}

class ProviderInfoScreenState extends State<ProviderInfoScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget emailWidget({required UserData data}) {
    return Container(
      decoration: boxDecorationDefault(color: context.cardColor),
      padding: EdgeInsets.all(16),
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(locale.email, style: secondaryTextStyle()),
              4.height,
              Text(data.email.validate(), style: boldTextStyle()),
              24.height,
            ],
          ).onTap(() {
            launchMail(" ${data.email.validate()}");
          }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(locale.contactNumber, style: secondaryTextStyle()),
              4.height,
              Text(data.contactNumber.validate(), style: boldTextStyle()),
              24.height,
            ],
          ).onTap(() {
            launchCall(data.contactNumber.validate());
          }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(locale.memberSince, style: secondaryTextStyle()),
              4.height,
              Text("${DateTime.parse(data.createdAt.validate()).year}", style: boldTextStyle()),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserDetailResponse>(
      future: getUserDetail(widget.providerId.validate()),
      builder: (context, snap) {
        return Scaffold(
          appBar: appBarWidget(
            locale.aboutProvider,
            textColor: white,
            elevation: 1.5,
            color: context.primaryColor,
            backWidget: BackWidget(),
          ),
          body: snap.hasData
              ? Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserInfoWidget(data: snap.data!.userData!, isOnTapEnabled: true),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              16.height,
                              Text(locale.about, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                              16.height,
                              if (snap.data!.userData!.description.validate().isNotEmpty) Text(snap.data!.userData!.description.validate(), style: boldTextStyle()),
                              emailWidget(data: snap.data!.userData!),
                              16.height,
                              //servicesWidget(list: snap.data!.serviceList!, providerId: widget.providerId.validate()),
                            ],
                          ).paddingAll(16),
                        ],
                      ),
                    ),
                  ],
                )
              : LoaderWidget(),
        );
      },
    );
  }
}
