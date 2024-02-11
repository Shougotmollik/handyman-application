import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/base_scaffold_widget.dart';
import '../../main.dart';
import '../../model/tax_list_response.dart';
import '../../networks/rest_apis.dart';
import '../../utils/common.dart';
import '../../utils/constant.dart';

class AddTaxScreen extends StatefulWidget {
  final TaxData? data;

  AddTaxScreen({this.data});

  @override
  State<AddTaxScreen> createState() => _AddTaxScreenState();
}

class _AddTaxScreenState extends State<AddTaxScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController taxTitleCont = TextEditingController();
  TextEditingController taxValueCont = TextEditingController();

  FocusNode taxTitleFocus = FocusNode();
  FocusNode taxValueFocus = FocusNode();
  FocusNode taxTypeFocus = FocusNode();
  FocusNode taxStatusFocus = FocusNode();

  String selectedTaxType = FIXED;
  String selectedStatusType = ACTIVE;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.data != null) {
      taxTitleCont.text = widget.data!.title.validate();
      taxValueCont.text = widget.data!.value.toString();
      log(widget.data!.type.validate());
      selectedTaxType = widget.data!.type.validate();
      selectedStatusType = widget.data!.status.validate() == 1 ? ACTIVE : IN_ACTIVE;
      setState(() {});
    }
  }

  /// Save Tax
  Future<void> addTax() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      Map request = {
        "id": widget.data != null ? widget.data!.id : null,
        "title": taxTitleCont.text.validate(),
        "value": taxValueCont.text.toDouble(),
        "type": selectedTaxType,
        "status": selectedStatusType == ACTIVE ? 1 : 0,
      };
      appStore.setLoading(true);
      await saveTax(request: request).then((value) {
        appStore.setLoading(false);
        toast(value.message);

        finish(context, true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  /// Delete Tax
  Future<void> deleteTax(int? id) async {
    appStore.setLoading(true);
    await removeTax(id.validate()).then((value) {
      appStore.setLoading(false);

      finish(context, true);
      toast(value.message);
      log(value.message);
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
      appBarTitle: widget.data != null ? locale.updateTax : locale.addTax,
      actions: [
        if (widget.data != null)
          IconButton(
            icon: Icon(Icons.delete_forever, color: Colors.white, size: 18),
            onPressed: () async {
              showConfirmDialogCustom(
                context,
                dialogType: DialogType.DELETE,
                title: locale.doYouWantToDelete,
                positiveText: locale.delete,
                negativeText: locale.cancel,
                onAccept: (_) {
                  ifNotTester(context, () {
                    deleteTax(widget.data!.id.validate());
                  });
                },
              );
            },
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
                controller: taxTitleCont,
                focus: taxTitleFocus,
                nextFocus: taxValueFocus,
                errorThisFieldRequired: locale.thisFieldIsRequired,
                decoration: inputDecoration(context, hint: locale.title),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.NUMBER,
                controller: taxValueCont,
                focus: taxValueFocus,
                nextFocus: taxTypeFocus,
                errorThisFieldRequired: locale.thisFieldIsRequired,
                decoration: inputDecoration(context, hint: locale.value),
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
                focusNode: taxTypeFocus,
                dropdownColor: context.cardColor,
                decoration: inputDecoration(context, hint: locale.type),
                value: selectedTaxType,
                validator: (value) {
                  if (value == null) return errorThisFieldRequired;
                  return null;
                },
                onChanged: (c) {
                  hideKeyboard(context);
                  selectedTaxType = c.validate();
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
                focusNode: taxStatusFocus,
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
              30.height,
              AppButton(
                text: locale.save,
                color: context.primaryColor,
                width: context.width(),
                onTap: () {
                  ifNotTester(context, () {
                    addTax();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
