import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/components/price_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/payment_list_response.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';
import '../../utils/colors.dart';

class PaymentListScreen extends StatefulWidget {
  @override
  PaymentListScreenState createState() => PaymentListScreenState();
}

class PaymentListScreenState extends State<PaymentListScreen> {
  Future<List<PaymentData>>? future;

  List<PaymentData> paymentDataList = [];

  int currentPage = 1;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = getPaymentList(
      page: currentPage,
      payments: paymentDataList,
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: locale.payments,
      child: SnapHelperWidget<List<PaymentData>>(
        future: future,
        loadingWidget: LoaderWidget(),
        onSuccess: (payments) {
          return AnimatedListView(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(8, 8, 8, 60),
            itemCount: paymentDataList.length,
            slideConfiguration: SlideConfiguration(delay: 50.milliseconds, verticalOffset: 400),
            onNextPage: () {
              if (!isLastPage) {
                currentPage++;

                appStore.setLoading(true);

                init();
                setState(() {});
              }
            },
            onSwipeRefresh: () async {
              currentPage = 1;

              init();
              setState(() {});
              return await 2.seconds.delay;
            },
            itemBuilder: (_, index) {
              PaymentData data = paymentDataList[index];

              return Container(
                margin: EdgeInsets.only(top: 8, bottom: 8),
                width: context.width(),
                decoration: cardDecoration(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: primaryColor.withOpacity(0.2),
                        borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
                      ),
                      width: context.width(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data.customerName.validate(), style: boldTextStyle(size: 12)).flexible(),
                          Text(
                            '#' + data.bookingId.validate().toString(),
                            style: boldTextStyle(color: primaryColor, size: 12),
                          )
                        ],
                      ),
                    ),
                    4.height,
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(locale.paymentId, style: secondaryTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE)),
                            Text("#" + data.id.validate().toString(), style: boldTextStyle(size: 12)),
                          ],
                        ).paddingSymmetric(vertical: 4),
                        Divider(thickness: 0.9, color: context.dividerColor),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(locale.paymentStatus, style: secondaryTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE)),
                            Text(
                              getPaymentStatusText(data.paymentStatus.validate(value: locale.pending), data.paymentMethod),
                              style: boldTextStyle(size: 12),
                            ),
                          ],
                        ).paddingSymmetric(vertical: 4),
                        Divider(thickness: 0.9, color: context.dividerColor),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(locale.paymentMethod, style: secondaryTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE)),
                            Text(
                              (data.paymentMethod.validate().isNotEmpty ? data.paymentMethod.validate() : locale.notAvailable).capitalizeFirstLetter(),
                              style: boldTextStyle(size: 12),
                            ),
                          ],
                        ).paddingSymmetric(vertical: 4),
                        Divider(thickness: 0.9, color: context.dividerColor),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(locale.amount, style: secondaryTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE)),
                            PriceWidget(
                              price: data.totalAmount.validate(),
                              color: primaryColor,
                              size: 12,
                              isBoldText: true,
                            ),
                          ],
                        ).paddingSymmetric(vertical: 4),
                      ],
                    ).paddingSymmetric(horizontal: 16, vertical: 10),
                  ],
                ),
              );
            },
            emptyWidget: NoDataWidget(
              title: locale.noPaymentFound,
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
              currentPage = 1;
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
