import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handyman_admin_flutter/configs.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/utils/colors.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../locale/app_localizations.dart';
import '../model/service_model.dart';

part 'AppStore.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  bool isDarkMode = false;

  @observable
  bool isLoading = false;

  @observable
  bool isRememberMe = false;

  @observable
  bool isTester = false;

  @observable
  String selectedLanguageCode = DEFAULT_LANGUAGE;

  @observable
  String userProfileImage = '';

  @observable
  String uId = '';

  @observable
  String userFirstName = '';

  @observable
  String userLastName = '';

  @observable
  String userContactNumber = '';

  @observable
  String userEmail = '';

  @observable
  String userName = '';

  @observable
  String token = '';

  @observable
  int countryId = 0;

  @observable
  int stateId = 0;

  @observable
  int cityId = 0;

  @observable
  String address = '';

  @observable
  String designation = '';

  @observable
  int? userId = -1;

  @observable
  int? providerId = -1;

  @observable
  int serviceAddressId = -1;

  @observable
  String userType = '';

  @observable
  String createdAt = '';

  @observable
  String currencySymbol = '';

  @observable
  String inquiryEmail = '';

  @observable
  String helplineNumber = '';

  @observable
  String currencyCode = '';

  @observable
  String currencyCountryId = '';

  @observable
  bool useMaterialYouTheme = false;

  @observable
  bool isCurrentLocation = false;

  @observable
  List<ServiceData> selectedServiceList = ObservableList.of([]);

  @observable
  bool isCategoryWisePackageService = false;

  @computed
  String get userFullName => '$userFirstName $userLastName'.trim();

  @action
  Future<void> setTester(bool val, {bool isInitializing = false}) async {
    isTester = val;
    if (!isInitializing) await setValue(IS_TESTER, isTester);
  }

  @action
  Future<void> addSelectedPackageService(ServiceData val, {bool isInitializing = false}) async {
    selectedServiceList.add(val);
  }

  @action
  Future<void> addAllSelectedPackageService(List<ServiceData> val, {bool isInitializing = false}) async {
    selectedServiceList.addAll(val);
  }

  @action
  Future<void> removeSelectedPackageService(ServiceData val, {bool isInitializing = false}) async {
    selectedServiceList.remove(selectedServiceList.firstWhere((element) => element.id == val.id));
  }

  @action
  Future<void> setCategoryBasedPackageService(bool val, {bool isInitializing = false}) async {
    isCategoryWisePackageService = val;
    if (!isInitializing) await setValue(CATEGORY_BASED_SELECT_PACKAGE_SERVICE, isCategoryWisePackageService);
  }

  @action
  Future<void> setCurrentLocation(bool val, {bool isInitializing = false}) async {
    isCurrentLocation = val;
    if (!isInitializing) await setValue(IS_CURRENT_LOCATION, val);
  }

  @action
  Future<void> setUserProfile(String val, {bool isInitializing = false}) async {
    userProfileImage = val;
    if (!isInitializing) await setValue(PROFILE_IMAGE, val);
  }

  @action
  Future<void> setToken(String val, {bool isInitializing = false}) async {
    token = val;
    if (!isInitializing) await setValue(TOKEN, val);
  }

  @action
  Future<void> setCountryId(int val, {bool isInitializing = false}) async {
    countryId = val;
    if (!isInitializing) await setValue(COUNTRY_ID, val);
  }

  @action
  Future<void> setStateId(int val, {bool isInitializing = false}) async {
    stateId = val;
    if (!isInitializing) await setValue(STATE_ID, val);
  }

  @action
  Future<void> setCityId(int val, {bool isInitializing = false}) async {
    cityId = val;
    if (!isInitializing) await setValue(CITY_ID, val);
  }

  @action
  Future<void> setUId(String val, {bool isInitializing = false}) async {
    uId = val;
    if (!isInitializing) await setValue(UID, val);
  }

  @action
  Future<void> setUserId(int val, {bool isInitializing = false}) async {
    userId = val;
    if (!isInitializing) await setValue(USER_ID, val);
  }

  @action
  Future<void> setDesignation(String val, {bool isInitializing = false}) async {
    designation = val;
    if (!isInitializing) await setValue(DESIGNATION, val);
  }

  @action
  Future<void> setUserType(String val, {bool isInitializing = false}) async {
    userType = val;
    if (!isInitializing) await setValue(USER_TYPE, val);
  }

  @action
  Future<void> setCreatedAt(String val, {bool isInitializing = false}) async {
    createdAt = val;
    if (!isInitializing) await setValue(CREATED_AT, val);
  }

  @action
  Future<void> setProviderId(int val, {bool isInitializing = false}) async {
    providerId = val;
    if (!isInitializing) await setValue(PROVIDER_ID, val);
  }

  @action
  Future<void> setServiceAddressId(int val, {bool isInitializing = false}) async {
    serviceAddressId = val;
    if (!isInitializing) await setValue(SERVICE_ADDRESS_ID, val);
  }

  @action
  Future<void> setUserEmail(String val, {bool isInitializing = false}) async {
    userEmail = val;
    if (!isInitializing) await setValue(USER_EMAIL, val);
  }

  @action
  Future<void> setAddress(String val, {bool isInitializing = false}) async {
    address = val;
    if (!isInitializing) await setValue(ADDRESS, val);
  }

  @action
  Future<void> setFirstName(String val, {bool isInitializing = false}) async {
    userFirstName = val;
    if (!isInitializing) await setValue(FIRST_NAME, val);
  }

  @action
  Future<void> setLastName(String val, {bool isInitializing = false}) async {
    userLastName = val;
    if (!isInitializing) await setValue(LAST_NAME, val);
  }

  @action
  Future<void> setContactNumber(String val, {bool isInitializing = false}) async {
    userContactNumber = val;
    if (!isInitializing) await setValue(CONTACT_NUMBER, val);
  }

  @action
  Future<void> setUserName(String val, {bool isInitializing = false}) async {
    userName = val;
    if (!isInitializing) await setValue(USERNAME, val);
  }

  @action
  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await setValue(IS_LOGGED_IN, val);
  }

  @action
  void setLoading(bool val) {
    isLoading = val;
  }

  @action
  void setRemember(bool val) {
    isRememberMe = val;
  }

  @action
  Future<void> setInitialAdCount(int val) async {
    countryId = val;
    // await setValue(INITIAL_AD_COUNT, val);
  }

  @action
  Future<void> setCurrencyCode(String val, {bool isInitializing = false}) async {
    currencyCode = val;
    if (!isInitializing) await setValue(CURRENCY_COUNTRY_CODE, val);
  }

  @action
  Future<void> setCurrencyCountryId(String val, {bool isInitializing = false}) async {
    currencyCountryId = val;
    if (!isInitializing) await setValue(CURRENCY_COUNTRY_ID, val);
  }

  @action
  Future<void> setCurrencySymbol(String val, {bool isInitializing = false}) async {
    currencySymbol = val;
    if (!isInitializing) await setValue(CURRENCY_COUNTRY_SYMBOL, val);
  }

  @action
  Future<void> setInquiryEmail(String val, {bool isInitializing = false}) async {
    inquiryEmail = val;
    if (!isInitializing) await setValue(INQUIRY_EMAIL, val);
  }

  @action
  Future<void> setHelplineNumber(String val, {bool isInitializing = false}) async {
    helplineNumber = val;
    if (!isInitializing) await setValue(HELPLINE_NUMBER, val);
  }

  @action
  Future<void> setDarkMode(bool val) async {
    isDarkMode = val;
    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = scaffoldSecondaryDark;
      appButtonBackgroundColorGlobal = appButtonColorDark;
      shadowColorGlobal = Colors.white12;
      setStatusBarColor(appButtonColorDark);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: primaryColor,
        systemNavigationBarDividerColor: Colors.transparent,
      ));
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.black12;
      setStatusBarColor(primaryColor);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.transparent,
      ));
    }
  }

  @action
  Future<void> setLanguage(String val) async {
    selectedLanguageCode = val;

    await setValue(SELECTED_LANGUAGE_CODE, selectedLanguageCode);
    selectedLanguageDataModel = getSelectedLanguageModel();

    locale = await AppLocalizations().load(Locale(appStore.selectedLanguageCode));
    errorMessage = locale.pleaseTryAgain;
    errorSomethingWentWrong = locale.somethingWentWrong;
    errorThisFieldRequired = locale.thisFieldIsRequired;
    errorInternetNotAvailable = locale.internetNotAvailable;
  }

  @action
  Future<void> setUseMaterialYouTheme(bool val, {bool isInitializing = false}) async {
    useMaterialYouTheme = val;
    if (!isInitializing) await setValue(USE_MATERIAL_YOU_THEME, val);
  }
}
