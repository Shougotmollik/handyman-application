import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String planAboutToExpire(int days);

  String get appName;

  String get provider;

  String get handyman;

  String get firstName;

  String get lastName;

  String get contactNumber;

  String get emailAddress;

  String get userName;

  String get rememberMe;

  String get camera;

  String get appTheme;

  String get bookingHistory;

  String get logout;

  String get chooseAppTheme;

  String get reviews;

  String get noDataFound;

  String get pending;

  String get notAvailable;

  String get gallery;

  String get paymentStatus;

  String get paymentMethod;

  String get category;

  String get yes;

  String get no;

  String get reason;

  String get viewAll;

  String get revenue;

  String get addHandyman;

  String get bookings;

  String get totalBookings;

  String get totalServices;

  String get totalEarnings;

  String get payments;

  String get bookingId;

  String get paymentId;

  String get amount;

  String get addService;

  String get serviceName;

  String get selectCategory;

  String get selectType;

  String get selectStatus;

  String get price;

  String get discount;

  String get duration;

  String get description;

  String get setAsFeature;

  String get add;

  String get chooseImage;

  String get handymanList;

  String get time;

  String get allService;

  String get selectServiceAddresses;

  String get save;

  String get update;

  String get edit;

  String get delete;

  String get services;

  String get editService;

  String get noteYouCanUpload;

  String get durationHours;

  String get durationMinute;

  String get passwordLengthShouldBe;

  String get password;

  String get thisFieldIsRequired;

  String get demoUserCannotBe;

  String get selectDocument;

  String get addDocument;

  String get appSettings;

  String get rateUs;

  String get privacyPolicy;

  String get v;

  String get about;

  String get providerType;

  String get taxes;

  String get helloAgain;

  String get welcomeBackYouHave;

  String get login;

  String get hour;

  String get rating;

  String get off;

  String get hr;

  String get date;

  String get aboutHandyman;

  String get aboutCustomer;

  String get paymentDetail;

  String get id;

  String get method;

  String get status;

  String get priceDetail;

  String get subTotal;

  String get tax;

  String get coupon;

  String get totalAmount;

  String get onBasisOf;

  String get checkStatus;

  String get pressBackAgainToExitApp;

  String get address;

  String get type;

  String get handymanType;

  String get hello;

  String get welcomeBack;

  String get newBooking;

  String get noReviewYet;

  String get memberSince;

  String get deleteAddress;

  String get restore;

  String get forceDelete;

  String get noDescriptionAvailable;

  String get faqs;

  String get ohNoYourAreLeaving;

  String get doYouWantToLogout;

  String get searchHere;

  String get pleaseSelectedCategory;

  String get enterHoursUpTo24Hours;

  String get enterMinuteUpTo60Minute;

  String get selectSubcategory;

  String get serviceProof;

  String get title;

  String get noServiceRatings;

  String get email;

  String get selectUserType;

  String get serviceTotalTime;

  String get designation;

  String get doYouWantToRestore;

  String get doYouWantToDeleteForcefully;

  String get doYouWantToDelete;

  String get pleaseEnterContactNumber;

  String get aboutProvider;

  String get addCategory;

  String get name;

  String get users;

  String get selectProvider;

  String get addSubCategory;

  String get pushNotificationSettings;

  String get all;

  String get service;

  String get selectNotificationType;

  String get commission;

  String get availableAt;

  String get chooseAtLeastOneImage;

  String get providerPayoutList;

  String get addProviderType;

  String get editProviderType;

  String get handymanPayoutList;

  String get documents;

  String get documentName;

  String get documentRequired;

  String get updateDocument;

  String get required;

  String get dashboard;

  String get newProvider;

  String get total;

  String get couponCode;

  String get discountType;

  String get coupons;

  String get expDate;

  String get providerName;

  String get payoutList;

  String get providerDocumentList;

  String get addProviderDocument;

  String get updateProviderDocument;

  String get verified;

  String get categoryList;

  String get serviceList;

  String get addProvider;

  String get providerList;

  String get providerTypeList;

  String get booking;

  String get handymanTypeList;

  String get payment;

  String get document;

  String get documentList;

  String get couponList;

  String get addCoupon;

  String get earning;

  String get settings;

  String get subCategory;

  String get language;

  String get pendingProvider;

  String get pendingHandyman;

  String get light;

  String get dark;

  String get systemDefault;

  String get thisActionWillRestart;

  String get enableMaterialYouTheme;

  String get pleaseSelectProperDate;

  String get latitude;

  String get longitude;

  String get chooseDocument;

  String get typeName;

  String get addHandymanType;

  String get editHandymanType;

  String get adminEarning;

  String get providerEarning;

  String get payout;

  String get addProviderPayout;

  String get selectMethod;

  String get newUser;

  String get chooseFromMap;

  String get getLocation;

  String get setAddress;

  String get pickAddress;

  String get pickAService;

  String get message;

  String get myEarning;

  String get earningDetails;

  String get thisServiceIsNotAvailable;

  String get selectedService;

  String get pleaseSelectProvider;

  String get pleaseSelectServiceAddress;

  String get youCanTUpdateDeleted;

  String get successfullyDeleted;

  String get successfullyRestored;

  String get successfullyForcefullyDeleted;

  String get pleaseChooseDocument;

  String get selectedProvider;

  String get pickAProvider;

  String get pleaseSelectAProvider;

  String get aboutApp;

  String get termsConditions;

  String get helpSupport;

  String get shareApp;

  String get purchaseCode;

  String get share;

  String get withYourFriends;

  String get send;

  String get free;

  String get jobRequestList;

  String get totalCharges;

  String get extraCharges;

  String get postJobTitle;

  String get postJobDescription;

  String get jobPrice;

  String get estimatedPrice;

  String get providerDetails;

  String get cancel;

  String get accept;

  String get internetNotAvailable;

  String get pleaseTryAgain;

  String get somethingWentWrong;

  String get chooseAction;

  String get removeImage;

  String get categoryBasedPackage;

  String get enable;

  String get disable;

  String get categoryBasedPackageEnableMessage;

  String get doYouWantTo;

  String get includedInThisPackage;

  String get packageServicesWillAppearHere;

  String get showingFixPriceServicesMessage;

  String get noServiceFound;

  String get pleaseSelectTheCategory;

  String get selectService;

  String get packageDescription;

  String get package;

  String get packages;

  String get packageNotAvailable;

  String get featureProduct;

  String get packageName;

  String get packagePrice;

  String get areYouSureWantToDeleteThe;

  String get packageService;

  String get youWillGetTheseServicesWithThisPackage;

  String get startDate;

  String get endDate;

  String get pleaseSelectService;

  String get pleaseSelectImages;

  String get pleaseEnterTheEndDate;

  String get editPackage;

  String get addPackage;

  String get lblTokenExpired;

  String get badRequest;

  String get forbidden;

  String get pageNotFound;

  String get tooManyRequests;

  String get internalServerError;

  String get badGateway;

  String get serviceUnavailable;

  String get gatewayTimeout;

  String get reload;

  String get noCategoryFound;

  String get noSubCategoryFound;

  String get isNotValid;

  String get noEarningFound;

  String get noServiceSubTitle;

  String get noBookingFound;

  String get noTypeListFound;

  String get noPaymentFound;

  String get noDocumentListFound;

  String get noDocumentListSubTitle;

  String get documentNotRequired;

  String get noCouponFound;

  String get helplineNumber;

  String get noPayoutFound;

  String get noAddressFound;

  String get noDocumentFound;

  String get noPostJobFound;

  String get onGoing;

  String get inProgress;

  String get hold;

  String get cancelled;

  String get rejected;

  String get failed;

  String get completed;

  String get pendingApproval;

  String get waiting;

  String get requested;

  String get accepted;

  String get assigned;

  String get noBookingSubTitle;

  String get hourly;

  String get locationPermissionsDenied;

  String get locationPermissionsDeniedPermanently;

  String get locationServicesEnabled;

  String get postJob;

  String get at;

  String get serviceRemoveMessage;

  String get selectProviderMessage;

  String get by;

  String get paid;

  String get advancePaid;

  String get enablePrePayment;

  String get enablePrePaymentMessage;

  String get advancePayAmountPer;

  String get valueConditionMessage;

  String get advancePayment;

  String get remainingAmount;

  String get withExtraAndAdvanceCharge;

  String get paymentHistory;

  String get active;

  String get inactive;

  String get lblHourly;

  String get fixed;

  String get percentage;

  String get cash;

  String get bank;

  String get wallet;

  String get selectDuration;

  String get priceAmountValidationMessage;

  String get pendingByAdmin;

  String get noTaxesFound;

  String get myTax;

  String get taxName;

  String get value;

  String get addTax;

  String get enterValidCommissionValue;

  String get totalProviders;

  String get totalExtraCharges;

  String get transactionId;

  String get appliedTaxes;

  String get walletList;

  String get noWalletListFound;

  String get credit;

  String get addWallet;

  String get updateTax;

  String get noRatingFoundYet;

  String get userServiceRatings;

  String get handymanRatings;

  String get ratings;

  String get transactions;

  String get digitalService;

  String get digitalServiceSwitchSubText;

  String get filterBy;

  String get clearFilter;

  String get bookingStatus;

  String get apply;

  String get filterAtLeastOneBookingStatusToast;

  String get customerName;

  String get serviceVisitType;

  String get thisServiceIsOnlineRemote;

  String get visitOption;

  String get onSiteVisit;

  String get onlineRemoteService;
}
