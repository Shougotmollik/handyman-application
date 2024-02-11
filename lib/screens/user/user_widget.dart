import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/cached_image_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/user_data.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/user_name_widget.dart';
import '../../utils/colors.dart';
import 'add_update_user_screen.dart';

class UserWidget extends StatefulWidget {
  final double width;
  final UserData? data;
  final Function? onUpdate;

  UserWidget({required this.width, this.data, this.onUpdate});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  Future<void> changeStatus(int? id, int status) async {
    appStore.setLoading(true);
    Map request = {CommonKeys.id: widget.data!.id.validate(), UserKeys.status: status};

    await updateUserStatus(request).then((value) {
      appStore.setLoading(false);
      toast(value.message.toString(), print: true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
      widget.data!.isActive = !widget.data!.isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.width,
          decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: appStore.isDarkMode ? context.scaffoldBackgroundColor : white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
                  color: primaryColor.withOpacity(0.2),
                ),
                child: CachedImageWidget(
                  url: widget.data!.profileImage.validate(),
                  width: context.width(),
                  height: 110,
                  fit: BoxFit.cover,
                  circle: false,
                ).cornerRadiusWithClipRRectOnly(topRight: defaultRadius.toInt(), topLeft: defaultRadius.toInt()),
              ),
              Column(
                children: [
                  UserNameWidget(data: widget.data!, size: 12).center(),
                  8.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.data!.contactNumber.validate().isNotEmpty)
                        TextIcon(
                          onTap: () {
                            launchCall(widget.data!.contactNumber.validate());
                          },
                          prefix: Container(
                            padding: EdgeInsets.all(8),
                            decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle,
                              backgroundColor: primaryColor.withOpacity(0.1),
                            ),
                            child: Image.asset(calling, color: primaryColor, height: 14, width: 14),
                          ),
                        ),
                      if (widget.data!.email.validate().isNotEmpty)
                        TextIcon(
                          onTap: () {
                            launchMail(widget.data!.email.validate());
                          },
                          prefix: Container(
                            padding: EdgeInsets.all(8),
                            decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle,
                              backgroundColor: primaryColor.withOpacity(0.1),
                            ),
                            child: ic_message.iconImage(size: 14, color: primaryColor),
                          ),
                        ),
                    ],
                  ),
                ],
              ).paddingSymmetric(vertical: 16),
            ],
          ),
        ).onTap(
          () async {
            hideKeyboard(context);
            bool? res = await AddUpdateUserScreen(
              userData: widget.data,
              onUpdate: () {
                widget.onUpdate?.call();
              },
              userType: widget.data!.userType.validate(),
            ).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);

            if (res ?? false) {
              widget.onUpdate?.call();
            }
          },
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          borderRadius: radius(),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: boxDecorationWithRoundedCorners(
              boxShape: BoxShape.circle,
              backgroundColor: context.cardColor,
            ),
            alignment: Alignment.center,
            child: !widget.data!.isActive ? Image.asset(block, width: 16, height: 16) : Image.asset(unBlock, width: 16, height: 16),
          ).onTap(
            () {
              ifNotTester(context, () {
                if (widget.data!.deletedAt == null) {
                  if (widget.data!.isActive) {
                    changeStatus(widget.data!.id.validate(), 0);
                  } else {
                    changeStatus(widget.data!.id.validate(), 1);
                  }
                  widget.data!.isActive = !widget.data!.isActive;
                } else {
                  toast(locale.youCanTUpdateDeleted);
                }
              });
              setState(() {});
            },
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        )
      ],
    );
  }
}
