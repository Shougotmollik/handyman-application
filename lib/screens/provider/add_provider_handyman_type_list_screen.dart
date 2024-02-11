import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/type_list_response.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/colors.dart';

class AddProviderHandymanTypeListScreen extends StatefulWidget {
  final TypeDataModel? typeData;
  final Function? onUpdate;
  final String type;

  AddProviderHandymanTypeListScreen({this.typeData, this.onUpdate, required this.type});

  @override
  AddProviderHandymanTypeListScreenState createState() => AddProviderHandymanTypeListScreenState();
}

class AddProviderHandymanTypeListScreenState extends State<AddProviderHandymanTypeListScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCont = TextEditingController();
  TextEditingController commissionCont = TextEditingController();
  TextEditingController typeCont = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode commissionFocus = FocusNode();
  FocusNode typeFocus = FocusNode();
  FocusNode statusFocus = FocusNode();

  String selectedType = FIXED;
  String selectedStatusType = ACTIVE;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (widget.typeData != null) {
      nameCont.text = widget.typeData!.name.validate();
      commissionCont.text = widget.typeData!.commission.validate().toString();

      if (widget.typeData!.type.validate() == PERCENT) {
        selectedType = PERCENTAGE;
      } else {
        selectedType = widget.typeData!.type.validate();
      }
      selectedStatusType = widget.typeData!.status.validate() == 1 ? ACTIVE : IN_ACTIVE;
      setState(() {});
    }
  }

  /// Add Provider & Handyman Type List
  Future<void> addProviderHandymanTypeList() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      Map request = {
        "id": widget.typeData != null ? widget.typeData!.id : null,
        "name": nameCont.text.validate(),
        "commission": commissionCont.text.validate(),
        "type": selectedType,
        "status": selectedStatusType == ACTIVE ? 1 : 0,
      };
      appStore.setLoading(true);
      await saveProviderHandymanTypeList(request: request, type: widget.type).then((value) {
        appStore.setLoading(false);
        toast(value.message);

        finish(context, true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  /// Delete Provider & Handyman Type List
  Future<void> removeProviderHandymanTypeList(int? id) async {
    appStore.setLoading(true);
    await deleteProviderHandymanTypeList(id.validate(), type: widget.type).then((value) {
      appStore.setLoading(false);

      finish(context, true);
      toast(value.message);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// Restore Provider & Handyman  Type List
  Future<void> restoreProviderHandymanTypeList() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.typeData!.id,
      type: RESTORE,
    };

    await restoreProviderHandymanType(req, type: widget.type).then((value) {
      appStore.setLoading(false);
      toast(value.message);

      finish(context, true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// ForceFully Delete Provider & Handyman Type List
  Future<void> forceDeleteProviderHandymanTypeList() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.typeData!.id,
      type: FORCE_DELETE,
    };

    await restoreProviderHandymanType(req, type: widget.type).then((value) {
      appStore.setLoading(false);
      toast(value.message);

      finish(context, true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  String title() {
    if (widget.type == USER_TYPE_PROVIDER) {
      return widget.typeData == null ? locale.addProviderType : locale.editProviderType;
    } else {
      return widget.typeData == null ? locale.addHandymanType : locale.editHandymanType;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: title(),
      actions: [
        if (widget.typeData != null)
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
                      removeProviderHandymanTypeList(widget.typeData!.id.validate());
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
                      restoreProviderHandymanTypeList();
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
                      forceDeleteProviderHandymanTypeList();
                    });
                  },
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(locale.delete, style: boldTextStyle(color: widget.typeData!.deletedAt == null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 1,
                enabled: widget.typeData!.deletedAt == null,
              ),
              PopupMenuItem(
                child: Text(locale.restore, style: boldTextStyle(color: widget.typeData!.deletedAt != null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 2,
                enabled: widget.typeData!.deletedAt != null,
              ),
              PopupMenuItem(
                child: Text(locale.forceDelete, style: boldTextStyle(color: widget.typeData!.deletedAt != null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 3,
                enabled: widget.typeData!.deletedAt != null,
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
                controller: nameCont,
                focus: nameFocus,
                nextFocus: commissionFocus,
                errorThisFieldRequired: locale.thisFieldIsRequired,
                decoration: inputDecoration(context, hint: locale.typeName),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.OTHER,
                controller: commissionCont,
                focus: commissionFocus,
                nextFocus: typeFocus,
                decoration: inputDecoration(context, hint: locale.commission),
                keyboardType: TextInputType.number,
                validator: (s) {
                  if (s!.isEmptyOrNull) {
                    return locale.thisFieldIsRequired;
                  } else {
                    RegExp reg = RegExp(r'^\d.?\d(,\d*)?$');

                    if (!reg.hasMatch(s)) {
                      return locale.enterValidCommissionValue;
                    }
                  }

                  return null;
                },
              ),
              16.height,
              DropdownButtonFormField<String>(
                items: [
                  DropdownMenuItem(
                    child: Text(locale.fixed, style: primaryTextStyle()),
                    value: FIXED,
                  ),
                  DropdownMenuItem(
                    child: Text(locale.percentage, style: primaryTextStyle()),
                    value: PERCENT,
                  ),
                ],
                focusNode: typeFocus,
                dropdownColor: context.cardColor,
                decoration: inputDecoration(context, hint: locale.type),
                value: selectedType,
                validator: (value) {
                  if (value == null) return errorThisFieldRequired;
                  return null;
                },
                onChanged: (c) {
                  hideKeyboard(context);
                  selectedType = c.validate();
                },
              ),
              16.height,
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
                color: primaryColor,
                width: context.width(),
                onTap: () {
                  if (widget.typeData == null || widget.typeData!.deletedAt == null) {
                    ifNotTester(context, () {
                      addProviderHandymanTypeList();
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
