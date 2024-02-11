import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_widgets.dart';
import '../../components/empty_error_state_widget.dart';
import '../../main.dart';
import '../../model/post_job_data.dart';
import '../../networks/rest_apis.dart';
import 'job_item_widget.dart';

class JobListScreen extends StatefulWidget {
  @override
  _JobListScreenState createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  late Future<List<PostJobData>> future;
  List<PostJobData> myPostJobList = [];

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = getPostJobList(page, postJobList: myPostJobList, lastPageCallback: (val) {
      isLastPage = val;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: locale.jobRequestList,
      child: SnapHelperWidget<List<PostJobData>>(
        future: future,
        loadingWidget: LoaderWidget(),
        onSuccess: (data) {
          return AnimatedListView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(8),
            itemCount: data.validate().length,
            shrinkWrap: true,
            itemBuilder: (_, i) => JobItemWidget(data: data[i]),
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
              title: locale.noPostJobFound,
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
