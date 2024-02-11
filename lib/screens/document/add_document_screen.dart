import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/document_list_response.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class AddDocumentScreen extends StatefulWidget {
  final Documents? data;

  AddDocumentScreen({this.data});

  @override
  _AddDocumentScreenState createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode statusFocus = FocusNode();

  String selectedStatusType = ACTIVE;

  bool? isRequired = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.data != null) {
      nameCont.text = widget.data!.name.validate();
      selectedStatusType = widget.data!.status.validate() == 1 ? ACTIVE : IN_ACTIVE;
      isRequired = widget.data!.isRequired.validate() == 1 ? true : false;
      setState(() {});
    }
  }

  /// Save Document
  Future<void> addDocuments() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      Map request = {
        "id": widget.data != null ? widget.data!.id : null,
        "name": nameCont.text.validate(),
        "status": selectedStatusType == ACTIVE ? 1 : 0,
        "is_required": isRequired.validate() ? 1 : 0,
      };
      appStore.setLoading(true);
      await saveDoc(request: request).then((value) {
        appStore.setLoading(false);
        toast(value.message);

        finish(context, true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  /// Delete Document
  Future<void> deleteDoc(int? id) async {
    appStore.setLoading(true);
    await removeDoc(id.validate()).then((value) {
      appStore.setLoading(false);

      finish(context, true);
      toast(value.message);
      log(value.message);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// Restore Document
  Future<void> restoreDocument() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.data!.id,
      type: RESTORE,
    };

    await restoreDoc(req).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      finish(context, true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// ForceFully Delete Document
  Future<void> forceDeleteDocument() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.data!.id,
      type: FORCE_DELETE,
    };

    await restoreDoc(req).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      finish(context, true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: widget.data == null ? locale.addDocument : locale.updateDocument,
      actions: [
        if (widget.data != null)
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
                      deleteDoc(widget.data!.id.validate());
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
                      restoreDocument();
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
                      forceDeleteDocument();
                    });
                  },
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(locale.delete, style: boldTextStyle(color: widget.data!.deletedAt == null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 1,
                enabled: widget.data!.deletedAt == null,
              ),
              PopupMenuItem(
                child: Text(locale.restore, style: boldTextStyle(color: widget.data!.deletedAt != null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 2,
                enabled: widget.data!.deletedAt != null,
              ),
              PopupMenuItem(
                child: Text(locale.forceDelete, style: boldTextStyle(color: widget.data!.deletedAt != null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 3,
                enabled: widget.data!.deletedAt != null,
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
                nextFocus: statusFocus,
                errorThisFieldRequired: locale.thisFieldIsRequired,
                decoration: inputDecoration(context, hint: locale.documentName),
              ),
              20.height,
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
              16.height,
              Container(
                decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
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
                    value: isRequired,
                    contentPadding: EdgeInsets.zero,
                    title: Text(locale.required, style: secondaryTextStyle()),
                    onChanged: (bool? v) {
                      isRequired = v.validate();
                      setState(() {});
                    },
                  ),
                ),
              ),
              24.height,
              AppButton(
                text: locale.save,
                color: context.primaryColor,
                width: context.width(),
                onTap: () {
                  if (widget.data == null || widget.data!.deletedAt == null) {
                    ifNotTester(context, () {
                      addDocuments();
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
