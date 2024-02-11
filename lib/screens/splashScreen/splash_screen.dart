import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/configs.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/screens/auth/sign_in_screen.dart';
import 'package:handyman_admin_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    afterBuildCreated(() async {
      setStatusBarColor(Colors.transparent, statusBarBrightness: Brightness.dark, statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark);

      if (isAndroid || isIOS) {
        getPackageName().then((value) {
          currentPackageName = value;
        }).catchError((e) {
          //
        });
      }
    });

    if (!await isAndroid12Above()) await 500.milliseconds.delay;

    if (!appStore.isLoggedIn) {
      SignInScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade, isNewTask: true);
    } else {
      if (isUserTypeAdmin) {
        setStatusBarColor(primaryColor);
        DashboardScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade, isNewTask: true);
      } else {
        SignInScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade, isNewTask: true);
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            appStore.isDarkMode ? splash_background : splash_light_background,
            height: context.height(),
            width: context.width(),
            fit: BoxFit.cover,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(appLogo, height: 120, width: 120),
              32.height,
              Text(APP_NAME, style: boldTextStyle(size: 26)),
            ],
          ),
        ],
      ),
    );
  }
}
