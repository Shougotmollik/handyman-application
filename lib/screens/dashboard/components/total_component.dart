import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/dashboard_response.dart';
import 'package:handyman_admin_flutter/screens/booking/booking_list_screen.dart';
import 'package:handyman_admin_flutter/screens/dashboard/components/total_widget.dart';
import 'package:handyman_admin_flutter/screens/service/service_list_screen.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/common.dart';
import '../../earning/earning_list_screen.dart';
import '../../user/user_list_screen.dart';

class TotalComponent extends StatelessWidget {
  final DashboardResponse snap;

  TotalComponent({required this.snap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        TotalWidget(title: locale.totalBookings, total: '${snap.totalBooking}', icon: total_booking).onTap(
          () {
            BookingListScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        TotalWidget(
          title: locale.totalServices,
          total: snap.totalService.validate().toString(),
          icon: total_services,
        ).onTap(
          () {
            ServiceListScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        TotalWidget(
          title: locale.totalProviders,
          total: '${snap.totalProvider.validate()}',
          icon: handyman,
        ).onTap(
          () {
            UserListScreen(type: USER_TYPE_PROVIDER).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        TotalWidget(
          title: '${locale.total} ${locale.revenue}',
          total: "${isCurrencyPositionLeft ? appStore.currencySymbol : ''}${snap.totalRevenue.toString().toDouble().toStringAsFixed(DECIMAL_POINT)}${isCurrencyPositionRight ? appStore.currencySymbol : ''}",
          icon: ic_percent_line,
          height: 20,
          width: 20,
        ).onTap(
          () {
            EarningListScreen().launch(context);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
      ],
    ).paddingAll(16);
  }
}
