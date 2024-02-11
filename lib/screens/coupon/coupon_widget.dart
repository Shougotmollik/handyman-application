import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/coupon_model.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/utils/colors.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

///Remove Useless file
class CouponWidget extends StatefulWidget {
  final CouponData data;
  final double width;

  CouponWidget({required this.data, required this.width});

  @override
  State<CouponWidget> createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  Future<void> changeStatus(CouponData data, int status) async {
    appStore.setLoading(true);
    Map request = {
      CommonKeys.id: data.id,
      UserKeys.status: status,
      "code": data.code,
      "discount_type": data.discountType,
      "discount": data.discount,
      "expire_date": data.expiredDate,
    };

    await saveCoupon(request: request).then((value) {
      appStore.setLoading(false);
      toast(value.message.toString(), print: true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
      if (data.status.validate() == 1) {
        data.status = 0;
      } else {
        data.status = 1;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
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
    return Container(
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: appStore.isDarkMode ? cardDarkColor : cardColor,
      ),
      width: widget.width,
      child: Column(
        children: [
          Opacity(
            opacity: widget.data.deletedAt.validate().isEmpty ? 1 : 0.4,
            child: Container(
              padding: EdgeInsets.all(16),
              width: context.width(),
              decoration: BoxDecoration(border: Border.all(color: context.dividerColor), borderRadius: radius(), color: context.cardColor),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(ic_profile, height: 16, color: context.primaryColor),
                      16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.couponCode, style: secondaryTextStyle()),
                          4.height,
                          Text(widget.data.code.validate().toString(), style: boldTextStyle(size: 12)),
                        ],
                      ).expand(),
                    ],
                  ),
                  Divider(color: context.dividerColor, thickness: 1.0, height: 20),
                  Row(
                    children: [
                      Image.asset(ic_percent_line, height: 16, color: context.primaryColor),
                      16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.discount, style: secondaryTextStyle()),
                          4.height,
                          if (widget.data.discountType.validate().toLowerCase() == PERCENTAGE.toLowerCase()) Text('${widget.data.discount}%', style: boldTextStyle(size: 12)),
                          if (widget.data.discountType.validate().toLowerCase() == FIXED.toLowerCase())
                            Text("${isCurrencyPositionLeft ? appStore.currencySymbol : ''}${widget.data.discount}${isCurrencyPositionRight ? appStore.currencySymbol : ''}", style: boldTextStyle(size: 12)),
                        ],
                      ),
                    ],
                  ),
                  Divider(color: context.dividerColor, thickness: 1.0, height: 20),
                  Row(
                    children: [
                      Image.asset(ic_percent_line, height: 16, color: context.primaryColor),
                      16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.expDate, style: secondaryTextStyle()),
                          4.height,
                          Text(
                            formatDate(widget.data.expiredDate.validate().toString(), format: DATE_FORMAT_2),
                            style: boldTextStyle(size: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(color: context.dividerColor, thickness: 1.0, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(ic_status, height: 16, color: context.primaryColor),
                          16.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(locale.status, style: secondaryTextStyle()),
                              4.height,
                              Text(
                                widget.data.status == 1 ? ACTIVE.toUpperCase() : IN_ACTIVE.toUpperCase(),
                                style: boldTextStyle(size: 12, color: widget.data.status == 1 ? greenColor : Colors.redAccent),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: Switch.adaptive(
                          value: widget.data.status == 1,
                          activeColor: greenColor,
                          onChanged: (_) {
                            ifNotTester(context, () {
                              if (widget.data.status.validate() == 1) {
                                widget.data.status = 0;
                                changeStatus(widget.data, 0);
                              } else {
                                widget.data.status = 1;
                                changeStatus(widget.data, 1);
                              }
                            });
                            setState(() {});
                          },
                        ).withHeight(20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
