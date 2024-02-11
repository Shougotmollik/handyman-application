import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/components/cached_image_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/provider_document_response.dart';
import 'package:handyman_admin_flutter/model/user_data.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/provider/add_provider_document_screen.dart';
import 'package:handyman_admin_flutter/screens/gallery/zoom_image_screen.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';

class ProviderDocumentList extends StatefulWidget {
  final UserData user;

  ProviderDocumentList({required this.user});

  @override
  State<ProviderDocumentList> createState() => _ProviderDocumentListState();
}

class _ProviderDocumentListState extends State<ProviderDocumentList> {
  Future<List<ProviderDocumentData>>? future;
  List<ProviderDocumentData> providerDocumentsList = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLastPage = false;

  int page = 1;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = getProviderDocuments(
      providerId: widget.user.id!,
      page: page,
      providerDocuments: providerDocumentsList,
      callback: (res) {
        appStore.setLoading(false);
        isLastPage = res;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: locale.providerDocumentList,
      actions: [
        IconButton(
          icon: Icon(Icons.add, color: white),
          onPressed: () async {
            bool? res = await AddProviderDocumentScreen(providerId: widget.user.id.validate()).launch(context);

            if (res ?? false) {
              page = 1;
              init();
              setState(() {});
            }
          },
        ),
      ],
      child: SnapHelperWidget<List<ProviderDocumentData>>(
        future: future,
        loadingWidget: LoaderWidget(),
        onSuccess: (providerDocuments) {
          return AnimatedListView(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16, 8, 16, 60),
            itemCount: providerDocumentsList.length,
            slideConfiguration: SlideConfiguration(delay: 50.milliseconds, verticalOffset: 400),
            itemBuilder: (_, index) {
              ProviderDocumentData data = providerDocumentsList[index];

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
                                  Text(data.documentName.validate().toString(), style: boldTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE)),
                                ],
                              ),
                            ],
                          ),
                          Image.asset(ic_verified, height: 18, color: data.isVerified == 1 ? greenColor : Colors.grey.shade400),
                        ],
                      ),
                      Divider(color: context.dividerColor, thickness: 1.0, height: CARD_DIVIDER_HEIGHT),
                      Row(
                        children: [
                          Image.asset(ic_image_document, height: 16, width: 16, color: context.primaryColor),
                          10.width,
                          if (data.providerDocument.validate().isImage)
                            CachedImageWidget(
                              url: data.providerDocument.validate(),
                              height: 40,
                            ).onTap(() {
                              ZoomImageScreen(galleryImages: [data.providerDocument!], index: 0).launch(context);
                            }),
                        ],
                      ),
                    ],
                  ),
                ).onTap(
                  () async {
                    bool? res = await AddProviderDocumentScreen(providerId: widget.user.id.validate(), data: data).launch(context);
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
              title: locale.noDocumentFound,
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
