import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/app_theme.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/coupon_model.dart';
import 'package:handyman_admin_flutter/model/service_model.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/service/service_list_screen.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class AddCouponScreen extends StatefulWidget {
  final CouponData? couponData;

  AddCouponScreen({this.couponData});

  @override
  _AddCouponScreenState createState() => _AddCouponScreenState();
}

class _AddCouponScreenState extends State<AddCouponScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<List<ServiceData>>? future;
  TextEditingController searchCont = TextEditingController();

  TextEditingController couponCodeCont = TextEditingController();
  TextEditingController discountCont = TextEditingController();
  TextEditingController expDateCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  FocusNode couponCodeFocus = FocusNode();
  FocusNode discountTypeFocus = FocusNode();
  FocusNode discountFocus = FocusNode();
  FocusNode expDateFocus = FocusNode();
  FocusNode statusFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  String selectedStatusType = ACTIVE;

  String selectedDiscountType = FIXED;

  DateTime? selectedDate;
  DateTime? finalDate;

  //TimeOfDay? pickedTime;

  int currentPage = 1;

  bool serviceValidator = false;

  List<ServiceData> serviceIds = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.couponData != null) {
      couponCodeCont.text = widget.couponData!.code.validate();
      selectedDiscountType = widget.couponData!.discountType.validate();
      discountCont.text = widget.couponData!.discount.validate().toString();
      expDateCont.text = formatDate(widget.couponData!.expiredDate.validate(), format: DATE_FORMAT_2);
      // selectedStatusType = widget.couponData!.status.validate() == 1 ? ACTIVE : IN_ACTIVE;
      setState(() {});

      getCouponService(id: widget.couponData!.id!).then((value) {
        serviceIds = value;
        setState(() {});
      }).catchError(onError);
    }
  }

  void selectDateAndTime(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 1),
      builder: (_, child) {
        return Theme(
          data: appStore.isDarkMode ? ThemeData.dark() : AppTheme.lightTheme(),
          child: child!,
        );
      },
    ).then((date) async {
      if (date != null) {
        //DateTime now = DateTime.now();
        if (date.isToday) {
          return toast(locale.pleaseSelectProperDate);
        } else {
          selectedDate = date;
          finalDate = DateTime(date.year, date.month, date.day);
          expDateCont.text = "${formatDate(selectedDate.toString(), format: DATE_FORMAT_7)}";
        }
      }
    }).catchError((e) {
      toast(e.toString());
    });
  }

  /// Save Coupon
  Future<void> addCoupon() async {
    if (formKey.currentState!.validate()) {
      if (serviceIds.isEmpty) {
        return toast(locale.pleaseSelectService);
      }

      formKey.currentState!.save();

      hideKeyboard(context);
      Map request = {
        "id": widget.couponData != null ? widget.couponData!.id : null,
        "code": couponCodeCont.text.validate(),
        "discount_type": selectedDiscountType,
        "discount": discountCont.text.validate(),
        "expire_date": expDateCont.text.validate(),
        "status": selectedStatusType == ACTIVE ? 1 : 0,
        "service_id": serviceIds.map((e) => e.id.validate()).toList(),
      };

      appStore.setLoading(true);
      await saveCoupon(request: request).then((value) {
        appStore.setLoading(false);
        toast(value.message);

        finish(context, true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  /// Delete Coupon
  Future<void> deleteCoupon(int? id) async {
    appStore.setLoading(true);
    await removeCoupon(id.validate()).then((value) {
      appStore.setLoading(false);

      finish(context, true);
      toast(value.message);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// Restore Coupon
  Future<void> restoreCoupons() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.couponData!.id,
      type: RESTORE,
    };

    await restoreCoupon(req).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      finish(context, true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// ForceFully Delete Coupon
  Future<void> forceDeleteCoupon() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.couponData!.id,
      type: FORCE_DELETE,
    };

    await restoreCoupon(req).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      finish(context, true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  void pickService() async {
    List<ServiceData>? id = await ServiceListScreen(pickService: true, allowMultipleSelection: true, serviceIds: serviceIds).launch(context);

    if (id != null) {
      serviceIds = id;
      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: widget.couponData == null ? '${locale.add} ${locale.coupon}' : '${locale.update} ${locale.coupon}',
      actions: [
        if (widget.couponData != null)
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
                      deleteCoupon(widget.couponData!.id.validate());
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
                      restoreCoupons();
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
                      forceDeleteCoupon();
                    });
                  },
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(locale.delete, style: boldTextStyle(color: widget.couponData!.deletedAt == null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 1,
                enabled: widget.couponData!.deletedAt == null,
              ),
              PopupMenuItem(
                child: Text(locale.restore, style: boldTextStyle(color: widget.couponData!.deletedAt != null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 2,
                enabled: widget.couponData!.deletedAt != null,
              ),
              PopupMenuItem(
                child: Text(locale.forceDelete, style: boldTextStyle(color: widget.couponData!.deletedAt != null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 3,
                enabled: widget.couponData!.deletedAt != null,
              ),
            ],
          ),
      ],
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                textFieldType: TextFieldType.NAME,
                controller: couponCodeCont,
                focus: couponCodeFocus,
                nextFocus: discountFocus,
                decoration: inputDecoration(context, hint: locale.couponCode),
                errorThisFieldRequired: locale.thisFieldIsRequired,
              ),
              16.height,
              Row(
                children: [
                  DropdownButtonFormField<String>(
                    items: [
                      DropdownMenuItem(
                        child: Text(locale.fixed, style: primaryTextStyle()),
                        value: FIXED,
                      ),
                      DropdownMenuItem(
                        child: Text(locale.percentage, style: primaryTextStyle()),
                        value: PERCENTAGE,
                      ),
                    ],
                    focusNode: discountTypeFocus,
                    dropdownColor: context.cardColor,
                    decoration: inputDecoration(context, hint: locale.discountType),
                    value: selectedDiscountType,
                    validator: (value) {
                      if (value == null) return errorThisFieldRequired;
                      return null;
                    },
                    onChanged: (c) {
                      hideKeyboard(context);
                      selectedDiscountType = c.validate();
                    },
                  ).expand(),
                  16.width,
                  AppTextField(
                    textFieldType: TextFieldType.PHONE,
                    controller: discountCont,
                    focus: discountFocus,
                    nextFocus: expDateFocus,
                    decoration: inputDecoration(context, hint: locale.discount),
                    errorThisFieldRequired: locale.thisFieldIsRequired,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (s) {
                      if (s!.isEmpty) return errorThisFieldRequired;

                      if (s.toDouble().isNegative || s.toInt() == 0 || s.toInt() > 99) return '${discountCont.text}% ${locale.isNotValid}';
                      return null;
                    },
                  ).expand(),
                ],
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.OTHER,
                controller: expDateCont,
                isValidationRequired: true,
                validator: (value) {
                  if (value!.isEmpty) return locale.thisFieldIsRequired;
                  return null;
                },
                readOnly: true,
                onTap: () {
                  selectDateAndTime(context);
                },
                decoration: inputDecoration(
                  context,
                  hint: locale.expDate,
                  prefixIcon: Icon(Icons.date_range, size: 16, color: context.iconColor).paddingAll(14),
                ).copyWith(
                  filled: true,
                  hintText: locale.expDate,
                  hintStyle: secondaryTextStyle(),
                ),
              ),
              16.height,
              Container(
                decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (serviceIds.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.selectedService, style: boldTextStyle()).paddingOnly(bottom: 8,left: 8),
                          ...List.generate(serviceIds.length, (index) {
                            return Text(
                              "- ${serviceIds[index].name.validate()}",
                              style: primaryTextStyle(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ).paddingOnly(left: 12);
                          }),
                        ],
                      ).expand(),
                    TextButton(
                      onPressed: () async {
                        pickService();
                      },
                      child: Text(locale.pickAService),
                    ),
                  ],
                ).paddingOnly(left: 10),
              ),
              24.height,
              DropdownButtonFormField<String>(
                items: [
                  DropdownMenuItem(
                    child: Text(locale.active, style: primaryTextStyle()),
                    value: ACTIVE,
                  ),
                  DropdownMenuItem(
                    child: Text(locale.inactive, style: primaryTextStyle()),
                    value: IN_ACTIVE,
                  ),
                ],
                focusNode: statusFocus,
                dropdownColor: context.cardColor,
                decoration: inputDecoration(context, hint: locale.selectStatus),
                value: selectedStatusType,
                validator: (value) {
                  if (value == null) return errorThisFieldRequired;
                  return null;
                },
                onChanged: (c) {
                  hideKeyboard(context);
                  selectedStatusType = c.validate();
                },
              ),
              24.height,
              AppButton(
                text: locale.save,
                color: context.primaryColor,
                width: context.width(),
                onTap: () {
                  if (widget.couponData == null || widget.couponData!.deletedAt == null) {
                    ifNotTester(context, () {
                      addCoupon();
                    });
                  } else {
                    toast(locale.youCanTUpdateDeleted);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
