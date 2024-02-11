import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/user_data.dart';
import 'package:handyman_admin_flutter/model/user_type_response.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/handyman/handyman_payout_list_screen.dart';
import 'package:handyman_admin_flutter/screens/provider/provider_address_list_screen.dart';
import 'package:handyman_admin_flutter/screens/provider/provider_document_list.dart';
import 'package:handyman_admin_flutter/screens/provider/provider_payout_list_screen.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../model/provider_address_mapping_model.dart';
import '../../utils/colors.dart';

class AddUpdateUserScreen extends StatefulWidget {
  final String? userType;
  final String? status;
  final String? title;
  final UserData? userData;
  final Function? onUpdate;

  AddUpdateUserScreen({required this.userType, this.status, this.title, this.userData, this.onUpdate});

  @override
  _AddUpdateUserScreenState createState() => _AddUpdateUserScreenState();
}

class _AddUpdateUserScreenState extends State<AddUpdateUserScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController designationCont = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode userTypeFocus = FocusNode();
  FocusNode typeFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode designationFocus = FocusNode();
  FocusNode addressFocus = FocusNode();

  String selectedStatus = ACTIVE;

  List<UserTypeData> userTypeList = [];
  UserTypeData? selectedUserTypeData;

  List<ProviderAddressMapping> serviceAddressList = [];
  ProviderAddressMapping? selectedServiceAddress;

  List<UserData> providerList = [];
  UserData? selectedProvider;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.userData != null) {
      fNameCont.text = widget.userData!.firstName.validate();
      lNameCont.text = widget.userData!.lastName.validate();
      userNameCont.text = widget.userData!.username.validate();
      emailCont.text = widget.userData!.email.validate();
      mobileCont.text = widget.userData!.contactNumber.validate();
      addressCont.text = widget.userData!.address.validate();
      designationCont.text = widget.userData!.designation.validate();
      passwordCont.text = widget.userData!.password.validate();
      selectedStatus = widget.userData!.status.validate() == 1 ? ACTIVE : IN_ACTIVE;
    }
    getUserTypeList();

    setState(() {});

    if (widget.userType == USER_TYPE_HANDYMAN) {
      /// Get Provider List
      getUser(userType: USER_TYPE_PROVIDER, userdata: []).then((value) async {
        providerList = value.validate();
        if (widget.userData != null) {
          if (providerList.any((element) => element.id == widget.userData!.providerId)) {
            selectedProvider = providerList.firstWhere((element) => element.id == widget.userData!.providerId);
          }
        }

        await getProviderAddressData();

        if (widget.userData != null) {
          if (serviceAddressList.any((element) => element.id == widget.userData!.serviceAddressId)) {
            selectedServiceAddress = serviceAddressList.firstWhere((element) => element.id == widget.userData!.serviceAddressId);
          }
        }
        setState(() {});
      });
    }
  }

  void getUserTypeList() async {
    getUserType(type: widget.userType.validate()).then((value) async {
      if (value.userTypeData.validate().isNotEmpty) {
        userTypeList = value.userTypeData.validate();

        try {
          if (widget.userType == USER_TYPE_PROVIDER && widget.userData!.providertypeId != null) {
            selectedUserTypeData = userTypeList.firstWhere((element) => element.id == widget.userData!.providertypeId, orElse: null);
          }

          if (widget.userType == USER_TYPE_HANDYMAN && widget.userData!.handymanTypeId != null) {
            selectedUserTypeData = userTypeList.firstWhere((element) => element.id == widget.userData!.handymanTypeId, orElse: null);
          }
        } catch (e) {
          print(e);
        } finally {
          setState(() {});
        }
      }
    }).catchError((e) {
      log(e.toString());
    });
  }

  Future<void> getProviderAddressData() async {
    if (selectedProvider != null) {
      selectedServiceAddress = null;
      await getProviderAddress(id: selectedProvider!.id!, providerAddress: serviceAddressList).then((value) {
        serviceAddressList = value;
      }).catchError(onError);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  //region Methods
  void saveUser() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      if (widget.userType == USER_TYPE_PROVIDER || widget.userType == USER_TYPE_HANDYMAN) {
        if (selectedUserTypeData == null) return toast('Please Select UserType');
      }

      if (selectedProvider == null && widget.userType == USER_TYPE_HANDYMAN) return toast(locale.pleaseSelectProvider);
      if (selectedServiceAddress == null && widget.userType == USER_TYPE_HANDYMAN) return toast(locale.pleaseSelectServiceAddress);

      Map request = {
        CommonKeys.id: widget.userData != null ? widget.userData!.id : null,
        UserKeys.firstName: fNameCont.text.trim(),
        UserKeys.lastName: lNameCont.text.trim(),
        UserKeys.userName: userNameCont.text.trim(),
        UserKeys.userType: widget.userType,
        UserKeys.status: selectedStatus == ACTIVE ? 1 : 0,
        UserKeys.contactNumber: mobileCont.text.trim(),
        UserKeys.email: emailCont.text.trim(),
        UserKeys.designation: designationCont.text.trim(),
        UserKeys.address: addressCont.text.trim(),
        "display_name": '${fNameCont.text.trim() + ' ' + lNameCont.text.trim()}',
      };

      if (widget.userData == null) {
        request.putIfAbsent(UserKeys.password, () => passwordCont.text.trim());
      }

      if (widget.userType == USER_TYPE_PROVIDER) {
        request.putIfAbsent(UserKeys.providerTypeId, () => selectedUserTypeData!.id.toString());
      } else if (widget.userType == USER_TYPE_HANDYMAN) {
        request.putIfAbsent(UserKeys.handymanTypeId, () => selectedUserTypeData!.id.toString());
        request.putIfAbsent(UserKeys.serviceAddressId, () => selectedServiceAddress!.id);
        request.putIfAbsent(UserKeys.providerId, () => selectedProvider!.id);
      }

      appStore.setLoading(true);

      await registerUser(request, isRegister: widget.userData == null).then((value) async {
        value.data!.password = passwordCont.text.trim();
        value.data!.userType = widget.userType;
        appStore.setLoading(false);
        toast(value.message);

        finish(context, true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString(), print: true);
      });
    }
  }

  //endregion

  /// Delete User By User Type
  Future<void> deleteUser(int? id) async {
    appStore.setLoading(true);
    await removeUser(id.validate()).then((value) {
      appStore.setLoading(false);

      finish(context, true);
      toast(locale.successfullyDeleted);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// Restore User By User Type
  Future<void> restoreUserData() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.userData!.id,
      type: RESTORE,
    };

    await restoreUser(req).then((value) {
      appStore.setLoading(false);

      toast(locale.successfullyRestored);
      finish(context, true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// ForceFully Delete User By User Type
  Future<void> forceUserData() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.userData!.id,
      type: FORCE_DELETE,
    };

    await restoreUser(req).then((value) {
      appStore.setLoading(false);

      toast(locale.successfullyForcefullyDeleted);
      finish(context, true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  //region Widgets
  Widget providerNameAndAddress() {
    return Column(
      children: [
        DropdownButtonFormField<UserData>(
          decoration: inputDecoration(
            context,
            hint: locale.selectProvider,
          ),
          isExpanded: true,
          dropdownColor: context.cardColor,
          value: selectedProvider != null ? selectedProvider : null,
          items: providerList.map((data) {
            return DropdownMenuItem<UserData>(
              value: data,
              child: Text(
                data.displayName.validate(),
                style: primaryTextStyle(),
              ),
            );
          }).toList(),
          onChanged: (UserData? value) async {
            selectedProvider = value;

            await getProviderAddressData();

            setState(() {});
          },
        ),
        16.height,
        if (serviceAddressList.isNotEmpty)
          Column(
            children: [
              DropdownButtonFormField<ProviderAddressMapping>(
                decoration: inputDecoration(
                  context,
                  hint: locale.address,
                ),
                isExpanded: true,
                dropdownColor: context.cardColor,
                value: selectedServiceAddress,
                items: serviceAddressList.map((data) {
                  return DropdownMenuItem<ProviderAddressMapping>(
                    value: data,
                    child: Text(
                      data.address.validate(),
                      style: primaryTextStyle(),
                    ),
                  );
                }).toList(),
                onChanged: (ProviderAddressMapping? value) async {
                  selectedServiceAddress = value;
                  setState(() {});
                },
              ),
              16.height,
            ],
          ),
      ],
    );
  }

  String get getTitle => '${widget.userData != null ? locale.update : locale.add} ${widget.userType.capitalizeFirstLetter()}';

  Widget buildInnerItem({required VoidCallback onPressed, required Widget icon, required String title, EdgeInsetsGeometry? margin}) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: boxDecorationWithRoundedCorners(
          backgroundColor: context.cardColor,
          borderRadius: radius(),
        ),
        child: Column(
          children: [
            icon,
            8.height,
            Marquee(child: Text(title, style: secondaryTextStyle(size: 12), textAlign: TextAlign.center)),
          ],
        ),
      ).onTap(onPressed, borderRadius: radius()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: getTitle,
      actions: [
        if (widget.userData != null)
          PopupMenuButton(
            icon: Icon(Icons.more_vert, size: 24, color: white),
            color: context.cardColor,
            onSelected: (selection) {
              if (selection == 1) {
                showConfirmDialogCustom(
                  context,
                  dialogType: DialogType.DELETE,
                  title: locale.doYouWantToDelete,
                  positiveText: locale.delete,
                  negativeText: locale.cancel,
                  onAccept: (_) {
                    ifNotTester(context, () {
                      deleteUser(widget.userData!.id.validate());
                    });
                  },
                );
              } else if (selection == 2) {
                showConfirmDialogCustom(
                  context,
                  dialogType: DialogType.ACCEPT,
                  title: locale.doYouWantToRestore,
                  positiveText: locale.accept,
                  negativeText: locale.cancel,
                  onAccept: (_) {
                    ifNotTester(context, () {
                      restoreUserData();
                    });
                  },
                );
              } else if (selection == 3) {
                showConfirmDialogCustom(
                  context,
                  dialogType: DialogType.DELETE,
                  title: locale.doYouWantToDeleteForcefully,
                  positiveText: locale.delete,
                  negativeText: locale.cancel,
                  onAccept: (_) {
                    ifNotTester(context, () {
                      forceUserData();
                    });
                  },
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(locale.delete, style: boldTextStyle(color: widget.userData!.deletedAt == null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 1,
                enabled: widget.userData!.deletedAt == null,
              ),
              PopupMenuItem(
                child: Text(locale.restore, style: boldTextStyle(color: widget.userData!.deletedAt != null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 2,
                enabled: widget.userData!.deletedAt != null,
              ),
              PopupMenuItem(
                child: Text(locale.forceDelete, style: boldTextStyle(color: widget.userData!.deletedAt != null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 3,
                enabled: widget.userData!.deletedAt != null,
              ),
            ],
          ),
      ],
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              if (widget.userData != null)
                Row(
                  children: [
                    if (widget.userType == USER_TYPE_PROVIDER)
                      buildInnerItem(
                        margin: EdgeInsets.only(right: 16, bottom: 8),
                        onPressed: () {
                          if (widget.userData!.deletedAt == null) {
                            ifNotTester(context, () {
                              ProviderPayoutListScreen(user: widget.userData!).launch(context);
                            });
                          } else {
                            toast(locale.youCanTUpdateDeleted);
                          }
                        },
                        icon: Icon(Icons.payments_outlined),
                        title: locale.payoutList,
                      ).expand(),
                    if (widget.userType == USER_TYPE_HANDYMAN)
                      buildInnerItem(
                        margin: EdgeInsets.only(right: 16, bottom: 8),
                        onPressed: () {
                          if (widget.userData!.deletedAt == null) {
                            ifNotTester(context, () {
                              HandymanPayoutListScreen(user: widget.userData!).launch(context);
                            });
                          } else {
                            toast(locale.youCanTUpdateDeleted);
                          }
                        },
                        icon: Icon(Icons.payments_outlined),
                        title: locale.payoutList,
                      ),
                    if (widget.userType == USER_TYPE_PROVIDER)
                      buildInnerItem(
                        onPressed: () {
                          if (widget.userData!.deletedAt == null) {
                            ifNotTester(context, () {
                              ProviderAddressListScreen(user: widget.userData!).launch(context);
                            });
                          } else {
                            toast(locale.youCanTUpdateDeleted);
                          }
                        },
                        icon: Icon(Icons.location_city_outlined),
                        title: '${locale.service} ${locale.address} ',
                      ).expand(),
                    if (widget.userType == USER_TYPE_PROVIDER)
                      buildInnerItem(
                        margin: EdgeInsets.only(left: 16, bottom: 8),
                        onPressed: () {
                          if (widget.userData!.deletedAt == null) {
                            ifNotTester(context, () {
                              ProviderDocumentList(user: widget.userData!).launch(context);
                            });
                          } else {
                            toast(locale.youCanTUpdateDeleted);
                          }
                        },
                        icon: Icon(Icons.notes),
                        title: locale.documents,
                      ).expand(),
                  ],
                ).paddingBottom(10),
              AppTextField(
                textFieldType: TextFieldType.NAME,
                controller: fNameCont,
                focus: fNameFocus,
                nextFocus: lNameFocus,
                errorThisFieldRequired: locale.thisFieldIsRequired,
                decoration: inputDecoration(context, hint: locale.firstName),
                suffix: ic_profile.iconImage(size: 10).paddingAll(14),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.NAME,
                controller: lNameCont,
                focus: lNameFocus,
                nextFocus: userNameFocus,
                errorThisFieldRequired: locale.thisFieldIsRequired,
                decoration: inputDecoration(context, hint: locale.lastName),
                suffix: ic_profile.iconImage(size: 10).paddingAll(14),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.USERNAME,
                controller: userNameCont,
                focus: userNameFocus,
                nextFocus: emailFocus,
                errorThisFieldRequired: locale.thisFieldIsRequired,
                decoration: inputDecoration(context, hint: locale.userName),
                suffix: ic_profile.iconImage(size: 10).paddingAll(14),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.EMAIL_ENHANCED,
                controller: emailCont,
                focus: emailFocus,
                nextFocus: mobileFocus,
                errorThisFieldRequired: locale.thisFieldIsRequired,
                decoration: inputDecoration(context, hint: locale.emailAddress),
                suffix: ic_message.iconImage(size: 10).paddingAll(14),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.PHONE,
                controller: mobileCont,
                focus: mobileFocus,
                maxLength: 15,
                buildCounter: (_, {required int currentLength, required bool isFocused, required int? maxLength}) {
                  return Offstage();
                },
                nextFocus: designationFocus,
                errorThisFieldRequired: locale.thisFieldIsRequired,
                decoration: inputDecoration(context, hint: locale.contactNumber),
                suffix: calling.iconImage(size: 10).paddingAll(14),
                validator: (mobileCont) {
                  if (mobileCont!.isEmpty) {
                    return locale.pleaseEnterContactNumber;
                  }
                  return null;
                },
              ),
              8.height,
              AppTextField(
                textFieldType: TextFieldType.USERNAME,
                controller: designationCont,
                isValidationRequired: false,
                focus: designationFocus,
                nextFocus: passwordFocus,
                decoration: inputDecoration(context, hint: locale.designation),
                suffix: ic_profile.iconImage(size: 10).paddingAll(14),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.USERNAME,
                controller: addressCont,
                isValidationRequired: false,
                focus: addressFocus,
                nextFocus: passwordFocus,
                decoration: inputDecoration(context, hint: locale.address),
                suffix: servicesAddress.iconImage(size: 10).paddingAll(14),
              ),
              if (widget.userData == null)
                Column(
                  children: [
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: passwordCont,
                      focus: passwordFocus,
                      suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                      suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                      errorThisFieldRequired: locale.thisFieldIsRequired,
                      decoration: inputDecoration(context, hint: locale.password),
                      onFieldSubmitted: (s) {
                        saveUser();
                      },
                    ),
                  ],
                ),
              16.height,
              if (widget.userType != USER_TYPE_USER)
                Column(
                  children: [
                    DropdownButtonFormField<UserTypeData>(
                      onChanged: (UserTypeData? val) {
                        selectedUserTypeData = val;
                      },
                      /*validator: widget.isValidate
                          ? (c) {
                              if (c == null) return errorThisFieldRequired;
                              return null;
                            }
                          : null,*/
                      value: selectedUserTypeData,
                      dropdownColor: context.cardColor,
                      decoration: inputDecoration(context, hint: locale.selectUserType),
                      items: List.generate(
                        userTypeList.length,
                        (index) {
                          UserTypeData data = userTypeList[index];
                          return DropdownMenuItem<UserTypeData>(
                            child: Text(data.name.toString(), style: primaryTextStyle()),
                            value: data,
                          );
                        },
                      ),
                    ),
                    16.height,
                  ],
                ),
              if (widget.userType == USER_TYPE_HANDYMAN) providerNameAndAddress(),
              8.height,
              AppButton(
                text: locale.save,
                color: primaryColor,
                width: context.width(),
                onTap: () {
                  if (widget.userData == null || widget.userData!.deletedAt == null) {
                    ifNotTester(context, () {
                      saveUser();
                    });
                  } else {
                    toast(locale.youCanTUpdateDeleted);
                  }
                },
              ),
              20.height,
            ],
          ),
        ),
      ),
    );
  }
}
