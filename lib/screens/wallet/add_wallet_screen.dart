import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/base_scaffold_widget.dart';
import '../../components/cached_image_widget.dart';
import '../../main.dart';
import '../../model/user_data.dart';
import '../../model/walletListResponse.dart';
import '../../networks/rest_apis.dart';
import '../../utils/common.dart';
import '../../utils/constant.dart';
import '../user/user_list_screen.dart';

class AddWalletScreen extends StatefulWidget {
  final WalletData? data;

  AddWalletScreen({this.data});

  @override
  State<AddWalletScreen> createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends State<AddWalletScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController walletTitleCont = TextEditingController();
  TextEditingController walletAmountCont = TextEditingController();

  FocusNode walletTitleFocus = FocusNode();
  FocusNode walletAmountFocus = FocusNode();
  FocusNode walletStatusFocus = FocusNode();

  UserData? selectedProvider;

  bool isUpdate = false;
  String selectedStatusType = ACTIVE;
  int? selectedProviderId;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isUpdate = widget.data != null;

    if (isUpdate) {
      selectedProviderId = widget.data!.userId;
      walletTitleCont.text = widget.data!.title.validate();
      selectedStatusType = widget.data!.status.validate() == 1 ? ACTIVE : IN_ACTIVE;
    }
  }

  /// Save Wallet
  Future<void> addWallet() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      if (selectedProviderId == null) return toast(locale.pleaseSelectProvider);

      Map request = {
        "id": widget.data != null ? widget.data!.id : '',
        "user_id": selectedProviderId!,
        "status": selectedStatusType == ACTIVE ? 1 : 0,
        "title": walletTitleCont.text.validate(),
        "amount": walletAmountCont.text.toDouble(),
      };
      appStore.setLoading(true);
      await saveWallet(request: request).then((value) {
        appStore.setLoading(false);
        toast(value.message);

        finish(context, true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  ///Delete Wallet
  Future<void> deleteWallet(int? id) async {
    appStore.setLoading(true);
    await removeWallet(id.validate()).then((value) {
      appStore.setLoading(false);

      finish(context, true);
      toast(value.message);
      log(value.message);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// Pick Provider
  void pickProvider() async {
    UserData? user = await UserListScreen(type: USER_TYPE_PROVIDER, pickUser: true, status: USER_STATUS_ACTIVE).launch(context);

    if (user != null) {
      selectedProvider = user;
      selectedProviderId = user.id.validate();
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
      appBarTitle: isUpdate ? "${locale.credit} ${widget.data!.name.validate()} ${locale.wallet}": locale.addWallet,
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
                    deleteWallet(widget.data!.id.validate());
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
                controller: walletTitleCont,
                focus: walletTitleFocus,
                errorThisFieldRequired: locale.thisFieldIsRequired,
                decoration: inputDecoration(context, hint: locale.title),
              ),
              if (!isUpdate)
                Container(
                  margin: EdgeInsets.only(top: 16),
                  decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
                  padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (selectedProvider != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(locale.selectedProvider, style: secondaryTextStyle()).paddingOnly(bottom: 8),
                            Row(
                              children: [
                                CachedImageWidget(url: selectedProvider!.profileImage.validate(), height: 24, circle: true),
                                8.width,
                                Text(
                                  selectedProvider!.displayName.validate(),
                                  style: primaryTextStyle(size: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ).expand(),
                      TextButton(
                        onPressed: () async {
                          pickProvider();
                        },
                        child: Text(locale.pickAProvider),
                      ),
                    ],
                  ),
                ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.NUMBER,
                controller: walletAmountCont,
                focus: walletAmountFocus,
                errorThisFieldRequired: locale.thisFieldIsRequired,
                decoration: inputDecoration(context, hint: locale.amount),
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
                focusNode: walletStatusFocus,
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
                    addWallet();
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
