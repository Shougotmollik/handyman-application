import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/type_list_response.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/provider/add_provider_handyman_type_list_screen.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';

class ProviderHandymanTypeListScreen extends StatefulWidget {
  final String type;
  final TypeDataModel? data;

  const ProviderHandymanTypeListScreen({super.key, required this.type, this.data});

  @override
  _ProviderHandymanTypeListScreenState createState() => _ProviderHandymanTypeListScreenState();
}

class _ProviderHandymanTypeListScreenState extends State<ProviderHandymanTypeListScreen> {
  Future<List<TypeDataModel>>? future;
  List<TypeDataModel> typeList = [];

  int page = 1;

  bool isLastPage = false;

  bool isSwitched = false;

  Future<void> changeStatus(TypeDataModel typeDataModel, int status) async {
    appStore.setLoading(true);
    Map request = {
      CommonKeys.id: typeDataModel.id,
      UserKeys.status: status,
      "name": typeDataModel.name,
      "commission": typeDataModel.commission,
      "type": typeDataModel.type,
    };

    await saveProviderHandymanTypeList(request: request, type: widget.type).then((value) {
      appStore.setLoading(false);
      toast(value.message.toString(), print: true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
      if (typeDataModel.status.validate() == 1) {
        typeDataModel.status = 0;
      } else {
        typeDataModel.status = 1;
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
    future = getTypeList(
      typeList: typeList,
      type: widget.type,
      page: page,
      callback: (res) {
        isLastPage = res;
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
      appBarTitle: widget.type == USER_TYPE_PROVIDER ? locale.providerType : locale.handymanType,
      actions: [
        IconButton(
          icon: Icon(Icons.add, color: white),
          onPressed: () async {
            bool? res = await AddProviderHandymanTypeListScreen(type: widget.type).launch(context);

            if (res ?? false) {
              page = 1;
              init();
              setState(() {});
            }
          },
        ),
      ],
      child: SnapHelperWidget<List<TypeDataModel>>(
        future: future,
        loadingWidget: LoaderWidget(),
        onSuccess: (data) {
          return AnimatedListView(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16, 8, 16, 60),
            itemCount: data.length,
            itemBuilder: (_, index) {
              TypeDataModel typeData = data[index];

              return Opacity(
                opacity: typeData.deletedAt.validate().isEmpty ? 1 : 0.4,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      width: context.width(),
                      decoration: BoxDecoration(border: Border.all(color: context.dividerColor), borderRadius: radius(), color: context.cardColor),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(ic_profile, height: 18, color: context.primaryColor),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.type == USER_TYPE_PROVIDER ? locale.providerType : locale.handymanType, style: secondaryTextStyle(size: CARD_SECONDARY_TEXT_STYLE_SIZE)),
                                  4.height,
                                  Text(
                                    typeData.name.validate(),
                                    style: boldTextStyle(
                                      size: CARD_BOLD_TEXT_STYLE_SIZE,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(color: context.dividerColor, thickness: 1.0, height: CARD_DIVIDER_HEIGHT),
                          Row(
                            children: [
                              Image.asset(ic_percent_line, height: 18, color: context.primaryColor),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(locale.commission, style: secondaryTextStyle(size: CARD_SECONDARY_TEXT_STYLE_SIZE)),
                                  4.height,
                                  if (typeData.type.validate().toLowerCase() == PERCENT.toLowerCase())
                                    Text(
                                      '${typeData.commission}%',
                                      style: boldTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE),
                                    ),
                                  if (typeData.type.validate().toLowerCase() == FIXED.toLowerCase())
                                    Text("${isCurrencyPositionLeft ? appStore.currencySymbol : ''}${typeData.commission}${isCurrencyPositionRight ? appStore.currencySymbol : ''}",
                                        style: boldTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE)),
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
                                  16.width,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(locale.status, style: secondaryTextStyle(size: CARD_SECONDARY_TEXT_STYLE_SIZE)),
                                      4.height,
                                      Text(
                                        typeData.status == 1 ? ACTIVE.toUpperCase() : IN_ACTIVE.toUpperCase(),
                                        style: boldTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE, color: typeData.status == 1 ? greenColor : Colors.redAccent),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Transform.scale(
                                scale: 0.8,
                                child: Switch.adaptive(
                                  value: typeData.status == 1,
                                  activeColor: greenColor,
                                  onChanged: (_) {
                                    ifNotTester(context, () {
                                      if (typeData.status.validate() == 1) {
                                        typeData.status = 0;
                                        changeStatus(typeData, 0);
                                      } else {
                                        typeData.status = 1;
                                        changeStatus(typeData, 1);
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
                        bool? res = await AddProviderHandymanTypeListScreen(typeData: typeData, type: widget.type).launch(context);

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
                  ],
                ),
              );
            },
            emptyWidget: NoDataWidget(
              title: locale.noTypeListFound,
              imageWidget: EmptyStateWidget(),
            ),
            onSwipeRefresh: () async {
              page = 1;

              init();
              setState(() {});

              return await 2.seconds.delay;
            },
            onNextPage: () {
              if (!isLastPage) {
                page = page++;
                init();
                setState(() {});
              }
            },
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
