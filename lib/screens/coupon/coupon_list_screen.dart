import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/coupon_model.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/coupon/add_coupon_screen.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_widgets.dart';
import '../../components/empty_error_state_widget.dart';

class CouponListScreen extends StatefulWidget {
  @override
  _CouponListScreenState createState() => _CouponListScreenState();
}

class _CouponListScreenState extends State<CouponListScreen> {
  Future<List<CouponData>>? future;
  List<CouponData> couponsList = [];

  bool isLastPage = false;

  int page = 1;

  Future<void> changeStatus(CouponData data, int status) async {
    appStore.setLoading(true);

    getCouponService(id: data.id!).then((value) async {
      List<int> serviceIds = value.map((e) => e.id!).toList();

      Map request = {
        CommonKeys.id: data.id,
        UserKeys.status: status,
        "code": data.code,
        "discount_type": data.discountType,
        "discount": data.discount,
        "expire_date": data.expiredDate,
        "service_id": serviceIds,
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
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(true);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getCoupons(
      page: page,
      coupons: couponsList,
      callback: (res) {
        appStore.setLoading(false);
        isLastPage = res;
        setState(() {});
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: locale.coupons,
      actions: [
        IconButton(
          icon: Icon(Icons.add, color: white),
          onPressed: () async {
            bool? res = await AddCouponScreen().launch(context);

            if (res ?? false) {
              page = 1;
              init();
              setState(() {});
            }
          },
        ),
      ],
      child: SnapHelperWidget<List<CouponData>>(
        future: future,
        loadingWidget: LoaderWidget(),
        onSuccess: (couponsList) {
          return AnimatedListView(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16, 8, 16, 60),
            itemCount: couponsList.length,
            slideConfiguration: SlideConfiguration(delay: 50.milliseconds, verticalOffset: 400),
            itemBuilder: (_, index) {
              CouponData data = couponsList[index];

              return Opacity(
                opacity: data.deletedAt.validate().isEmpty ? 1 : 0.4,
                child: Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  width: context.width(),
                  decoration: BoxDecoration(border: Border.all(color: context.dividerColor), borderRadius: radius(), color: context.cardColor),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(ic_profile, height: 18, color: context.primaryColor),
                          10.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(locale.couponCode, style: secondaryTextStyle(size: CARD_SECONDARY_TEXT_STYLE_SIZE)),
                              4.height,
                              Text(data.code.validate().toString(),
                                  style: boldTextStyle(
                                    size: CARD_BOLD_TEXT_STYLE_SIZE,
                                  )),
                            ],
                          ),
                        ],
                      ),
                      Divider(color: context.dividerColor, thickness: 1.0, height: CARD_DIVIDER_HEIGHT),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(ic_percent_line, height: 18, color: context.primaryColor),
                              10.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(locale.discount, style: secondaryTextStyle(size: CARD_SECONDARY_TEXT_STYLE_SIZE)),
                                  4.height,
                                  if (data.discountType.validate().toLowerCase() == PERCENTAGE.toLowerCase()) Text('${data.discount}%', style: boldTextStyle(size: 14)),
                                  if (data.discountType.validate().toLowerCase() == FIXED.toLowerCase())
                                    Text("${isCurrencyPositionLeft ? appStore.currencySymbol : ''}${data.discount}${isCurrencyPositionRight ? appStore.currencySymbol : ''}",
                                        style: boldTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis),
                                ],
                              ).expand(),
                            ],
                          ).expand(),
                          Row(
                            children: [
                              Image.asset(ic_calendar, height: 18, color: context.primaryColor),
                              10.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(locale.expDate, style: secondaryTextStyle(size: CARD_SECONDARY_TEXT_STYLE_SIZE)),
                                  4.height,
                                  Text(formatDate(data.expiredDate.validate().toString(), format: DATE_FORMAT_2), style: boldTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE)),
                                ],
                              ).expand(),
                            ],
                          ).expand(),
                        ],
                      ),
                      Divider(color: context.dividerColor, thickness: 1.0, height: CARD_DIVIDER_HEIGHT),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(ic_status, height: 16, color: context.primaryColor),
                              10.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(locale.status, style: secondaryTextStyle(size: CARD_SECONDARY_TEXT_STYLE_SIZE)),
                                  4.height,
                                  Text(
                                    data.status == 1 ? ACTIVE.toUpperCase() : IN_ACTIVE.toUpperCase(),
                                    style: boldTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE, color: data.status == 1 ? greenColor : Colors.redAccent),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: Switch.adaptive(
                              value: data.status == 1,
                              activeColor: greenColor,
                              onChanged: (_) {
                                ifNotTester(context, () {
                                  if (data.status.validate() == 1) {
                                    data.status = 0;
                                    changeStatus(data, 0);
                                  } else {
                                    data.status = 1;
                                    changeStatus(data, 1);
                                  }
                                });
                                setState(() {});
                              },
                            ).withHeight(24),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).onTap(
                  () async {
                    bool? res = await AddCouponScreen(couponData: data).launch(context);
                    if (res ?? false) {
                      page = 1;
                      init();
                      setState(() {});
                    }
                  },
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
              );
            },
            onNextPage: () {
              if (!isLastPage) {
                page++;

                appStore.setLoading(true);

                init();
                setState(() {});
              }
            },
            onSwipeRefresh: () async {
              page = 1;

              init();
              setState(() {});
              return await 2.seconds.delay;
            },
            emptyWidget: NoDataWidget(
              title: locale.noCouponFound,
              imageWidget: EmptyStateWidget(),
            ),
          );
        },
        errorBuilder: (error) {
          return NoDataWidget(
            title: error,
            imageWidget: ErrorStateWidget(),
            retryText: locale.reload,
            onRetry: () {
              page = 1;
              appStore.setLoading(true);

              init();
              setState(() {});
            },
          );
        },
      ),
    );
  }
}
