import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/components/cached_image_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/user_data.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/user/user_widget.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';
import '../../utils/colors.dart';

class UserListScreen extends StatefulWidget {
  final String? type;
  final String? status;
  final String? title;

  final bool pickUser;

  UserListScreen({required this.type, this.status, this.title, this.pickUser = false});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  ScrollController scrollController = ScrollController();

  TextEditingController searchCont = TextEditingController();

  Future<List<UserData>>? future;

  List<UserData> list = [];
  bool afterInit = false;

  int totalPage = 0;
  int currentPage = 1;
  int totalItems = 0;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = getUser(
      page: currentPage,
      keyword: searchCont.text,
      userType: widget.type.validate(),
      perPage: PER_PAGE_ITEM,
      userStatus: widget.status,
      callback: (res) {
        appStore.setLoading(false);
        isLastPage = res;
        setState(() {});
      },
      userdata: list,
    );
  }

  /*Future<void> getUserList() async {
    appStore.setLoading(true);
    await getUser(
      page: currentPage,
      keyword: searchCont.text,
      userType: widget.type.validate(),
      perPage: PER_PAGE_ITEM,
      userStatus: widget.status,
    ).then((value) {
      appStore.setLoading(false);
      totalItems = value.pagination!.totalItems;
      if (!mounted) return;

      if (currentPage == 1) {
        list.clear();
      }
      if (totalItems != 0) {
        list.addAll(value.data!);

        totalPage = value.pagination!.totalPages!;
        currentPage = value.pagination!.currentPage!;
      }
      setState(() {});
    }).catchError((e) {
      afterInit = true;
      setState(() {});
      if (!mounted) return;
      toast(e.toString(), print: true);
      appStore.setLoading(false);
    });
  }*/

  String getAppBarTitle() {
    if (widget.title.validate().isNotEmpty) {
      return widget.title!;
    } else {
      if (widget.type == USER_TYPE_USER) {
        return locale.users;
      } else if (widget.type == USER_TYPE_PROVIDER) {
        return locale.providerList;
      } else if (widget.type == USER_TYPE_HANDYMAN) {
        return locale.handymanList;
      }
      return '';
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: getAppBarTitle(),
      scaffoldBackgroundColor: appStore.isDarkMode ? blackColor : context.cardColor,
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
                    },
                  )
                : null,
            textFieldType: TextFieldType.OTHER,
            controller: searchCont,
            onChanged: (s) async {
              if (s.isEmpty) {
                hideKeyboard(context);
                currentPage = 1;

                init();
                setState(() {});
                return await 2.seconds.delay;
              }
            },
            onFieldSubmitted: (s) async {
              currentPage = 1;

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
              fillColor: appStore.isDarkMode ? cardDarkColor : Colors.white,
            ),
          ).paddingOnly(left: 16, right: 16, top: 24, bottom: 8),
          SnapHelperWidget<List<UserData>>(
            future: future,
            loadingWidget: LoaderWidget(),
            onSuccess: (res) {
              if (res.isEmpty && !appStore.isLoading) {
                return NoDataWidget(
                  title: locale.noDataFound,
                  imageWidget: EmptyStateWidget(),
                );
              }

              return AnimatedScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: AnimatedWrap(
                      spacing: 16,
                      runSpacing: 16,
                      itemCount: list.length,
                      scaleConfiguration: ScaleConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
                      listAnimationType: ListAnimationType.Scale,
                      itemBuilder: (context, index) {
                        UserData data = list[index];

                        if (widget.pickUser) {
                          return SettingItemWidget(
                            title: res[index].displayName.validate(),
                            titleTextStyle: primaryTextStyle(),
                            padding: EdgeInsets.symmetric(vertical: 6),
                            leading: CachedImageWidget(url: res[index].profileImage.validate(), height: 30, width: 30, circle: true),
                            onTap: () {
                              finish(context, res[index]);
                            },
                          );
                        } else {
                          return Opacity(
                            opacity: data.deletedAt.validate().isEmpty ? 1 : 0.4,
                            child: UserWidget(
                              data: list[index],
                              width: context.width() * 0.5 - 26,
                              onUpdate: () async {
                                currentPage = 1;

                                appStore.setLoading(true);
                                init();
                              },
                            ),
                          );
                        }
                      },
                    ).paddingAll(16),
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
