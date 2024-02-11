import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/configs.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/base_response.dart';
import 'package:handyman_admin_flutter/model/booking_data_model.dart';
import 'package:handyman_admin_flutter/model/booking_detail_response.dart';
import 'package:handyman_admin_flutter/model/booking_list_response.dart';
import 'package:handyman_admin_flutter/model/booking_status_response.dart';
import 'package:handyman_admin_flutter/model/category_response.dart';
import 'package:handyman_admin_flutter/model/coupon_model.dart';
import 'package:handyman_admin_flutter/model/coupon_response.dart';
import 'package:handyman_admin_flutter/model/document_list_response.dart';
import 'package:handyman_admin_flutter/model/earning_list_response.dart';
import 'package:handyman_admin_flutter/model/login_response.dart';
import 'package:handyman_admin_flutter/model/payment_list_response.dart';
import 'package:handyman_admin_flutter/model/provider_address_list_response.dart';
import 'package:handyman_admin_flutter/model/provider_address_mapping_model.dart';
import 'package:handyman_admin_flutter/model/provider_document_response.dart';
import 'package:handyman_admin_flutter/model/provider_info_model.dart';
import 'package:handyman_admin_flutter/model/register_response.dart';
import 'package:handyman_admin_flutter/model/search_list_response.dart';
import 'package:handyman_admin_flutter/model/service_detail_response.dart';
import 'package:handyman_admin_flutter/model/service_model.dart';
import 'package:handyman_admin_flutter/model/service_review_response.dart';
import 'package:handyman_admin_flutter/model/type_list_response.dart';
import 'package:handyman_admin_flutter/model/user_data.dart';
import 'package:handyman_admin_flutter/model/user_list_response.dart';
import 'package:handyman_admin_flutter/model/user_type_response.dart';
import 'package:handyman_admin_flutter/model/walletListResponse.dart';
import 'package:handyman_admin_flutter/networks/network_utils.dart';
import 'package:handyman_admin_flutter/screens/auth/sign_in_screen.dart';
import 'package:handyman_admin_flutter/screens/review/ratings_list_screen.dart';
import 'package:handyman_admin_flutter/utils/colors.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../model/Package_response.dart';
import '../model/dashboard_response.dart';
import '../model/payout_history_response.dart';
import '../model/post_job_data.dart';
import '../model/post_job_detail_response.dart';
import '../model/post_job_response.dart';
import '../model/tax_list_response.dart';

//region LOGIN USER API
Future<LoginResponse> loginUser(Map request) async {
  LoginResponse res = LoginResponse.fromJson(await (handleResponse(await buildHttpResponse('login', request: request, method: HttpMethod.POST))));

  if (res.data!.userType != USER_TYPE_ADMIN && res.data!.userType != DEMO_ADMIN) {
    throw 'Only Admin and Demo Admin can access this app.';
  }
  return res;
}
//endregion

//region Get Dashboard API
Future<DashboardResponse> getDashboardDetail({String? page, String? perPage}) async {
  try {
    DashboardResponse res = DashboardResponse.fromJson(await handleResponse(await buildHttpResponse('admin-dashboard', method: HttpMethod.GET)));

    if (res.privacyPolicy != null && res.privacyPolicy!.value.validate().isNotEmpty) {
      setValue(PRIVACY_POLICY, res.privacyPolicy!.value.validate());
    } else {
      setValue(PRIVACY_POLICY, PRIVACY_POLICY_URL);
    }

    if (res.termConditions != null && res.termConditions!.value.validate().isNotEmpty) {
      setValue(TERMS_AND_CONDITION, res.termConditions!.value.validate());
    } else {
      setValue(TERMS_AND_CONDITION, TERMS_CONDITION_URL);
    }

    if (res.inquiryEmail.validate().isNotEmpty) {
      appStore.setInquiryEmail(res.inquiryEmail.validate());
    } else {
      appStore.setInquiryEmail(INQUIRY_SUPPORT_EMAIL);
    }

    if (res.helplineNumber.validate().isNotEmpty) {
      appStore.setHelplineNumber(res.helplineNumber.validate());
    }
    res.configurations.validate().forEach((data) {
      if (data.key == CONFIGURATION_KEY_CURRENCY_COUNTRY_ID) {
        if (data.country != null) {
          if (data.country!.currencyCode.validate() != appStore.currencyCode) appStore.setCurrencyCode(data.country!.currencyCode.validate());
          if (data.country!.id.validate().toString() != appStore.countryId.toString()) appStore.setCurrencyCountryId(data.country!.id.validate().toString());
          if (data.country!.symbol.validate() != appStore.currencySymbol) appStore.setCurrencySymbol(data.country!.symbol.validate());
        }
      } else if (data.key == CONFIGURATION_TYPE_CURRENCY_POSITION) {
        if (data.value.validate().isNotEmpty) {
          setValue(CONFIGURATION_TYPE_CURRENCY_POSITION, data.value);
        }
      }
    });

    if (res.configurations.validate().any((element) => element.type == CONFIGURATION_TYPE_CURRENCY)) {
      Configurations data = res.configurations!.firstWhere((element) => element.type == CONFIGURATION_TYPE_CURRENCY);

      // if (data.country!.currencyCode.validate() != appStore.currencyCode) appStore.setCurrencyCode(data.country!.currencyCode.validate());
      // if (data.country!.id.validate().toString() != appStore.countryId.toString()) appStore.setCurrencyCountryId(data.country!.id.validate().toString());
      if (data.country!.symbol.validate() != appStore.currencySymbol) appStore.setCurrencySymbol(data.country!.symbol.validate());
    }

    setValue(EARNING_TYPE, res.earningType.validate());
    setValue(IS_ADVANCE_PAYMENT_ALLOWED, res.isAdvancedPaymentAllowed == '1');

    appStore.setLoading(false);
    return res;
  } catch (e) {
    appStore.setLoading(false);

    log(e);
    throw errorSomethingWentWrong;
  }
}
//endregion

//region Category API
Future<List<CategoryData>> getCategoryList({int page = 1, String? perPage, required List<CategoryData> categoryList, Function(bool)? callback}) async {
  try {
    var res = CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('get-category-list?page=$page&per_page=$perPage', method: HttpMethod.GET)));

    if (page == 1) categoryList.clear();
    categoryList.addAll(res.categoryList.validate());
    appStore.setLoading(false);

    callback?.call(res.categoryList.validate().length != PER_PAGE_ITEM);
  } catch (e) {
    appStore.setLoading(false);

    log(e);
    throw errorSomethingWentWrong;
  }
  return categoryList;
}

Future<BaseResponseModel> deleteCategory(int id) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('category-delete/$id', method: HttpMethod.POST)));
}

Future<CategoryResponse> addCategory({Map? request}) async {
  return CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('category-save', request: request, method: HttpMethod.POST)));
}

Future<BaseResponseModel> restoreCategory(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('category-action', request: request, method: HttpMethod.POST)));
}

Future<BaseResponseModel> deleteSubCategory(int id) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('subcategory-delete/$id', method: HttpMethod.POST)));
}

Future<BaseResponseModel> restoreSubCategory(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('subcategory-action', request: request, method: HttpMethod.POST)));
}

//endregion

//region SubCategory Api
Future<List<CategoryData>> getSubCategoryList({int? catId, int? page, int perPage = PER_PAGE_ITEM, required List<CategoryData> subCategoryList, Function(bool)? callback}) async {
  try {
    CategoryResponse? res;
    if (catId != null) {
      res = CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('get-subcategory-list?category_id=$catId&page=$page&per_page=$perPage', method: HttpMethod.GET)));
    } else {
      res = CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('get-subcategory-list?page=$page&per_page=$perPage', method: HttpMethod.GET)));
    }

    if (page == 1) subCategoryList.clear();
    subCategoryList.addAll(res.categoryList.validate());
    appStore.setLoading(false);

    callback?.call(res.categoryList.validate().length != PER_PAGE_ITEM);
  } catch (e) {
    appStore.setLoading(false);

    log(e);
    throw errorSomethingWentWrong;
  }

  return subCategoryList;
}
//endregion

//region SERVICE API
Future<SearchListResponse> getServicesList(int page, {var perPage = PER_PAGE_ITEM, int? categoryId = -1, int? subCategoryId = -1, int? providerId, String? search, String? type}) async {
  String? req;
  String categoryIds = categoryId != -1 ? 'category_id=$categoryId&' : '';
  String searchPara = search.validate().isNotEmpty ? 'search=$search&' : '';
  String subCategorys = subCategoryId != -1 ? 'subcategory_id=$subCategoryId&' : '';
  String pages = 'page=$page&';
  String perPages = 'per_page=$PER_PAGE_ITEM';
  String serviceType = type.validate().isNotEmpty ? 'type=$type&' : "";
  String proId = providerId.validate() != 0 ? '&provider_id=$providerId' : "";

  req = '?$categoryIds$subCategorys$serviceType$searchPara$pages$perPages$proId';
  return SearchListResponse.fromJson(await handleResponse(await buildHttpResponse('get-service-list$req', method: HttpMethod.GET)));
}

Future<List<ServiceData>> getSearchList(
  int page, {
  var perPage = PER_PAGE_ITEM,
  int? categoryId,
  String search = '',
  List<ServiceData> serviceList = const [],
  List<ServiceData> serviceIds = const [],
  Function(bool)? callback,
}) async {
  try {
    var searchKey = search.isNotEmpty ? '&search=$search' : '';
    var res = SearchListResponse.fromJson(await handleResponse(await buildHttpResponse('get-service-list?per_page=$perPage&page=$page$searchKey', method: HttpMethod.GET)));

    if (page == 1) serviceList.clear();
    serviceList.addAll(res.serviceList.validate());
    res.serviceList.validate().forEach((service) {
      if (serviceIds.any((element) => element.id == service.id)) {
        service.isSelected = true;
      }
    });

    callback?.call(res.serviceList.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    log(e);
    throw errorSomethingWentWrong;
  }

  return serviceList;
}

Future<ServiceDetailResponse> getServiceDetails({required int serviceId, int? customerId}) async {
  Map request = {CommonKeys.serviceId: serviceId};
  return ServiceDetailResponse.fromJson(await handleResponse(await buildHttpResponse('get-service-detail', request: request, method: HttpMethod.POST)));
}

Future<BaseResponseModel> deleteService(int id) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('service-delete/$id', method: HttpMethod.POST)));
}

Future<BaseResponseModel> serviceAction(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('service-action', request: request, method: HttpMethod.POST)));
}
//endregion

//region USER API
Future<List<UserData>> getUser({
  required String userType,
  required List<UserData> userdata,
  int page = 1,
  int? perPage = PER_PAGE_ITEM,
  int? providerId,
  String? userStatus,
  String? keyword,
  Function(bool)? callback,
}) async {
  try {
    String _search = keyword.validate().isNotEmpty ? 'keyword=$keyword&' : '';
    String _status = userStatus.validate().isNotEmpty ? "status=$userStatus&" : "";
    String _userType = userType.validate().isNotEmpty ? "user_type=$userType&" : "";

    var res = UserListResponse.fromJson(
      await handleResponse(await buildHttpResponse('get-user-list?$_search$_userType${_status}per_page=${perPage ?? PER_PAGE_ALL}&page=$page', method: HttpMethod.GET)),
    );

    if (page == 1) userdata.clear();
    userdata.addAll(res.data.validate());
    appStore.setLoading(false);

    callback?.call(res.data.validate().length != PER_PAGE_ITEM);
  } catch (e) {
    appStore.setLoading(false);

    log(e);
    throw errorSomethingWentWrong;
  }
  return userdata;
}

Future<BaseResponseModel> updateUserStatus(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('user-update-status', request: request, method: HttpMethod.POST)));
}

Future<BaseResponseModel> updateUser(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('edit-user', request: request, method: HttpMethod.POST)));
}

Future<RegisterResponse> registerUser(Map request, {bool isRegister = true}) async {
  return RegisterResponse.fromJson(await (handleResponse(await buildHttpResponse(isRegister ? 'add-user' : 'edit-user', request: request, method: HttpMethod.POST))));
}

//endregion

//region Provider and Handyman details data

Future<List<PayoutData>> getPayoutHistoryList(int page,
    {required int id, List<PayoutData> payoutList = const [], String userType = USER_TYPE_PROVIDER, var perPage = PER_PAGE_ITEM, Function(bool)? callback}) async {
  try {
    var res = PayoutHistoryResponse.fromJson(await handleResponse(await buildHttpResponse(
      '${userType == USER_TYPE_PROVIDER ? 'provider-payout-list' : 'handyman-payout-list'}?user_id=$id&per_page=$perPage&page=$page',
      method: HttpMethod.GET,
    )));
    if (page == 1) payoutList.clear();
    payoutList.addAll(res.payoutData.validate());
    appStore.setLoading(false);
    callback?.call(res.payoutData.validate().length != PER_PAGE_ITEM);
  } catch (e) {
    appStore.setLoading(false);

    log(e);
    throw errorSomethingWentWrong;
  }

  return payoutList;
}
//endregion

//region Provider Service Address API

Future<List<ProviderAddressMapping>> getProviderAddress({int page = 1, required int id, List<ProviderAddressMapping> providerAddress = const [], Function(bool)? callback}) async {
  try {
    var res = ProviderAddressListResponse.fromJson(await handleResponse(await buildHttpResponse('provideraddress-list?provider_id=$id&?page=$page&per_page=$PER_PAGE_ITEM', method: HttpMethod.GET)));

    if (page == 1) providerAddress.clear();
    providerAddress.addAll(res.data.validate());
    appStore.setLoading(false);

    callback?.call(res.data.validate().length != PER_PAGE_ITEM);
  } catch (e) {
    appStore.setLoading(false);

    log(e);
    throw errorSomethingWentWrong;
  }

  return providerAddress;
}

Future<BaseResponseModel> saveAddresses({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('provideraddress-save', request: request, method: HttpMethod.POST)));
}

Future<BaseResponseModel> removeAddress(int? id) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('provideraddress-delete/$id', method: HttpMethod.POST)));
}

Future<BaseResponseModel> restoreAddress(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('provideraddress-action', request: request, method: HttpMethod.POST)));
}

//endregion

//region Get Provider Document API
Future<List<ProviderDocumentData>> getProviderDocuments({int page = 1, int? providerId, List<ProviderDocumentData> providerDocuments = const [], Function(bool)? callback}) async {
  try {
    var res =
        ProviderDocumentResponse.fromJson(await handleResponse(await buildHttpResponse('provider-document-list?provider_id=$providerId&page=$page&per_page=$PER_PAGE_ITEM', method: HttpMethod.GET)));

    if (page == 1) providerDocuments.clear();
    providerDocuments.addAll(res.data.validate());
    appStore.setLoading(false);

    callback?.call(res.data.validate().length != PER_PAGE_ITEM);
  } catch (e) {
    appStore.setLoading(false);

    log(e);
    throw errorSomethingWentWrong;
  }

  return providerDocuments;
}

Future<BaseResponseModel> saveProviderDocument({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('provider-document-save', method: HttpMethod.POST, request: request)));
}

Future<BaseResponseModel> removeProviderDocument(int id) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('provider-document-delete/$id', request: {}, method: HttpMethod.POST)));
}

Future<BaseResponseModel> restoreProviderDocument(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('provider-document-action', request: request, method: HttpMethod.POST)));
}

//endregion

//region Get Provider Document API

//region Get Type List API
Future<List<TypeDataModel>> getTypeList({int page = 1, String type = USER_TYPE_PROVIDER, List<TypeDataModel> typeList = const [], Function(bool)? callback}) async {
  try {
    var res = TypeListResponse.fromJson(await handleResponse(await buildHttpResponse('get-type-list?type=$type&page=$page&per_page=$PER_PAGE_ITEM', method: HttpMethod.GET)));

    if (page == 1) typeList.clear();
    typeList.addAll(res.data.validate());
    appStore.setLoading(false);

    callback?.call(res.data.validate().length != PER_PAGE_ITEM);
  } catch (e) {
    appStore.setLoading(false);

    log(e);
    throw errorSomethingWentWrong;
  }

  return typeList;
}

Future<BaseResponseModel> saveProviderHandymanTypeList({required Map request, String type = USER_TYPE_PROVIDER}) async {
  String endPoint = 'providertype-save';
  if (type == USER_TYPE_HANDYMAN) {
    endPoint = 'handymantype-save';
  }

  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(endPoint, method: HttpMethod.POST, request: request)));
}

Future<BaseResponseModel> deleteProviderHandymanTypeList(int id, {String type = USER_TYPE_PROVIDER}) async {
  String endPoint = 'providertype-delete/$id';
  if (type == USER_TYPE_HANDYMAN) {
    endPoint = 'handymantype-delete/$id';
  }
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(endPoint, method: HttpMethod.POST)));
}

Future<BaseResponseModel> restoreProviderHandymanType(Map request, {String type = USER_TYPE_PROVIDER}) async {
  String endPoint = 'providertype-action';
  if (type == USER_TYPE_HANDYMAN) {
    endPoint = 'handymantype-action';
  }
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(endPoint, request: request, method: HttpMethod.POST)));
}

//endregion

//region Booking API
Future<List<BookingStatusResponse>> bookingStatus({required List<BookingStatusResponse> list}) async {
  Iterable res = await (handleResponse(await buildHttpResponse('booking-status', method: HttpMethod.GET)));
  list = res.map((e) => BookingStatusResponse.fromJson(e)).toList();
  cachedBookingStatusDropdown = list;

  return list;
}

Future<List<BookingData>> getBookingList(int page, {var perPage = PER_PAGE_ITEM, String status = '', required List<BookingData> bookings, Function(bool)? lastPageCallback}) async {
  try {
    BookingListResponse res;

    if (status == BOOKING_TYPE_ALL) {
      res = BookingListResponse.fromJson(await handleResponse(await buildHttpResponse('booking-list?&per_page=$perPage&page=$page', method: HttpMethod.GET)));
    } else {
      res = BookingListResponse.fromJson(await handleResponse(await buildHttpResponse('booking-list?status=$status&per_page=$perPage&page=$page', method: HttpMethod.GET)));
    }

    if (page == 1) bookings.clear();
    bookings.addAll(res.data.validate());
    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);

    log(e);
    throw errorSomethingWentWrong;
  }

  return bookings;
}

Future<BookingDetailResponse> bookingDetail(Map request) async {
  BookingDetailResponse bookingDetailResponse = BookingDetailResponse.fromJson(
    await handleResponse(await buildHttpResponse('booking-detail', request: request, method: HttpMethod.POST)),
  );

  return bookingDetailResponse;
}

//endregion

Future<List<PaymentData>> getUserPaymentList(int page, int id, List<PaymentData> list, Function(bool)? lastPageCallback) async {
  appStore.setLoading(true);
  var res = PaymentListResponse.fromJson(await handleResponse(await buildHttpResponse('payment-list?booking_id=$id&page=$page', method: HttpMethod.GET)));

  if (page == 1) list.clear();
  list.addAll(res.data.validate());

  appStore.setLoading(false);

  lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

  return list;
}

//region Payment API
Future<List<PaymentData>> getPaymentList({int page = 1, List<PaymentData> payments = const [], Function(bool)? callback}) async {
  try {
    var res = PaymentListResponse.fromJson(await handleResponse(await buildHttpResponse('payment-list?page=$page&per_page=$PER_PAGE_ITEM', method: HttpMethod.GET)));

    if (page == 1) payments.clear();
    payments.addAll(res.data.validate());
    appStore.setLoading(false);

    callback?.call(res.data.validate().length != PER_PAGE_ITEM);
  } catch (e) {
    appStore.setLoading(false);

    log(e);
    throw errorSomethingWentWrong;
  }

  return payments;
}
//endregion

// region Package service API
Future<List<PackageData>> getAllPackageList({int? page, required List<PackageData> packageData, Function(bool)? lastPageCallback}) async {
  try {
    PackageResponse res = PackageResponse.fromJson(
      await handleResponse(await buildHttpResponse('package-list?per_page=$PER_PAGE_ITEM&page=$page', method: HttpMethod.GET)),
    );

    if (page == 1) packageData.clear();

    packageData.addAll(res.packageList.validate());

    lastPageCallback?.call(res.packageList.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);

    log(e);
    throw errorSomethingWentWrong;
  }

  return packageData;
}

Future<void> addPackageMultiPart({required Map<String, dynamic> value, List<File>? imageFile}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('servicepackage-save');

  multiPartRequest.fields.addAll(await getMultipartFields(val: value));

  if (imageFile.validate().isNotEmpty) {
    multiPartRequest.files.addAll(await getMultipartImages(files: imageFile.validate(), name: PackageKey.packageAttachment));
    multiPartRequest.fields.putIfAbsent(AddServiceKey.attachmentCount, () => imageFile.validate().length.toString());
  }

  log("${multiPartRequest.fields}");

  multiPartRequest.headers.addAll(buildHeaderTokens());

  log("MultiPart Request : ${jsonEncode(multiPartRequest.fields)} ${multiPartRequest.files.map((e) => e.field + ": " + e.filename.validate())}");

  appStore.setLoading(true);

  await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
    appStore.setLoading(false);

    appStore.selectedServiceList.clear();
    log("Response: ${jsonDecode(temp)}");

    toast(jsonDecode(temp)['message'], print: true);
    finish(getContext, true);
  }, onError: (error) {
    toast(error.toString(), print: true);
    appStore.setLoading(false);
  }).catchError((e) {
    appStore.setLoading(false);
    toast(e.toString());
  });
}

Future<BaseResponseModel> deletePackage(int id) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('package-delete/$id', method: HttpMethod.POST)));
}
//endregion

//region Get Document API
Future<List<Documents>> getDocuments({int page = 1, List<Documents> documents = const [], Function(bool)? callback}) async {
  try {
    var res = DocumentListResponse.fromJson(await handleResponse(await buildHttpResponse('document-list?page=$page&per_page=$PER_PAGE_ITEM', method: HttpMethod.GET)));

    if (page == 1) documents.clear();
    documents.addAll(res.documents.validate());
    appStore.setLoading(false);

    callback?.call(res.documents.validate().length != PER_PAGE_ITEM);
  } catch (e) {
    appStore.setLoading(false);

    log(e);
    throw errorSomethingWentWrong;
  }

  return documents;
}

Future<BaseResponseModel> saveDoc({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('document-save', method: HttpMethod.POST, request: request)));
}

Future<BaseResponseModel> removeDoc(int id) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('document-delete/$id', request: {}, method: HttpMethod.POST)));
}

Future<BaseResponseModel> restoreDoc(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('document-action', request: request, method: HttpMethod.POST)));
}
//endregion

//region Get Coupon API
Future<List<CouponData>> getCoupons({int page = 1, List<CouponData> coupons = const [], Function(bool)? callback}) async {
  try {
    var res = CouponResponse.fromJson(await handleResponse(await buildHttpResponse('coupon-list?page=$page&per_page=$PER_PAGE_ITEM', method: HttpMethod.GET)));

    if (page == 1) coupons.clear();
    coupons.addAll(res.data.validate());
    appStore.setLoading(false);

    callback?.call(res.data.validate().length != PER_PAGE_ITEM);
  } catch (e) {
    appStore.setLoading(false);

    log(e);
    throw errorSomethingWentWrong;
  }

  return coupons;
}

Future<List<ServiceData>> getCouponService({required int id}) async {
  Iterable it = await handleResponse(await buildHttpResponse('get-coupon-service?coupon_id=$id', method: HttpMethod.GET));

  return it.map((e) => ServiceData.fromJson(e)).toList();
}

Future<BaseResponseModel> saveCoupon({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('coupon-save', method: HttpMethod.POST, request: request)));
}

Future<BaseResponseModel> removeCoupon(int id) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('coupon-delete/$id', request: {}, method: HttpMethod.POST)));
}

Future<BaseResponseModel> restoreCoupon(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('coupon-action', request: request, method: HttpMethod.POST)));
}
//endregion

//region Review API
Future<List<RatingData>> serviceReviews(Map request) async {
  ServiceReviewResponse res = ServiceReviewResponse.fromJson(await handleResponse(await buildHttpResponse('service-reviews?per_page=all', request: request, method: HttpMethod.POST)));
  return res.ratingList.validate();
}

Future<List<RatingData>> handymanReviews(Map request) async {
  ServiceReviewResponse res = ServiceReviewResponse.fromJson(await handleResponse(await buildHttpResponse('handyman-reviews?per_page=all', request: request, method: HttpMethod.POST)));
  return res.ratingList.validate();
}
//endregion

//region Remove Image API
Future<BaseResponseModel> deleteImage(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('remove-file', request: request, method: HttpMethod.POST)));
}
//endregion

//region Get User Type API
Future<UserTypeResponse> getUserType({String type = USER_TYPE_PROVIDER}) async {
  return UserTypeResponse.fromJson(await handleResponse(await buildHttpResponse('get-type-list?type=$type')));
}

Future<UserDetailResponse> getUserDetail(int id) async {
  return UserDetailResponse.fromJson(await handleResponse(await buildHttpResponse('user-detail?id=$id', method: HttpMethod.GET)));
}

//endregion

//region
Future<BaseResponseModel> sendPushNotification(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('send-push-notification', request: request, method: HttpMethod.POST)));
}
//endregion

//region Get Earning List , Save Provider Payout
Future<List<EarningModel>> getEarningList({int page = 1, List<EarningModel> earnings = const [], Function(bool)? callback}) async {
  try {
    Iterable it = await handleResponse(await buildHttpResponse('earning-list?page=$page&per_page=$PER_PAGE_ITEM', method: HttpMethod.GET));
    List<EarningModel> res = it.map((e) => EarningModel.fromJson(e)).toList();

    if (page == 1) earnings.clear();
    earnings.addAll(res.validate());
    appStore.setLoading(false);

    callback?.call(res.validate().length != PER_PAGE_ITEM);
  } catch (e) {
    appStore.setLoading(false);

    log(e);
    throw errorSomethingWentWrong;
  }

  return earnings;
}

Future<BaseResponseModel> providerPayout({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('providerpayout-save', method: HttpMethod.POST, request: request)));
}
//endregion

//region Post Job Request
Future<List<PostJobData>> getPostJobList(int page, {var perPage = PER_PAGE_ITEM, required List<PostJobData> postJobList, Function(bool)? lastPageCallback}) async {
  try {
    var res = PostJobResponse.fromJson(await handleResponse(await buildHttpResponse('get-post-job?per_page=$perPage&page=$page', method: HttpMethod.GET)));

    if (page == 1) {
      postJobList.clear();
    }

    lastPageCallback?.call(res.postJobData.validate().length != PER_PAGE_ITEM);

    postJobList.addAll(res.postJobData.validate());
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    log(e);
    throw errorSomethingWentWrong;
  }

  return postJobList;
}

Future<PostJobDetailResponse> getPostJobDetail(Map request) async {
  return PostJobDetailResponse.fromJson(await handleResponse(await buildHttpResponse('get-post-job-detail', request: request, method: HttpMethod.POST)));
}

Future<BaseResponseModel> saveBid(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-bid', request: request, method: HttpMethod.POST)));
}
//endregion

//region CommonFunctions
Future<Map<String, String>> getMultipartFields({required Map<String, dynamic> val}) async {
  Map<String, String> data = {};

  val.forEach((key, value) {
    data[key] = '$value';
  });

  return data;
}

Future<List<MultipartFile>> getMultipartImages({required List<File> files, required String name}) async {
  List<MultipartFile> multiPartRequest = [];

  await Future.forEach<File>(files, (element) async {
    int i = files.indexOf(element);

    multiPartRequest.add(await MultipartFile.fromPath('${'$name' + i.toString()}', element.path));
  });

  return multiPartRequest;
}
//endregion

//region (Provider Save,Handyman Save, User (DELETE, RESTORE, FORCEFULLY DELETE))
Future<void> saveUserData(UserData data) async {
  if (data.apiToken.validate().isNotEmpty) await appStore.setToken(data.apiToken.validate());
  await appStore.setLoggedIn(true);

  await appStore.setUserId(data.id.validate());
  await appStore.setFirstName(data.firstName.validate());
  await appStore.setLastName(data.lastName.validate());
  await appStore.setUserEmail(data.email.validate());
  await appStore.setUserName(data.username.validate());
  await appStore.setCountryId(data.countryId.validate());
  await appStore.setStateId(data.stateId.validate());
  await appStore.setCityId(data.cityId.validate());
  await appStore.setAddress(data.address.validate().isNotEmpty ? data.address.validate() : '');
  await appStore.setContactNumber('${data.contactNumber.validate()}');
  await appStore.setUserType(data.userType.validate());

  if (data.designation != null) await appStore.setDesignation(data.designation.validate());
  if (data.profileImage != null) await appStore.setUserProfile(data.profileImage.validate());
  if (data.serviceAddressId != null) await appStore.setServiceAddressId(data.serviceAddressId!);
}

Future<BaseResponseModel> removeUser(int id, {String type = USER_TYPE_PROVIDER}) async {
  String endPoint = 'provider-delete/$id';
  if (type == USER_TYPE_HANDYMAN) {
    endPoint = 'handyman-delete/$id';
  } else if (type == USER_TYPE_USER) {
    endPoint = 'user-delete/$id';
  }
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(endPoint, method: HttpMethod.POST)));
}

Future<BaseResponseModel> restoreUser(Map request, {String type = USER_TYPE_PROVIDER}) async {
  String endPoint = 'provider-action';
  if (type == USER_TYPE_HANDYMAN) {
    endPoint = 'handyman-action';
  } else if (type == USER_TYPE_USER) {
    endPoint = 'user-action';
  }
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(endPoint, method: HttpMethod.POST, request: request)));
}

//endregion

//region Taxes List API
Future<List<TaxData>> getTaxList({int page = 1, int perPage = PER_PAGE_ITEM, required List<TaxData> list, Function(bool)? lastPageCallback}) async {
  try {
    TaxListResponse res = TaxListResponse.fromJson(
      await (handleResponse(await buildHttpResponse('get-tax-list?page=$page&per_page=$perPage', method: HttpMethod.GET))),
    );

    if (page == 1) list.clear();
    list.addAll(res.taxData.validate());

    lastPageCallback?.call(res.taxData.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    log(e);
    throw errorSomethingWentWrong;
  }
  return list;
}

Future<BaseResponseModel> saveTax({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('tax-save', method: HttpMethod.POST, request: request)));
}

Future<BaseResponseModel> removeTax(int id) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('tax-delete/$id', request: {}, method: HttpMethod.POST)));
}

//endregion

//region Wallet
Future<List<WalletData>> getWalletList({int page = 1, var perPage = PER_PAGE_ITEM, List<WalletData> walletList = const [], Function(bool)? lastPageCallback}) async {
  try {
    var res = WalletListResponse.fromJson(await handleResponse(await buildHttpResponse('wallet-list?per_page=$perPage&page=$page', method: HttpMethod.GET)));

    if (page == 1) {
      walletList.clear();
    }

    lastPageCallback?.call(res.walletListData.validate().length != PER_PAGE_ITEM);

    walletList.addAll(res.walletListData.validate());
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    log(e);
    throw errorSomethingWentWrong;
  }

  return walletList;
}

Future<BaseResponseModel> saveWallet({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('wallet-save', method: HttpMethod.POST, request: request)));
}

Future<BaseResponseModel> removeWallet(int id) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('wallet-delete/$id', request: {}, method: HttpMethod.POST)));
}

//endregion

//region User Service Rating, HandymanRating
Future<List<RatingData>> ratings(int page, {var perPage = PER_PAGE_ITEM, required RatingType ratingType, Function(bool)? lastPageCallback}) async {
  try {
    String type = '';
    if (ratingType == RatingType.UserServiceRating) {
      type = USER_SERVICE_RATING;
    } else if (ratingType == RatingType.HandymanRating) {
      type = HANDYMAN_RATING;
    }

    ServiceReviewResponse res = ServiceReviewResponse.fromJson(await handleResponse(await buildHttpResponse('get-ratings-list?type=$type&per_page=$perPage', method: HttpMethod.GET)));

    appStore.setLoading(false);
    return res.ratingList.validate();
  } catch (e) {
    appStore.setLoading(false);
    log(e);
    throw errorSomethingWentWrong;
  }
}

Future<BaseResponseModel> removeRatings(int id, {required RatingType ratingType}) async {
  String type = '';
  if (ratingType == RatingType.UserServiceRating) {
    type = USER_SERVICE_RATING;
  } else if (ratingType == RatingType.HandymanRating) {
    type = HANDYMAN_RATING;
  }

  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('rating-delete/$id?type=$type', request: {}, method: HttpMethod.POST)));
}

//endregion

//region Logout API
Future<void> logoutApi() async {
  return await handleResponse(await buildHttpResponse('logout', method: HttpMethod.GET));
}

Future<void> clearPreferences() async {
  await appStore.setFirstName('');
  await appStore.setLastName('');
  if (!getBoolAsync(IS_REMEMBERED)) await appStore.setUserEmail('');
  await appStore.setUserName('');
  await appStore.setContactNumber('');
  await appStore.setCountryId(0);
  await appStore.setStateId(0);
  await appStore.setCityId(0);
  await appStore.setUId('');
  await appStore.setToken('');
  await appStore.setCurrencySymbol('');
  await appStore.setLoggedIn(false);
  await appStore.setTester(false);
}

Future<void> logout(BuildContext context) async {
  showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    builder: (_) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(logout_logo, width: context.width(), fit: BoxFit.cover),
              32.height,
              Text(locale.ohNoYourAreLeaving, style: boldTextStyle(size: 20)),
              16.height,
              Text(locale.doYouWantToLogout, style: secondaryTextStyle()),
              28.height,
              Row(
                children: [
                  AppButton(
                    child: Text(locale.no, style: boldTextStyle()),
                    color: context.cardColor,
                    elevation: 0,
                    onTap: () {
                      finish(context);
                    },
                  ).expand(),
                  16.width,
                  AppButton(
                    child: Text(locale.yes, style: boldTextStyle(color: white)),
                    color: primaryColor,
                    elevation: 0,
                    onTap: () async {
                      if (await isNetworkAvailable()) {
                        appStore.setLoading(true);
                        await logoutApi().then((value) async {}).catchError((e) {
                          appStore.setLoading(false);
                          toast(e.toString());
                        });

                        appStore.setLoading(false);

                        await clearPreferences();

                        SignInScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                      } else {
                        toast(errorInternetNotAvailable);
                      }
                    },
                  ).expand(),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 24),
          Observer(builder: (_) => LoaderWidget().withSize(width: 60, height: 60).visible(appStore.isLoading)),
        ],
      );
    },
  );
}

//endregion
