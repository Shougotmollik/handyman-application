import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/components/back_widget.dart';
import 'package:handyman_admin_flutter/components/empty_error_state_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/service_detail_response.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/review/review_widget.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class RatingViewAllScreen extends StatelessWidget {
  final List<RatingData>? ratingData;
  final int? serviceId;
  final int? handymanId;

  RatingViewAllScreen({this.ratingData, this.serviceId, this.handymanId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.reviews, color: context.primaryColor, textColor: Colors.white, backWidget: BackWidget()),
      body: SnapHelperWidget<List<RatingData>>(
        future: serviceId != null ? serviceReviews({CommonKeys.serviceId: serviceId}) : handymanReviews({CommonKeys.handymanId: handymanId}),
        loadingWidget: LoaderWidget(),
        onSuccess: (data) {
          if (data.isNotEmpty) {
            return AnimatedListView(
              slideConfiguration: sliderConfigurationGlobal,
              shrinkWrap: true,
              padding: EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, index) => ReviewWidget(data: data[index], isCustomer: serviceId == null),
            );
          } else {
            return NoDataWidget(
              title: locale.noServiceRatings,
              imageWidget: EmptyStateWidget(),
            );
          }
        },
      ),
    );
  }
}
