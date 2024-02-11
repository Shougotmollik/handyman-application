import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/back_widget.dart';
import 'package:handyman_admin_flutter/components/cached_image_widget.dart';
import 'package:handyman_admin_flutter/components/price_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/service_model.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/gallery/gallery_screen.dart';
import 'package:handyman_admin_flutter/screens/service/add_service_screen.dart';
import 'package:handyman_admin_flutter/utils/colors.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../gallery/gallery_component.dart';

class ServiceDetailHeaderComponent extends StatefulWidget {
  final ServiceData serviceDetail;
  final Function? callBack;

  ServiceDetailHeaderComponent({required this.serviceDetail, this.callBack});

  @override
  State<ServiceDetailHeaderComponent> createState() => _ServiceDetailHeaderComponentState();
}

class _ServiceDetailHeaderComponentState extends State<ServiceDetailHeaderComponent> {
  /// Delete Service
  Future<void> removeService(int? id) async {
    appStore.setLoading(true);
    await deleteService(id.validate()).then((value) {
      appStore.setLoading(false);

      finish(context, true);
      toast(value.message);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// Restore Service
  Future<void> restoreService() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.serviceDetail.id,
      type: RESTORE,
    };

    await serviceAction(req).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      finish(context, true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// ForceFully Delete Service
  Future<void> forceDeleteService() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.serviceDetail.id,
      type: FORCE_DELETE,
    };

    await serviceAction(req).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      finish(context, true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 475,
      width: context.width(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (widget.serviceDetail.imageAttachments.validate().isNotEmpty)
            SizedBox(
              height: 400,
              width: context.width(),
              child: CachedImageWidget(url: widget.serviceDetail.imageAttachments!.first, fit: BoxFit.cover, height: 400),
            ),
          Positioned(
            top: context.statusBarHeight + 8,
            left: 8,
            child: Container(
              padding: EdgeInsets.only(left: 8),
              child: BackWidget(color: context.iconColor),
              decoration: BoxDecoration(shape: BoxShape.circle, color: context.cardColor.withOpacity(0.7)),
            ),
          ),
          Positioned(
            top: context.statusBarHeight + 8,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(color: context.cardColor.withOpacity(0.7), shape: BoxShape.circle),
              child: PopupMenuButton(
                icon: Icon(Icons.more_horiz, size: 24, color: context.iconColor),
                padding: EdgeInsets.all(8),
                color: context.cardColor,
                onSelected: (selection) {
                  if (selection == 1) {
                    ifNotTester(context, () {
                      AddServiceScreen(data: widget.serviceDetail).launch(context).then((value) {
                        if (value ?? false) {
                          widget.callBack?.call();
                        }
                      });
                    });
                  } else if (selection == 2) {
                    showConfirmDialogCustom(
                      context,
                      dialogType: DialogType.DELETE,
                      title: locale.doYouWantToDelete,
                      positiveText: locale.delete,
                      negativeText: locale.cancel,
                      onAccept: (_) {
                        ifNotTester(context, () {
                          removeService(widget.serviceDetail.id.validate());
                        });
                      },
                    );
                  } else if (selection == 3) {
                    showConfirmDialogCustom(
                      context,
                      dialogType: DialogType.ACCEPT,
                      title: locale.doYouWantToRestore,
                      positiveText: locale.accept,
                      negativeText: locale.cancel,
                      onAccept: (_) {
                        ifNotTester(context, () {
                          restoreService();
                        });
                      },
                    );
                  } else if (selection == 4) {
                    showConfirmDialogCustom(
                      context,
                      dialogType: DialogType.DELETE,
                      title: locale.doYouWantToDeleteForcefully,
                      positiveText: locale.delete,
                      negativeText: locale.cancel,
                      onAccept: (_) {
                        ifNotTester(context, () {
                          forceDeleteService();
                        });
                      },
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text(locale.edit, style: boldTextStyle(color: widget.serviceDetail.deletedAt == null ? textPrimaryColorGlobal : textSecondaryColor)),
                    value: 1,
                    enabled: widget.serviceDetail.deletedAt == null,
                  ),
                  PopupMenuItem(
                    child: Text(locale.delete, style: boldTextStyle(color: widget.serviceDetail.deletedAt == null ? textPrimaryColorGlobal : textSecondaryColor)),
                    value: 2,
                    enabled: widget.serviceDetail.deletedAt == null,
                  ),
                  PopupMenuItem(
                    child: Text(locale.restore, style: boldTextStyle(color: widget.serviceDetail.deletedAt != null ? textPrimaryColorGlobal : textSecondaryColor)),
                    value: 3,
                    enabled: widget.serviceDetail.deletedAt != null,
                  ),
                  PopupMenuItem(
                    child: Text(locale.forceDelete, style: boldTextStyle(color: widget.serviceDetail.deletedAt != null ? textPrimaryColorGlobal : textSecondaryColor)),
                    value: 4,
                    enabled: widget.serviceDetail.deletedAt != null,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Row(
                  children: [
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: List.generate(
                        widget.serviceDetail.imageAttachments!.take(2).length,
                        (i) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: white, width: 2),
                            borderRadius: radius(),
                          ),
                          child: GalleryComponent(
                            images: widget.serviceDetail.imageAttachments!,
                            index: i,
                            padding: 32,
                            height: 60,
                            width: 60,
                          ),
                        ),
                      ),
                    ),
                    16.width,
                    if (widget.serviceDetail.imageAttachments!.length > 2)
                      Blur(
                        borderRadius: radius(),
                        padding: EdgeInsets.zero,
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: white, width: 2),
                            borderRadius: radius(),
                          ),
                          alignment: Alignment.center,
                          child: Text('+' '${widget.serviceDetail.imageAttachments!.length - 2}', style: boldTextStyle(color: white)),
                        ),
                      ).onTap(() {
                        GalleryScreen(
                          serviceName: widget.serviceDetail.name.validate(),
                          attachments: widget.serviceDetail.imageAttachments.validate(),
                        ).launch(context, pageRouteAnimation: PageRouteAnimation.Fade, duration: 400.milliseconds);
                      }),
                  ],
                ),
                16.height,
                Container(
                  width: context.width(),
                  padding: EdgeInsets.all(16),
                  decoration: boxDecorationDefault(
                    color: context.scaffoldBackgroundColor,
                    border: Border.all(color: context.dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.serviceDetail.subCategoryName.validate().isNotEmpty)
                        Marquee(
                          child: Row(
                            children: [
                              Text('${widget.serviceDetail.categoryName}', style: boldTextStyle(size: 12, color: textSecondaryColorGlobal)),
                              Text('  >  ', style: boldTextStyle(size: 14, color: textSecondaryColorGlobal)),
                              Text('${widget.serviceDetail.subCategoryName}', style: boldTextStyle(size: 12, color: primaryColor)),
                            ],
                          ),
                        )
                      else
                        Text('${widget.serviceDetail.categoryName}', style: boldTextStyle(size: 14, color: primaryColor)),
                      8.height,
                      Marquee(
                        child: Text('${widget.serviceDetail.name.validate()}', style: boldTextStyle(size: 18)),
                        directionMarguee: DirectionMarguee.oneDirection,
                      ),
                      4.height,
                      Row(
                        children: [
                          PriceWidget(
                            price: widget.serviceDetail.price.validate(),
                            isHourlyService: widget.serviceDetail.isHourlyService,
                            hourlyTextColor: textSecondaryColorGlobal,
                            isFreeService: widget.serviceDetail.isFreeService,
                          ),
                          4.width,
                          if (widget.serviceDetail.discount.validate() != 0)
                            Text(
                              '(${widget.serviceDetail.discount.validate()}% ${locale.off})',
                              style: boldTextStyle(color: Colors.green),
                            ),
                        ],
                      ),
                      4.height,
                      TextIcon(
                        edgeInsets: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                        text: locale.duration,
                        textStyle: secondaryTextStyle(size: 14),
                        expandedText: true,
                        suffix: Text("${widget.serviceDetail.duration.validate()} ${locale.hour}", style: boldTextStyle(color: primaryColor)),
                      ),
                      TextIcon(
                        text: '${locale.rating}',
                        textStyle: secondaryTextStyle(size: 14),
                        edgeInsets: EdgeInsets.symmetric(vertical: 4),
                        expandedText: true,
                        suffix: Row(
                          children: [
                            Image.asset(
                              ic_star_fill,
                              height: 18,
                              color: getRatingBarColor(widget.serviceDetail.totalRating.validate().toInt()),
                            ),
                            4.width,
                            Text("${widget.serviceDetail.totalRating.validate().toStringAsFixed(1)}", style: boldTextStyle()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
