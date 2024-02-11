import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/view_all_label_component.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../model/post_job_data.dart';
import '../screens/jobRequest/job_item_widget.dart';
import '../screens/jobRequest/job_list_screen.dart';

class JobListComponent extends StatelessWidget {
  final List<PostJobData> list;

  JobListComponent({required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: locale.jobRequestList,
          list: list.validate(),
          onTap: () {
            JobListScreen().launch(context);
          },
        ),
        AnimatedListView(
          itemCount: list.validate().length,
          shrinkWrap: true,
          itemBuilder: (_, i) => JobItemWidget(data: list[i]),
        ),
      ],
    );
  }
}
