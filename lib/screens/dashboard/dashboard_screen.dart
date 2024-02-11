import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/components/drawer_component.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/dashboard_response.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/dashboard/components/total_component.dart';
import 'package:handyman_admin_flutter/screens/dashboard/components/upcoming_booking_component.dart';
import 'package:handyman_admin_flutter/screens/dashboard/components/user_list_component.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';
import '../../components/job_list_component.dart';
import '../../utils/colors.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  Future<DashboardResponse>? future;

  int page = 1;

  @override
  void initState() {
    setStatusBarColor(primaryColor);
    super.initState();
    final window = WidgetsBinding.instance.window;
    window.onPlatformBrightnessChanged = () {
      appStore.setDarkMode(window.platformBrightness == Brightness.dark);
    };

    init();
  }

  void init() async {
    future = getDashboardDetail();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      message: locale.pressBackAgainToExitApp,
      child: Scaffold(
        key: drawerKey,
        appBar: appBarWidget(
          locale.dashboard,
          textSize: APP_BAR_TEXT_SIZE,
          color: primaryColor,
          textColor: white,
          backWidget: IconButton(
            icon: Icon(Icons.menu, color: white),
            onPressed: () {
              drawerKey.currentState!.openDrawer();
            },
          ),
        ),
        drawer: Drawer(
          backgroundColor: context.cardColor,
          child: DrawerComponent(),
        ),
        body: Stack(
          children: [
            SnapHelperWidget<DashboardResponse>(
                future: future,
                loadingWidget: LoaderWidget(),
                onSuccess: (data) {
                  return AnimatedScrollView(
                    padding: EdgeInsets.only(bottom: 16),
                    physics: AlwaysScrollableScrollPhysics(),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          16.height,
                          Text("${locale.hello}, ${appStore.userFullName}", style: boldTextStyle(size: 16)).paddingLeft(16),
                          8.height,
                          Text(locale.welcomeBack, style: secondaryTextStyle(size: 14)).paddingLeft(16),
                          16.height,
                          TotalComponent(snap: data),
                          UserListComponent(list: data.provider!, userType: USER_TYPE_PROVIDER),
                          UpcomingBookingComponent(bookingList: data.upcomingBooking.validate()),
                          if (data.myPostJobData.validate().isNotEmpty) JobListComponent(list: data.myPostJobData.validate()).paddingOnly(left: 16, right: 16, top: 8),
                          UserListComponent(list: data.user!, userType: USER_TYPE_USER),
                        ],
                      )
                    ],
                    onSwipeRefresh: () async {
                      page = 1;

                      init();
                      setState(() {});

                      return await 2.seconds.delay;
                    },
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
                }),
            Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
