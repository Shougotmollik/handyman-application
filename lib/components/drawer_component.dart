import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/image_border_component.dart';
import 'package:handyman_admin_flutter/configs.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/drawer_model.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/colors.dart';

class DrawerComponent extends StatefulWidget {
  @override
  _DrawerComponentState createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  @override
  void initState() {
    setStatusBarColor(primaryColor);
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: isIOS ? false : true,
      child: Column(
        children: [
          Container(
            color: primaryColor,
            padding: EdgeInsets.only(top: 24, bottom: 24, left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ImageBorder(
                  src: appStore.userProfileImage,
                  height: 50,
                  width: 50,
                ),
                8.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appStore.userFullName.validate(), style: boldTextStyle(color: white, size: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(appStore.userEmail.validate(), style: secondaryTextStyle(color: white), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ).expand(),

                ///Edit Admin Profile
                /*IconButton(
                  icon: Icon(Icons.edit, color: white),
                  onPressed: () {
                    finish(context);
                    EditProfileScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                  },
                ),*/
              ],
            ),
          ),
          AnimatedListView(
              slideConfiguration: SlideConfiguration(delay: 30.milliseconds),
              itemCount: getDrawerItems().length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (_, i) {
                DrawerModel data = getDrawerItems()[i];

                return data.widgets.validate().isEmpty
                    ? SettingItemWidget(
                        title: data.title.validate(),
                        titleTextStyle: boldTextStyle(size: 14),
                        onTap: () {
                          if (kReleaseMode) {
                            finish(context);
                          }

                          if (data.widget != null) {
                            data.widget.launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                          } else if (data.shareApp.validate()) {
                            Share.share('${locale.share} $APP_NAME ${locale.withYourFriends}.\n\n$playStoreBaseURL$currentPackageName');
                          } else if (data.url.validate().isNotEmpty) {
                            launchUrl(Uri.parse(data.url!), mode: LaunchMode.externalApplication);
                          }
                        },
                      )
                    : ExpansionTile(
                        title: Text(data.title.validate(), style: boldTextStyle()),
                        tilePadding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                        children: data.widgets!.map((e) {
                          return SettingItemWidget(
                            title: e.title.validate(),
                            titleTextStyle: primaryTextStyle(),
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            onTap: () {
                              if (kReleaseMode) {
                                finish(context);
                              }

                              if (e.widget != null) {
                                e.widget.launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                              } else if (e.shareApp.validate()) {
                                Share.share('${locale.share} $APP_NAME ${locale.withYourFriends}.\n\n$playStoreBaseURL$currentPackageName');
                              } else if (e.url.validate().isNotEmpty) {
                                launchUrl(Uri.parse(e.url!), mode: LaunchMode.externalApplication);
                              }
                            },
                          );
                        }).toList(),
                      );
              }).expand(),
          Divider(color: context.dividerColor, height: 0.5, thickness: 1.0),
          Column(
            children: [
              TextButton(
                child: Text(locale.logout.capitalizeFirstLetter(), style: boldTextStyle()),
                onPressed: () {
                  appStore.setLoading(false);
                  logout(context);
                },
              ),
              VersionInfoWidget(prefixText: locale.v, textStyle: secondaryTextStyle(size: 14)).center(),
            ],
          ),
          16.height,
        ],
      ),
    );
  }
}
