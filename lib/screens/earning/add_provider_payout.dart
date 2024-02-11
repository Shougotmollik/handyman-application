import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/earning_list_response.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/colors.dart';

class AddProviderPayout extends StatefulWidget {
  final EarningModel earningModel;

  const AddProviderPayout({Key? key, required this.earningModel}) : super(key: key);

  @override
  State<AddProviderPayout> createState() => _AddProviderPayoutState();
}

class _AddProviderPayoutState extends State<AddProviderPayout> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController descriptionCont = TextEditingController();
  TextEditingController earningCont = TextEditingController();

  FocusNode earningFocus = FocusNode();

  String selectedMethod = BANK;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    earningCont.text = widget.earningModel.providerEarning.toString();
  }

  /// Provider Payout
  Future<void> saveProviderPayout() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      Map request = {
        "id": null,
        "provider_id": widget.earningModel.providerId.validate(),
        "payment_method": selectedMethod,
        "description": descriptionCont.text.validate(),
        "amount": earningCont.text.trim().replaceAll(appStore.currencySymbol, ''),
      };
      appStore.setLoading(true);
      await providerPayout(request: request).then((value) {
        appStore.setLoading(false);
        toast(value.message);

        finish(context, true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: locale.addProviderPayout,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              DropdownButtonFormField<String>(
                items: [
                  DropdownMenuItem(
                    child: Text(locale.cash, style: primaryTextStyle()),
                    value: CASH,
                  ),
                  DropdownMenuItem(
                    child: Text(locale.bank, style: primaryTextStyle()),
                    value: BANK,
                  ),
                  if (getStringAsync(EARNING_TYPE) == EARNING_TYPE_COMMISSION)
                    DropdownMenuItem(
                      child: Text(locale.wallet, style: primaryTextStyle()),
                      value: WALLET,
                    ),
                ],
                dropdownColor: context.cardColor,
                decoration: inputDecoration(context, hint: locale.selectMethod),
                value: selectedMethod,
                validator: (value) {
                  if (value == null) return errorThisFieldRequired;
                  return null;
                },
                onChanged: (c) {
                  hideKeyboard(context);
                  selectedMethod = c.validate();
                },
              ),
              24.height,
              AppTextField(
                textFieldType: TextFieldType.MULTILINE,
                controller: descriptionCont,
                nextFocus: earningFocus,
                errorThisFieldRequired: locale.thisFieldIsRequired,
                decoration: inputDecoration(context, hint: locale.description),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.NUMBER,
                controller: earningCont,
                focus: earningFocus,
                errorThisFieldRequired: locale.thisFieldIsRequired,
                decoration: inputDecoration(context, hint: locale.providerEarning),
              ),
              20.height,
              AppButton(
                text: locale.save,
                color: primaryColor,
                width: context.width(),
                onTap: () {
                  ifNotTester(context, () {
                    saveProviderPayout();
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
