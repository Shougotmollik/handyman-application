import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/screens/aboutApp/about_app_screen.dart';
import 'package:handyman_admin_flutter/screens/booking/booking_list_screen.dart';
import 'package:handyman_admin_flutter/screens/category/add_category_screen.dart';
import 'package:handyman_admin_flutter/screens/category/category_screen.dart';
import 'package:handyman_admin_flutter/screens/coupon/add_coupon_screen.dart';
import 'package:handyman_admin_flutter/screens/coupon/coupon_list_screen.dart';
import 'package:handyman_admin_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:handyman_admin_flutter/screens/document/add_document_screen.dart';
import 'package:handyman_admin_flutter/screens/document/document_list_screen.dart';
import 'package:handyman_admin_flutter/screens/earning/earning_list_screen.dart';
import 'package:handyman_admin_flutter/screens/payment/payment_list_screen.dart';
import 'package:handyman_admin_flutter/screens/provider/provider_handyman_type_list_screen.dart';
import 'package:handyman_admin_flutter/screens/service/add_service_screen.dart';
import 'package:handyman_admin_flutter/screens/service/service_list_screen.dart';
import 'package:handyman_admin_flutter/screens/settings/push_notification_screen.dart';
import 'package:handyman_admin_flutter/screens/settings/setting_screen.dart';
import 'package:handyman_admin_flutter/screens/tax/taxes_screen.dart';
import 'package:handyman_admin_flutter/screens/user/add_update_user_screen.dart';
import 'package:handyman_admin_flutter/screens/user/user_list_screen.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../configs.dart';
import '../screens/packages/package_list_screen.dart';
import '../screens/review/ratings_list_screen.dart';
import '../screens/wallet/wallet_list_screen.dart';

class DrawerModel {
  String? title;
  Icon? icon;
  Widget? widget;
  List<DrawerModel>? widgets;
  String? url;
  bool? shareApp;

  DrawerModel({this.title, this.icon, this.widget, this.widgets, this.url, this.shareApp});
}

List<DrawerModel> getDrawerItems() {
  List<DrawerModel> drawerItems = [];

  drawerItems.add(DrawerModel(title: locale.dashboard, widget: DashboardScreen()));

  drawerItems.add(
    DrawerModel(
      title: locale.category,
      widgets: [
        DrawerModel(title: locale.categoryList, widget: CategoryScreen()),
        DrawerModel(title: locale.addCategory, widget: AddCategoryScreen()),
      ],
    ),
  );

  drawerItems.add(
    DrawerModel(
      title: locale.service,
      widgets: [
        DrawerModel(title: locale.serviceList, widget: ServiceListScreen()),
        //DrawerModel(title: "User Service List", widget: ServiceListScreen()),
        DrawerModel(title: locale.addService, widget: AddServiceScreen()),
        DrawerModel(title: locale.packages, widget: PackageListScreen()),
      ],
    ),
  );

  drawerItems.add(DrawerModel(title: locale.booking, widget: BookingListScreen()));

  drawerItems.add(
    DrawerModel(
      title: locale.provider,
      widgets: [
        DrawerModel(title: locale.providerList, widget: UserListScreen(type: USER_TYPE_PROVIDER, status: USER_STATUS_ACTIVE)),
        DrawerModel(title: locale.addProvider, widget: AddUpdateUserScreen(userType: USER_TYPE_PROVIDER)),
        DrawerModel(title: locale.pendingProvider, widget: UserListScreen(type: USER_TYPE_PROVIDER, status: PENDING, title: locale.pendingProvider)),
        DrawerModel(title: locale.providerTypeList, widget: ProviderHandymanTypeListScreen(type: USER_TYPE_PROVIDER)),
        //DrawerModel(title: "Subscribe Provider List", widget: UserListScreen(type: USER_TYPE_PROVIDER)),
        //DrawerModel(title: "Bank List", widget: BankListScreen()),
      ],
    ),
  );

  drawerItems.add(
    DrawerModel(
      title: locale.handyman,
      widgets: [
        DrawerModel(title: locale.handymanList, widget: UserListScreen(type: USER_TYPE_HANDYMAN, status: USER_STATUS_ACTIVE)),
        DrawerModel(title: locale.addHandyman, widget: AddUpdateUserScreen(userType: USER_TYPE_HANDYMAN)),
        DrawerModel(title: locale.pendingHandyman, widget: UserListScreen(type: USER_TYPE_HANDYMAN, status: PENDING, title: locale.pendingHandyman)),
        DrawerModel(title: locale.handymanTypeList, widget: ProviderHandymanTypeListScreen(type: USER_TYPE_HANDYMAN)),
      ],
    ),
  );

  drawerItems.add(DrawerModel(title: locale.users, widget: UserListScreen(type: USER_TYPE_USER)));

  drawerItems.add(
    DrawerModel(
      title: locale.transactions,
      widgets: [
        DrawerModel(title: locale.taxes, widget: TaxesScreen()),
        DrawerModel(title: locale.payments, widget: PaymentListScreen()),
        //DrawerModel(title: "Cash Payment List", widget: CashPaymentScreen()),
        DrawerModel(title: locale.earning, widget: EarningListScreen()),
        DrawerModel(title: locale.walletList, widget: WalletListScreen()),
      ],
    ),
  );

  //drawerItems.add(DrawerModel(title: "Post Job", widget: PostJobListScreen()));

  drawerItems.add(
    DrawerModel(
      title: locale.coupon,
      widgets: [
        DrawerModel(title: locale.couponList, widget: CouponListScreen()),
        DrawerModel(title: locale.addCoupon, widget: AddCouponScreen()),
      ],
    ),
  );

  drawerItems.add(
    DrawerModel(
      title: locale.ratings,
      widgets: [
        DrawerModel(title: locale.userServiceRatings, widget: RatingsListScreen(ratingType: RatingType.UserServiceRating)),
        DrawerModel(title: locale.handymanRatings, widget: RatingsListScreen(ratingType: RatingType.HandymanRating)),
      ],
    ),
  );

  //drawerItems.add(DrawerModel(title: "Plan", widget: PlanListScreen()));

  drawerItems.add(
    DrawerModel(
      title: locale.document,
      widgets: [
        DrawerModel(title: locale.documentList, widget: DocumentListScreen()),
        DrawerModel(title: locale.addDocument, widget: AddDocumentScreen()),
      ],
    ),
  );

  drawerItems.add(
    DrawerModel(
      title: locale.settings,
      widgets: [
        //DrawerModel(title: "General Setting", widget: GeneralSettingScreen()),
        DrawerModel(title: locale.pushNotificationSettings, widget: PushNotificationScreen()),
        DrawerModel(title: locale.appSettings, widget: SettingScreen()),
        //DrawerModel(title: "Config Setting", widget: ConfigSettingScreen()),
       //DrawerModel(title: "Earning Setting", widget: EarningSettingScreen()),
      ],
    ),
  );

  drawerItems.add(
    DrawerModel(title: locale.aboutApp, widget: AboutAppScreen()),
  );

  drawerItems.add(
    DrawerModel(title: locale.rateUs, url: isAndroid ? '$playStoreBaseURL$currentPackageName' : '$appStoreBaseURL$APP_STORE_APP_ID'),
  );

  drawerItems.add(
    DrawerModel(title: locale.shareApp, shareApp: true),
  );

  return drawerItems;
}
