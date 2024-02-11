import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_admin_flutter/app_theme.dart';
import 'package:handyman_admin_flutter/screens/packages/select_service_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_widgets.dart';
import '../../components/custom_image_picker.dart';
import '../../main.dart';
import '../../model/Package_response.dart';
import '../../model/attachment_model.dart';
import '../../model/provider_address_mapping_model.dart';
import '../../model/service_model.dart';
import '../../model/static_data_model.dart';
import '../../model/user_data.dart';
import '../../networks/rest_apis.dart';
import '../../utils/common.dart';
import '../../utils/constant.dart';
import '../../utils/model_keys.dart';
import '../user/user_list_screen.dart';
import 'components/selected_service_component.dart';

class AddPackageScreen extends StatefulWidget {
  final PackageData? data;

  AddPackageScreen({this.data});

  @override
  _AddPackageScreenState createState() => _AddPackageScreenState();
}

class _AddPackageScreenState extends State<AddPackageScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UniqueKey uniqueKey = UniqueKey();

  TextEditingController packageNameCont = TextEditingController();
  TextEditingController packagePriceCont = TextEditingController();
  TextEditingController packageDescriptionCont = TextEditingController();
  TextEditingController startDateCont = TextEditingController();
  TextEditingController endDateCont = TextEditingController();

  FocusNode packagePriceFocus = FocusNode();
  FocusNode packageDescriptionFocus = FocusNode();
  FocusNode startDateFocus = FocusNode();
  FocusNode endDateFocus = FocusNode();

  List<File> imageFiles = [];
  List<Attachments> tempAttachments = [];
  List<int> selectedService = [];

  List<StaticDataModel> statusListStaticData = [
    StaticDataModel(key: SERVICE_TYPE_ACTIVE, value: locale.active),
    StaticDataModel(key: SERVICE_TYPE_INACTIVE, value: locale.inactive),
  ];

  StaticDataModel? packageStatusModel;

  String packageStatus = '';
  int? selectedCategoryId = -1;
  int? selectedSubCategoryId = -1;

  DateTime currentDateTime = DateTime.now();
  DateTime? selectedDate;
  DateTime? finalDate;
  TimeOfDay? pickedTime;

  bool isFeature = false;
  bool isUpdate = false;
  String? isPackageTypeSingleCategory;
  UserData? selectedProvider;
  int? selectedProviderId;
  List<ProviderAddressMapping> serviceAddressList = [];
  ServiceData serviceDetail = ServiceData();
  List<int> selectedAddress = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isUpdate = widget.data != null;

    if (isUpdate) {
      appStore.selectedServiceList.clear();
      appStore.addAllSelectedPackageService(widget.data!.serviceList.validate());

      tempAttachments = widget.data!.attchments.validate();
      imageFiles = widget.data!.attchments.validate().map((e) => File(e.url.toString())).toList();
      packageNameCont.text = widget.data!.name.validate();
      packageDescriptionCont.text = widget.data!.description.validate();
      packagePriceCont.text = widget.data!.price.toString().validate();
      startDateCont.text = widget.data!.startDate != null ? formatDate(widget.data!.startDate.validate(), format: DATE_FORMAT_7).toString() : "";
      endDateCont.text = widget.data!.endDate != null ? formatDate(widget.data!.endDate.validate(), format: DATE_FORMAT_7).toString() : "";
      isFeature = widget.data!.isFeatured == 1 ? true : false;
      packageStatus = widget.data!.status.validate() == 1 ? SERVICE_TYPE_ACTIVE : SERVICE_TYPE_INACTIVE;
      if (packageStatus == SERVICE_TYPE_ACTIVE) {
        packageStatusModel = statusListStaticData.first;
      } else {
        packageStatusModel = statusListStaticData[1];
      }
      selectedCategoryId = widget.data!.categoryId != null ? widget.data!.categoryId : selectedCategoryId;
      selectedSubCategoryId = widget.data!.subCategoryId != null ? widget.data!.subCategoryId : selectedSubCategoryId;

      isPackageTypeSingleCategory = widget.data!.packageType.validate() == PACKAGE_TYPE_SINGLE ? PACKAGE_TYPE_SINGLE : PACKAGE_TYPE_MULTIPLE;

      getProvider();
    } else {
      appStore.selectedServiceList.clear();
      packageStatus = statusListStaticData.first.key!;
    }

    setState(() {});
  }

  // region Select Start Date and End Date
  void selectDateAndTime(BuildContext context, TextEditingController textEditingController, DateTime? abc) async {
    await showDatePicker(
      context: context,
      initialDate: abc ?? currentDateTime,
      firstDate: abc ?? currentDateTime,
      lastDate: currentDateTime.add(30.days),
      locale: Locale(appStore.selectedLanguageCode),
      builder: (_, child) {
        return Theme(
          data: appStore.isDarkMode ? ThemeData.dark() : AppTheme.lightTheme(),
          child: child!,
        );
      },
    ).then((date) async {
      if (date != null) {
        finalDate = DateTime(date.year, date.month, date.day);

        selectedDate = date;
        textEditingController.text = "${formatDate(selectedDate.toString(), format: DATE_FORMAT_7)}";
        setState(() {});
      }
    });
  }

  // endregion

  // region Remove Attachment

  Future<void> removeAttachment({required int id}) async {
    appStore.setLoading(true);

    Map req = {
      CommonKeys.type: PackageKey.removePackageAttachment,
      CommonKeys.id: id,
    };

    await deleteImage(req).then((value) {
      tempAttachments.validate().removeWhere((element) => element.id == id);

      uniqueKey = UniqueKey();

      setState(() {});

      appStore.setLoading(false);
      toast(value.message.validate(), print: true);
    }).catchError((e) {
      appStore.setLoading(false);
      finish(context);
      toast(e.toString(), print: true);
    });
  }

  // endregion

  // region Action
  Future checkValidation() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      selectedService.clear();

      if (selectedProvider == null) {
        return toast(locale.pleaseSelectProvider);
      }

      if (appStore.selectedServiceList.isNotEmpty) {
        appStore.selectedServiceList.forEach((element) {
          selectedService.add(element.id.validate());
        });
      }

      if (imageFiles.isEmpty || selectedService.isEmpty) {
        if (selectedService.isEmpty) {
          return toast(locale.pleaseSelectService);
        } else if (imageFiles.isEmpty) {
          return toast(locale.pleaseSelectImages);
        }
      }

      if (startDateCont.text.validate().isNotEmpty && endDateCont.text.validate().isEmpty) {
        return toast(locale.pleaseEnterTheEndDate);
      }

      String serviceId = "";

      if (selectedService.isNotEmpty) {
        for (var i in selectedService) {
          if (i == selectedService.last) {
            serviceId = serviceId + i.toString();
          } else {
            serviceId = serviceId + i.toString() + ",";
          }
        }
      } else {
        return toast(locale.pleaseSelectService);
      }

      Map<String, dynamic> req = {
        PackageKey.packageId: widget.data != null
            ? widget.data!.id.validate() != 0
                ? widget.data!.id.validate()
                : null
            : null,
        PackageKey.name: packageNameCont.text.validate(),
        PackageKey.description: packageDescriptionCont.text.validate(),
        PackageKey.price: packagePriceCont.text.validate(),
        PackageKey.startDate: startDateCont.text.validate(),
        PackageKey.endDate: endDateCont.text.validate(),
        if (selectedCategoryId != -1) PackageKey.categoryId: selectedCategoryId,
        if (selectedSubCategoryId != -1) PackageKey.subCategoryId: selectedSubCategoryId,
        PackageKey.isFeatured: isFeature ? '1' : '0',
        PackageKey.status: packageStatus.validate() == SERVICE_TYPE_ACTIVE ? '1' : '0',
        PackageKey.serviceId: serviceId,
        PackageKey.packageType: isPackageTypeSingleCategory,
        PackageKey.providerId: selectedProviderId,
      };

      addPackageMultiPart(value: req, imageFile: imageFiles.where((element) => !element.path.contains('http')).toList()).then((value) {
        //
      }).catchError((e) {
        toast(e.toString());
      });
    }
  }

  // endregion

  void pickProvider() async {
    UserData? user = await UserListScreen(type: USER_TYPE_PROVIDER, pickUser: true).launch(context);

    if (user != null) {
      selectedProvider = user;
      selectedProviderId = user.id.validate();
      setState(() {});
    }
  }

  ///TODO after get providerId in all package list object, logic change(if get providerId directly call here from API)
  void getProvider() async {
    await getUserDetail(widget.data!.providerId.validate()).then((value) {
      UserData? user = value.userData;
      if (user != null) {
        selectedProvider = user;
        selectedProviderId = user.id.validate();
        setState(() {});
      }
    }).catchError(onError);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        isUpdate ? locale.editPackage : locale.addPackage,
        textColor: white,
        color: context.primaryColor,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 90),
            child: Column(
              children: [
                CustomImagePicker(
                  key: uniqueKey,
                  onRemoveClick: (value) {
                    if (tempAttachments.validate().isNotEmpty && imageFiles.isNotEmpty) {
                      showConfirmDialogCustom(
                        context,
                        dialogType: DialogType.DELETE,
                        onAccept: (p0) {
                          imageFiles.removeWhere((element) => element.path == value);
                          if (value.startsWith('http')) {
                            removeAttachment(id: tempAttachments.validate().firstWhere((element) => element.url == value).id.validate());
                          }
                        },
                      );
                    } else {
                      showConfirmDialogCustom(
                        context,
                        dialogType: DialogType.DELETE,
                        onAccept: (p0) {
                          imageFiles.removeWhere((element) => element.path == value);
                          if (isUpdate) {
                            uniqueKey = UniqueKey();
                          }
                          setState(() {});
                        },
                      );
                    }
                  },
                  selectedImages: widget.data != null ? imageFiles.validate().map((e) => e.path.validate()).toList() : null,
                  onFileSelected: (List<File> files) async {
                    imageFiles = files;
                    setState(() {});
                  },
                ),
                8.height,
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: radius(),
                    backgroundColor: context.cardColor,
                  ),
                  child: Wrap(
                    runSpacing: 16,
                    children: [
                      Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            8.height,
                            AppTextField(
                              controller: packageNameCont,
                              textFieldType: TextFieldType.NAME,
                              nextFocus: packageDescriptionFocus,
                              errorThisFieldRequired: locale.thisFieldIsRequired,
                              decoration: inputDecoration(context, hint: locale.packageName, fillColor: context.scaffoldBackgroundColor),
                            ),
                            24.height,
                            Container(
                              width: context.width(),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(16),
                              decoration: boxDecorationWithRoundedCorners(backgroundColor: context.scaffoldBackgroundColor),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (selectedProvider != null)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(locale.selectedProvider, style: boldTextStyle(size: 14)).paddingOnly(bottom: 8),
                                        Text(
                                          selectedProvider!.displayName.validate(),
                                          style: secondaryTextStyle(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ).expand(),
                                  TextButton(
                                    onPressed: () async {
                                      pickProvider();
                                    },
                                    child: Text(
                                      locale.pickAProvider,
                                      style: boldTextStyle(size: 14, color: context.primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            24.height,
                            Observer(builder: (context) {
                              return Container(
                                width: context.width(),
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                                decoration: boxDecorationWithRoundedCorners(backgroundColor: context.scaffoldBackgroundColor),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(locale.selectService, style: secondaryTextStyle()).paddingSymmetric(horizontal: 16, vertical: 12),
                                        TextButton(
                                          child: Text(appStore.selectedServiceList.isNotEmpty ? locale.edit : locale.addService, style: boldTextStyle(size: 14, color: context.primaryColor)),
                                          onPressed: () async {
                                            if (selectedProvider == null) {
                                              return toast(locale.selectProviderMessage);
                                            }

                                            Map? res = await SelectServiceScreen(
                                              categoryId: selectedCategoryId,
                                              subCategoryId: selectedSubCategoryId,
                                              isUpdate: widget.data != null ? true : false,
                                              packageData: widget.data,
                                              providerId: selectedProvider!.id,
                                            ).launch(context);

                                            if (res != null && res["categoryId"] != null) {
                                              selectedCategoryId = res["categoryId"];

                                              if (res["subCategoryId"] != null) {
                                                selectedSubCategoryId = res["subCategoryId"];
                                              }

                                              if (res["packageType"] != null) {
                                                isPackageTypeSingleCategory = res["packageType"];
                                              }
                                            }
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                    if (appStore.selectedServiceList.isNotEmpty) SelectedServiceComponent()
                                  ],
                                ),
                              );
                            }),
                            24.height,
                            AppTextField(
                              controller: packageDescriptionCont,
                              textFieldType: TextFieldType.MULTILINE,
                              focus: packageDescriptionFocus,
                              nextFocus: packagePriceFocus,
                              minLines: 3,
                              maxLines: 5,
                              errorThisFieldRequired: locale.thisFieldIsRequired,
                              decoration: inputDecoration(context, hint: locale.packageDescription, fillColor: context.scaffoldBackgroundColor),
                              validator: (value) {
                                if (value!.isEmpty) return locale.thisFieldIsRequired;
                                return null;
                              },
                            ),
                            24.height,
                            Row(
                              children: [
                                AppTextField(
                                  controller: packagePriceCont,
                                  textFieldType: TextFieldType.NUMBER,
                                  focus: packagePriceFocus,
                                  decoration: inputDecoration(
                                    context,
                                    hint: locale.packagePrice,
                                    fillColor: context.scaffoldBackgroundColor,
                                    prefixIcon: Text(appStore.currencySymbol, style: primaryTextStyle(size: 16), textAlign: TextAlign.center).paddingOnly(top: 12, left: 8, right: 8),
                                  ),
                                  validator: (s) {
                                    if (s!.isEmpty) return errorThisFieldRequired;

                                    if (s.toDouble() <= 0) return locale.priceAmountValidationMessage;
                                    return null;
                                  },
                                ).expand(),
                                16.width,
                                DropdownButtonFormField<StaticDataModel>(
                                  dropdownColor: context.scaffoldBackgroundColor,
                                  value: packageStatusModel != null ? packageStatusModel : statusListStaticData.first,
                                  items: statusListStaticData.map((StaticDataModel data) {
                                    return DropdownMenuItem<StaticDataModel>(
                                      value: data,
                                      child: Text(data.value.validate(), style: primaryTextStyle()),
                                    );
                                  }).toList(),
                                  decoration: inputDecoration(
                                    context,
                                    fillColor: context.scaffoldBackgroundColor,
                                    hint: locale.status,
                                  ),
                                  onTap: () {
                                    hideKeyboard(context);
                                  },
                                  onChanged: (StaticDataModel? value) async {
                                    packageStatus = value!.key.validate();
                                    setState(() {});
                                  },
                                  validator: (value) {
                                    if (value == null) return errorThisFieldRequired;
                                    return null;
                                  },
                                ).expand(),
                              ],
                            ),
                            24.height,
                            Row(
                              children: [
                                AppTextField(
                                  controller: startDateCont,
                                  textFieldType: TextFieldType.OTHER,
                                  focus: startDateFocus,
                                  decoration: inputDecoration(context, hint: locale.startDate, fillColor: context.scaffoldBackgroundColor),
                                  isValidationRequired: false,
                                  onTap: () {
                                    hideKeyboard(context);
                                    selectDateAndTime(context, startDateCont, currentDateTime);
                                    endDateCont.text = "";
                                    setState(() {});
                                  },
                                ).expand(),
                                16.width,
                                AppTextField(
                                  controller: endDateCont,
                                  textFieldType: TextFieldType.OTHER,
                                  focus: endDateFocus,
                                  decoration: inputDecoration(context, hint: locale.endDate, fillColor: context.scaffoldBackgroundColor),
                                  isValidationRequired: false,
                                  onTap: () {
                                    hideKeyboard(context);
                                    selectDateAndTime(context, endDateCont, selectedDate);
                                  },
                                ).expand(),
                              ],
                            ),
                            24.height,
                            Container(
                              decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor, borderRadius: radius()),
                              padding: EdgeInsets.only(left: 16, right: 4),
                              child: Theme(
                                data:  ThemeData(
                                  unselectedWidgetColor: appStore.isDarkMode ? context.dividerColor: context.iconColor,
                                ),
                                child: CheckboxListTile(
                                  checkboxShape: RoundedRectangleBorder(borderRadius: radius(4)),
                                  autofocus: false,
                                  activeColor: context.primaryColor,
                                  checkColor: appStore.isDarkMode ? context.iconColor : context.cardColor,
                                  value: isFeature,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(locale.setAsFeature, style: secondaryTextStyle()),
                                  onChanged: (bool? v) {
                                    isFeature = v.validate();
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            left: 16,
            bottom: 16,
            child: AppButton(
              text: locale.save,
              height: 40,
              color: context.primaryColor,
              textStyle: boldTextStyle(color: white),
              width: context.width() - context.navigationBarHeight,
              onTap: () {
                //ifNotTester(context, () {
                checkValidation();
                // });
              },
            ),
          ),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
