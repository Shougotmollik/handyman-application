import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/empty_error_state_widget.dart';
import 'package:handyman_admin_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/back_widget.dart';
import '../../components/cached_image_widget.dart';
import '../../components/price_widget.dart';
import '../../main.dart';
import '../../model/Package_response.dart';
import '../../model/service_model.dart';
import '../../utils/constant.dart';
import '../../utils/images.dart';
import '../gallery/gallery_component.dart';
import '../gallery/gallery_screen.dart';

class PackageDetailScreen extends StatefulWidget {
  final PackageData? packageData;

  PackageDetailScreen({this.packageData});

  @override
  _PackageDetailScreenState createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(primaryColor, delayInMilliSeconds: 1000);
  }

  Widget headerWidget() {
    return SizedBox(
      height: 475,
      width: context.width(),
      child: Stack(
        children: [
          if (widget.packageData!.attchments.validate().isNotEmpty)
            SizedBox(
              height: 400,
              width: context.width(),
              child: CachedImageWidget(
                url: widget.packageData!.attchments!.first.url.validate(),
                fit: BoxFit.cover,
                height: 400,
              ),
            ),
          Positioned(
            top: context.statusBarHeight + 8,
            left: 8,
            child: Container(
              child: BackWidget(color: context.iconColor).paddingLeft(8),
              decoration: BoxDecoration(shape: BoxShape.circle, color: context.cardColor.withOpacity(0.7)),
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
                        widget.packageData!.attchments.validate().take(2).length,
                        (i) => Container(
                          decoration: BoxDecoration(border: Border.all(color: white, width: 2), borderRadius: radius()),
                          child: GalleryComponent(
                            images: widget.packageData!.attchments.validate().map((e) => e.url.validate()).toList(),
                            index: i,
                            padding: 32,
                            height: 60,
                            width: 60,
                          ),
                        ),
                      ),
                    ),
                    16.width,
                    if (widget.packageData!.attchments.validate().length > 2)
                      Blur(
                        borderRadius: radius(),
                        padding: EdgeInsets.zero,
                        child: Container(
                          height: 60,
                          width: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(border: Border.all(color: white, width: 2), borderRadius: radius()),
                          child: Text('+' '${widget.packageData!.attchments!.length - 2}', style: boldTextStyle(color: white)),
                        ),
                      ).onTap(
                        () {
                          GalleryScreen(
                            attachments: widget.packageData!.attchments.validate().map((e) => e.url.validate()).toList(),
                            serviceName: widget.packageData!.name.validate(),
                          ).launch(context, pageRouteAnimation: PageRouteAnimation.Fade, duration: 400.milliseconds).then((value) {
                            setStatusBarColor(transparentColor, delayInMilliSeconds: 1000);
                          });
                        },
                      ),
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
                      4.height,
                      Marquee(
                        child: Text('${widget.packageData!.name.validate()}', style: boldTextStyle(size: 16)),
                        directionMarguee: DirectionMarguee.oneDirection,
                      ),
                      4.height,
                      if (widget.packageData!.subCategoryName.validate().isNotEmpty)
                        Marquee(
                          child: Row(
                            children: [
                              Text('${widget.packageData!.categoryName.validate()}', style: boldTextStyle(size: 14, color: textSecondaryColorGlobal)),
                              Text('  >  ', style: boldTextStyle(size: 14, color: textSecondaryColorGlobal)),
                              Text('${widget.packageData!.subCategoryName.validate()}', style: boldTextStyle(size: 14, color: context.primaryColor)),
                            ],
                          ),
                        )
                      else if (widget.packageData!.categoryName != null)
                        Text('${widget.packageData!.categoryName.validate()}', style: boldTextStyle(size: 14, color: context.primaryColor))
                      else
                        Offstage(),
                      8.height,
                      PriceWidget(
                        price: widget.packageData!.price.validate(),
                        hourlyTextColor: textSecondaryColorGlobal,
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

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerWidget(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(locale.description, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                    8.height,
                    widget.packageData!.description.validate().isNotEmpty
                        ? ReadMoreText(widget.packageData!.description.validate(), style: secondaryTextStyle())
                        : Text(locale.noDescriptionAvailable, style: secondaryTextStyle()),
                    24.height,
                  ],
                ),
                Text(locale.services, style: boldTextStyle()),
                8.height,
                if (widget.packageData!.serviceList != null)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: widget.packageData!.serviceList!.length,
                    itemBuilder: (_, i) {
                      ServiceData data = widget.packageData!.serviceList![i];

                      return Container(
                        width: context.width(),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: boxDecorationWithRoundedCorners(
                          borderRadius: radius(),
                          backgroundColor: context.cardColor,
                          border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedImageWidget(
                              url: data.imageAttachments!.isNotEmpty ? data.imageAttachments!.first : "",
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                              radius: 8,
                            ),
                            16.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Marquee(child: Text(data.name.validate(), style: boldTextStyle(size: LABEL_TEXT_SIZE))),
                                4.height,
                                if (data.subCategoryName.validate().isNotEmpty)
                                  Marquee(
                                    child: Row(
                                      children: [
                                        Text('${data.categoryName}', style: boldTextStyle(size: 14, color: textSecondaryColorGlobal)),
                                        Text('  >  ', style: boldTextStyle(size: 14, color: textSecondaryColorGlobal)),
                                        Text('${data.subCategoryName}', style: boldTextStyle(size: 14, color: context.primaryColor)),
                                      ],
                                    ),
                                  )
                                else
                                  Text('${data.categoryName}', style: boldTextStyle(size: 14, color: context.primaryColor)),
                                4.height,
                                PriceWidget(
                                  price: data.price.validate(),
                                  hourlyTextColor: Colors.white,
                                  size: 14,
                                ),
                              ],
                            ).expand()
                          ],
                        ),
                      );
                    },
                  )
                else
                  NoDataWidget(
                    title: locale.noServiceFound,
                    imageWidget: EmptyStateWidget(),
                  ),
              ],
            ).paddingSymmetric(horizontal: 16)
          ],
        ),
      ),
      floatingActionButton: (widget.packageData!.isFeatured == 1)
          ? FloatingActionButton(
              elevation: 0.0,
              child: Image.asset(featured, height: 22, width: 22, color: white),
              backgroundColor: context.primaryColor,
              onPressed: () {
                toast(locale.featureProduct);
              },
            )
          : Offstage(),
    );
  }
}
