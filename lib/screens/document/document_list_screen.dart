import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/components/empty_error_state_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/document_list_response.dart';
import 'package:handyman_admin_flutter/screens/document/add_document_screen.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../networks/rest_apis.dart';

class DocumentListScreen extends StatefulWidget {
  @override
  _DocumentListScreenState createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  Future<List<Documents>>? future;
  List<Documents> documentList = [];

  bool isLastPage = false;

  int page = 1;

  Future<void> changeStatus(Documents data, int status) async {
    appStore.setLoading(true);
    Map request = {
      CommonKeys.id: data.id,
      UserKeys.status: status,
      "name": data.name,
      "is_required": data.isRequired,
    };

    await saveDoc(request: request).then((value) {
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

  Future<void> init() async {
    future = getDocuments(
      page: page,
      documents: documentList,
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
      appBarTitle: locale.documents,
      actions: [
        IconButton(
          icon: Icon(Icons.add, color: white),
          onPressed: () async {
            bool? res = await AddDocumentScreen().launch(context);

            if (res ?? false) {
              page = 1;
              init();
              setState(() {});
            }
          },
        ),
      ],
      child: SnapHelperWidget<List<Documents>>(
        future: future,
        loadingWidget: LoaderWidget(),
        onSuccess: (data) {
          return AnimatedListView(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16, 8, 16, 60),
            itemCount: documentList.length,
            slideConfiguration: SlideConfiguration(delay: 50.milliseconds, verticalOffset: 400),
            itemBuilder: (_, index) {
              Documents data = documentList[index];

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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(ic_document, height: 18, color: context.primaryColor),
                              10.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(locale.documentName, style: secondaryTextStyle(size: CARD_SECONDARY_TEXT_STYLE_SIZE)),
                                  4.height,
                                  Text(data.name.validate().toString(), style: boldTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE)),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              if (data.isRequired == 1) {
                                toast(locale.documentRequired);
                              } else {
                                toast(locale.documentNotRequired);
                              }
                            },
                            icon: Image.asset(ic_required, height: 14, color: data.isRequired == 1 ? Colors.red : Colors.grey.shade400),
                          ).withTooltip(msg: data.isRequired == 1 ? locale.documentRequired : locale.documentNotRequired)
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
                                  Text(data.status == 1 ? ACTIVE.toUpperCase() : IN_ACTIVE.toUpperCase(), style: boldTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE, color: data.status == 1 ? greenColor : Colors.redAccent)),
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
                            ).withHeight(20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).onTap(
                  () async {
                    bool? res = await AddDocumentScreen(data: data).launch(context);
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
            /*onNextPage: () {
              if (!isLastPage) {
                page++;

                appStore.setLoading(true);

                init();
                setState(() {});
              }
            },*/
            onSwipeRefresh: () async {
              page = 1;

              init();
              setState(() {});
              return await 2.seconds.delay;
            },
            emptyWidget: NoDataWidget(
              title: locale.noDocumentListFound,
              subTitle: locale.noDocumentListSubTitle,
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
