import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/components/empty_error_state_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/category_response.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/category/add_category_screen.dart';
import 'package:handyman_admin_flutter/screens/category/category_widget.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<CategoryData>> future;

  UniqueKey key = UniqueKey();
  List<CategoryData> categoryList = [];

  bool isLastPage = false;

  int page = 1;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(context.primaryColor);
    });
    init();
  }

  void init([bool showLoader = true]) async {
    appStore.setLoading(showLoader);

    future = getCategoryList(
      page: page,
      perPage: PER_PAGE_ITEM.toString(),
      categoryList: categoryList,
      callback: (res) {
        appStore.setLoading(false);
        isLastPage = res;
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: locale.category,
      actions: [
        IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            bool? res = await AddCategoryScreen().launch(context);

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
        onSuccess: (categoryList) {
          if (categoryList.isEmpty) {
            return NoDataWidget(
              title: locale.noCategoryFound,
              imageWidget: EmptyStateWidget(),
            );
          }

          return AnimatedScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            listAnimationType: ListAnimationType.FadeIn,
            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
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
                itemCount: categoryList.length,
                listAnimationType: ListAnimationType.Scale,
                scaleConfiguration: ScaleConfiguration(duration: 300.milliseconds, delay: 50.milliseconds),
                itemBuilder: (_, index) {
                  CategoryData data = categoryList[index];

                  return CategoryWidget(
                    categoryData: data,
                    width: context.width() / 2 - 24,
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
