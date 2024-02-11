import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/earning_list_response.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_widgets.dart';
import '../../components/empty_error_state_widget.dart';
import 'components/earning_item_widget.dart';

class EarningListScreen extends StatefulWidget {
  const EarningListScreen({Key? key}) : super(key: key);

  @override
  State<EarningListScreen> createState() => _EarningListScreenState();
}

class _EarningListScreenState extends State<EarningListScreen> {
  Future<List<EarningModel>>? future;
  List<EarningModel> earningList = [];

  bool isLastPage = false;

  int page = 1;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = getEarningList(
      page: page,
      earnings: earningList,
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
      appBarTitle: locale.earning,
      child: SnapHelperWidget<List<EarningModel>>(
        future: future,
        loadingWidget: LoaderWidget(),
        onSuccess: (earnings) {
          return AnimatedListView(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16, 8, 16, 60),
            itemCount: earningList.length,
            slideConfiguration: SlideConfiguration(delay: 50.milliseconds, verticalOffset: 400),
            listAnimationType: ListAnimationType.FadeIn,
            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
            itemBuilder: (_, index) {
              return EarningItemWidget(
                earningList[index],
                onUpdate: () {
                  page = 1;
                  appStore.setLoading(true);

                  init();
                  setState(() {});
                },
              );
            },
            onSwipeRefresh: () async {
              page = 1;

              init();
              setState(() {});

              return await 2.seconds.delay;
            },
            onNextPage: () {
              if (!isLastPage) {
                page++;
                appStore.setLoading(true);

                init();
                setState(() {});
              }
            },
            emptyWidget: NoDataWidget(
              title: locale.noEarningFound,
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
