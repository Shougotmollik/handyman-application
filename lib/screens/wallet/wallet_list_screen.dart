import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/model/walletListResponse.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/wallet/add_wallet_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_widgets.dart';
import '../../components/base_scaffold_widget.dart';
import '../../components/empty_error_state_widget.dart';
import '../../components/price_widget.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/common.dart';
import '../../utils/constant.dart';
import '../../utils/model_keys.dart';

class WalletListScreen extends StatefulWidget {
  @override
  State<WalletListScreen> createState() => _WalletListScreenState();
}

class _WalletListScreenState extends State<WalletListScreen> {
  Future<List<WalletData>>? future;

  List<WalletData> walletDataList = [];

  int currentPage = 1;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = getWalletList(
      page: currentPage,
      walletList: walletDataList,
      lastPageCallback: (res) {
        appStore.setLoading(false);
        isLastPage = res;
        setState(() {});
      },
    );
  }

  Future<void> changeStatus(WalletData walletData, int status) async {
    appStore.setLoading(true);
    Map request = {
      CommonKeys.id: walletData.id,
      CommonKeys.userId: walletData.userId,
      UserKeys.status: status,
      //"name": walletData.name,
    };

    await saveWallet(request: request).then((value) {
      appStore.setLoading(false);
      toast(value.message.toString(), print: true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
      if (walletData.status.validate() == 1) {
        walletData.status = 0;
      } else {
        walletData.status = 1;
      }
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: locale.walletList,
      actions: [
        IconButton(
          icon: Icon(Icons.add, color: white),
          onPressed: () async {
            bool? res = await AddWalletScreen().launch(context);

            if (res ?? false) {
              currentPage = 1;
              init();
              setState(() {});
            }
          },
        ),
      ],
      child: SnapHelperWidget<List<WalletData>>(
        future: future,
        loadingWidget: LoaderWidget(),
        onSuccess: (payments) {
          return AnimatedListView(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(8, 8, 8, 60),
            itemCount: walletDataList.length,
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
              WalletData data = walletDataList[index];

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
                          Text(data.title.validate(), style: boldTextStyle(size: 12)),
                          Text(locale.add, style: boldTextStyle(size: 12, color: context.primaryColor)).paddingAll(8).onTap(
                                () async {
                              bool? res = await AddWalletScreen(data: data).launch(context);
                              if (res ?? false) {
                                currentPage = 1;
                                init();
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    4.height,
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(locale.name, style: secondaryTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE)),
                            Text(data.name.validate().toString(), style: boldTextStyle(size: 12)),
                          ],
                        ).paddingSymmetric(vertical: 4),
                        Divider(thickness: 0.9, color: context.dividerColor),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(locale.amount, style: secondaryTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE)),
                            PriceWidget(
                              price: data.amount.validate(),
                              hourlyTextColor: Colors.white,
                              size: 14,
                            ),
                          ],
                        ).paddingSymmetric(vertical: 4),
                        Divider(thickness: 0.9, color: context.dividerColor),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(locale.status, style: secondaryTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE)),
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
                              ).withHeight(20),
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
              title: locale.noWalletListFound,
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
