import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_admin_flutter/screens/tax/add_tax_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_widgets.dart';
import '../../components/base_scaffold_widget.dart';
import '../../components/empty_error_state_widget.dart';
import '../../main.dart';
import '../../model/tax_list_response.dart';
import '../../networks/rest_apis.dart';
import '../../utils/common.dart';
import '../../utils/constant.dart';
import '../../utils/images.dart';
import '../../utils/model_keys.dart';

class TaxesScreen extends StatefulWidget {
  @override
  _TaxesScreenState createState() => _TaxesScreenState();
}

class _TaxesScreenState extends State<TaxesScreen> {
  Future<List<TaxData>>? future;
  List<TaxData> taxList = [];

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getTaxList(
      page: page,
      list: taxList,
      lastPageCallback: (b) {
        isLastPage = b;
      },
    );
  }
  Future<void> changeStatus(TaxData data, int status) async {
    appStore.setLoading(true);

    getCouponService(id: data.id!).then((value) async {

      Map request = {
        CommonKeys.id: data.id,
        UserKeys.status: status,
      };

      await saveTax(request: request).then((value) {
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
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: locale.taxes,
      actions: [
        IconButton(
          icon: Icon(Icons.add, color: white),
          onPressed: () async {
            bool? res = await AddTaxScreen().launch(context);

            if (res ?? false) {
              page = 1;
              init();
              setState(() {});
            }
          },
        ),
      ],
      child: Stack(
        children: [
          SnapHelperWidget<List<TaxData>>(
            future: future,
            onSuccess: (list) {
              return AnimatedListView(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: list.length,
                padding: EdgeInsets.all(8),
                disposeScrollController: false,
                shrinkWrap: true,
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                itemBuilder: (context, index) {
                  TaxData data = list[index];

                  return Container(
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
                                Text(locale.taxName, style: secondaryTextStyle(size: CARD_SECONDARY_TEXT_STYLE_SIZE)),
                                Text('${data.title.validate()}', style: boldTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE)),
                              ],
                            ),
                          ],
                        ),
                        Divider(color: context.dividerColor, thickness: 1.0, height: CARD_DIVIDER_HEIGHT),
                        Row(
                          children: [
                            Image.asset(ic_percent_line, height: 18, color: context.primaryColor),
                            10.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(locale.value, style: secondaryTextStyle(size: CARD_SECONDARY_TEXT_STYLE_SIZE)),
                                Text(
                                  isTaxTypePercent(data.type) ? '${data.value.toString()}%' : '${getStringAsync(CURRENCY_COUNTRY_SYMBOL)}${data.value.toString()}',
                                  style: boldTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE),
                                ),
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
                      bool? res = await AddTaxScreen(data: data).launch(context);
                      if (res ?? false) {
                        page = 1;
                        init();
                        setState(() {});
                      }
                    },
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  );
                  return Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(8),
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(),
                      backgroundColor: context.cardColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(locale.taxName, style: secondaryTextStyle(size: 14)),
                            Text('${data.title.validate()}', style: boldTextStyle()),
                          ],
                        ),
                        8.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(locale.myTax, style: secondaryTextStyle(size: 14)),
                            Row(
                              children: [
                                Text(
                                  isTaxTypePercent(data.type) ? ' ${data.value.toString()} %' : ' ${getStringAsync(CURRENCY_COUNTRY_SYMBOL)}${data.value.toString()}',
                                  style: boldTextStyle(),
                                ),
                                Text(' (${data.type.capitalizeFirstLetter()})', style: boldTextStyle()),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ).onTap(
                    () async {
                      bool? res = await AddTaxScreen(data: data).launch(context);
                      if (res ?? false) {
                        page = 1;
                        init();
                        setState(() {});
                      }
                    },
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  );
                },
                emptyWidget: NoDataWidget(
                  title: locale.noTaxesFound,
                  imageWidget: EmptyStateWidget(),
                ),
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
              );
            },
            loadingWidget: LoaderWidget(),
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
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
