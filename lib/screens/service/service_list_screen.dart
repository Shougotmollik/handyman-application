import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/service_model.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/service/components/service_widget.dart';
import 'package:handyman_admin_flutter/screens/service/service_detail_screen.dart';
import 'package:handyman_admin_flutter/utils/colors.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';

class ServiceListScreen extends StatefulWidget {
  final int? categoryId;
  final String categoryName;
  final List<ServiceData>? serviceIds;

  final bool pickService;
  final bool allowMultipleSelection;

  ServiceListScreen({this.categoryId, this.serviceIds, this.categoryName = '', this.pickService = false, this.allowMultipleSelection = false});

  @override
  _ServiceListScreenState createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  Future<List<ServiceData>>? future;

  TextEditingController searchCont = TextEditingController();

  List<ServiceData> serviceList = [];

  int currentPage = 1;
  int? categoryId = 0;

  bool changeList = false;

  bool isEnabled = false;
  bool isLastPage = false;
  bool isApiCalled = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getSearchList(
      currentPage,
      search: searchCont.text,
      serviceList: serviceList,
      serviceIds: widget.serviceIds.validate(),
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: widget.categoryName.isEmpty ? locale.allService : widget.categoryName.validate(),
      actions: [
        IconButton(
          onPressed: () {
            changeList = !changeList;
            setState(() {});
          },
          icon: changeList ? Image.asset(list, height: 20, width: 20) : Image.asset(grid, height: 20, width: 20),
        ),
      ],
      floatingActionButton: widget.allowMultipleSelection
          ? FloatingActionButton(
              onPressed: () {
                List<ServiceData>? ids = [];

                serviceList.forEach((element) {
                  if (element.isSelected) {
                    ids.add(element);
                  }
                });

                finish(context, ids);
              },
              child: Icon(Icons.save, size: 24, color: Colors.white),
            )
          : null,
      child: Column(
        children: [
          AppTextField(
            suffix: searchCont.text.isNotEmpty
                ? CloseButton(
                    color: primaryColor,
                    onPressed: () {
                      searchCont.clear();
                      hideKeyboard(context);

                      currentPage = 1;
                      init();
                    })
                : null,
            textFieldType: TextFieldType.OTHER,
            controller: searchCont,
            onChanged: (s) async {
              if (s.isEmpty) {
                hideKeyboard(context);
                currentPage = 1;

                serviceList.clear();
                init();
                setState(() {});
                return await 2.seconds.delay;
              }
            },
            onFieldSubmitted: (s) async {
              currentPage = 1;

              serviceList.clear();
              init();
              setState(() {});
              return await 2.seconds.delay;
            },
            decoration: InputDecoration(
              hintText: locale.searchHere,
              prefixIcon: Icon(Icons.search, color: context.iconColor, size: 20),
              hintStyle: secondaryTextStyle(),
              border: OutlineInputBorder(
                borderRadius: radius(8),
                borderSide: BorderSide(width: 0, style: BorderStyle.none),
              ),
              filled: true,
              contentPadding: EdgeInsets.all(16),
              fillColor: appStore.isDarkMode ? cardDarkColor : cardColor,
            ),
          ).paddingOnly(left: 16, right: 16, top: 16, bottom: 8),
          SnapHelperWidget<List<ServiceData>>(
            future: future,
            loadingWidget: LoaderWidget(),
            onSuccess: (serviceList) {
              if (serviceList.isEmpty && !appStore.isLoading) {
                return NoDataWidget(
                  title: locale.noServiceFound,
                  subTitle: locale.noServiceSubTitle,
                  imageWidget: EmptyStateWidget(),
                );
              }
              return AnimatedScrollView(
                padding: EdgeInsets.only(bottom: 60),
                physics: AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                onSwipeRefresh: () async {
                  currentPage = 1;

                  init();
                  setState(() {});

                  return await 2.seconds.delay;
                },
                onNextPage: () {
                  if (!isLastPage) {
                    currentPage++;
                    appStore.setLoading(true);

                    init();
                    setState(() {});
                  }
                },
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: AnimatedWrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      scaleConfiguration: ScaleConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
                      listAnimationType: ListAnimationType.Scale,
                      alignment: WrapAlignment.start,
                      itemCount: serviceList.length,
                      itemBuilder: (context, index) {
                        if (widget.allowMultipleSelection) {
                          return SettingItemWidget(
                            title: serviceList[index].name.validate(),
                            onTap: () {
                              serviceList[index].isSelected = !serviceList[index].isSelected;

                              setState(() {});
                            },
                            trailing: serviceList[index].isSelected ? Icon(Icons.check) : null,
                          );
                        } else {
                          return ServiceComponent(
                            data: serviceList[index],
                            width: changeList ? context.width() : context.width() * 0.5 - 24,
                          ).onTap(
                            () async {
                              hideKeyboard(context);
                              if (widget.pickService) {
                                if (serviceList[index].deletedAt.validate().isEmpty) {
                                  finish(context, [serviceList[index]]);
                                } else {
                                  toast(locale.thisServiceIsNotAvailable);
                                }
                              } else {
                                bool? res = await ServiceDetailScreen(serviceId: serviceList[index].id.validate()).launch(context);

                                if (res ?? false) {
                                  currentPage = 1;
                                  appStore.setLoading(false);

                                  init();
                                  setState(() {});
                                }
                              }
                            },
                            borderRadius: radius(),
                          );
                        }
                      },
                    ).paddingSymmetric(horizontal: 16, vertical: 24),
                  ),
                ],
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
          ).expand(),
        ],
      ),
    );
  }
}
