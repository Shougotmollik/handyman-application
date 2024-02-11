import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/components/price_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/payout_history_response.dart';
import 'package:handyman_admin_flutter/model/user_data.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_widgets.dart';
import '../../components/empty_error_state_widget.dart';
import '../../utils/colors.dart';

class ProviderPayoutListScreen extends StatefulWidget {
  final UserData user;

  ProviderPayoutListScreen({required this.user});

  @override
  _ProviderPayoutListScreenState createState() => _ProviderPayoutListScreenState();
}

class _ProviderPayoutListScreenState extends State<ProviderPayoutListScreen> {
  Future<List<PayoutData>>? future;
  List<PayoutData> payoutList = [];

  int currentPage = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getPayoutHistoryList(
      currentPage,
      id: widget.user.id!,
      payoutList: payoutList,
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
      appBarTitle: locale.providerPayoutList,
      child: SnapHelperWidget<List<PayoutData>>(
        future: future,
        loadingWidget: LoaderWidget(),
        onSuccess: (payoutList) {
          return AnimatedListView(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16, 8, 16, 60),
            itemCount: payoutList.length,
            slideConfiguration: SlideConfiguration(delay: 50.milliseconds, verticalOffset: 400),
            itemBuilder: (_, index) {
              PayoutData data = payoutList[index];

              return Container(
                margin: EdgeInsets.only(top: 8, bottom: 8),
                width: context.width(),
                decoration: cardDecoration(context),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(locale.paymentMethod, style: secondaryTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE)),
                        Text(
                          data.paymentMethod.validate().capitalizeFirstLetter(),
                          style: boldTextStyle(color: primaryColor, size: CARD_BOLD_TEXT_STYLE_SIZE),
                        ),
                      ],
                    ),
                    if (data.description.validate().isNotEmpty)
                      Column(
                        children: [
                          16.height,
                          Text(data.description.validate(), style: secondaryTextStyle(size: CARD_SECONDARY_TEXT_STYLE_SIZE)),
                        ],
                      ),
                    8.height,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: context.cardColor,
                        borderRadius: radius(),
                      ),
                      width: context.width(),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(locale.amount, style: secondaryTextStyle(size: CARD_SECONDARY_TEXT_STYLE_SIZE)),
                              16.width,
                              PriceWidget(price: data.amount.validate(), color: primaryColor, isBoldText: true).flexible(),
                            ],
                          ),
                          8.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(locale.date, style: secondaryTextStyle(size: CARD_SECONDARY_TEXT_STYLE_SIZE)),
                              Text(
                                formatDate(data.createdAt.validate().toString(), format: DATE_FORMAT_2),
                                style: boldTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
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
            emptyWidget: NoDataWidget(
              title: locale.noPayoutFound,
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
