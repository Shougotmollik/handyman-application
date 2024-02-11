import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/category/category_widget.dart';
import 'package:handyman_admin_flutter/screens/subCategory/add_sub_category_screen.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';
import '../../model/category_response.dart';

class SubCategoryListScreen extends StatefulWidget {
  final CategoryData subCategoryData;
  final bool isMainCategoryDeleted;

  SubCategoryListScreen(this.subCategoryData, {this.isMainCategoryDeleted = false});

  @override
  _SubCategoryListScreenState createState() => _SubCategoryListScreenState();
}

class _SubCategoryListScreenState extends State<SubCategoryListScreen> {
  Future<List<CategoryData>>? future;

  ScrollController scrollController = ScrollController();
  UniqueKey key = UniqueKey();
  List<CategoryData> subCategoryList = [];

  int currentPage = 1;

  int page = 1;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(context.primaryColor);
    });
    init();
  }

  void init([bool showLoader = true]) async {
    future = getSubCategoryList(
      page: currentPage,
      catId: widget.subCategoryData.id,
      perPage: PER_PAGE_ITEM,
      subCategoryList: subCategoryList,
      callback: (res) {
        appStore.setLoading(false);
        isLastPage = res;
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: '${widget.subCategoryData.name} ${locale.subCategory}',
      actions: [
        IconButton(
          icon: Icon(Icons.add, color: white),
          onPressed: () async {
            bool? res = await AddSubCategoryScreen(widget.subCategoryData).launch(context);

            if (res ?? false) {
              page = 1;
              init();
              setState(() {});
            }
          },
        ),
      ],
      child: SnapHelperWidget<List<CategoryData>>(
        future: future,
        loadingWidget: LoaderWidget(),
        onSuccess: (subCategoryList) {
          if (subCategoryList.isEmpty) {
            return NoDataWidget(
              title: locale.noSubCategoryFound,
              imageWidget: EmptyStateWidget(),
            ).center();
          }

          return AnimatedScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            padding: EdgeInsets.all(16),
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

              return Future.value(false);
            },
            children: [
              AnimatedWrap(
                key: key,
                runSpacing: 16,
                spacing: 16,
                itemCount: subCategoryList.length,
                listAnimationType: ListAnimationType.Scale,
                scaleConfiguration: ScaleConfiguration(duration: 300.milliseconds, delay: 50.milliseconds),
                itemBuilder: (_, index) {
                  CategoryData data = subCategoryList[index];

                  return CategoryWidget(
                    isMainCategoryDeleted: widget.isMainCategoryDeleted,
                    categoryData: data,
                    width: context.width() / 2 - 24,
                    isFromCategory: false,
                    onUpdate: () {
                      init(false);
                      setState(() {});
                    },
                  );
                },
              )
            ],
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
