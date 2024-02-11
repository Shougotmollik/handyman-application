import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/provider_address_mapping_model.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/map/map_screen.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:handyman_admin_flutter/utils/permissions.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/colors.dart';

class AddAddressScreen extends StatefulWidget {
  final ProviderAddressMapping? data;
  final int providerId;

  AddAddressScreen({this.data, required this.providerId});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int currentPage = 1;

  bool isLastPage = false;

  int page = 1;

  TextEditingController addressCont = TextEditingController();
  TextEditingController latitudeCont = TextEditingController();
  TextEditingController longitudeCont = TextEditingController();

  FocusNode addressFocus = FocusNode();
  FocusNode latitudeFocus = FocusNode();
  FocusNode longitudeFocus = FocusNode();
  FocusNode statusFocus = FocusNode();

  String selectedStatusType = ACTIVE;

  /// Save Address
  Future<void> addAddress() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      Map request = {
        "id": widget.data != null ? widget.data!.id : '',
        "address": addressCont.text.validate(),
        "latitude": latitudeCont.text.validate(),
        "longitude": longitudeCont.text.validate(),
        "status": selectedStatusType == ACTIVE ? 1 : 0,
        'provider_id': widget.providerId,
      };
      appStore.setLoading(true);
      await saveAddresses(request: request).then((value) {
        appStore.setLoading(false);
        toast(value.message);

        finish(context, true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  /// Delete Address
  Future<void> deleteAddress(int? id) async {
    appStore.setLoading(true);
    await removeAddress(id.validate()).then((value) {
      appStore.setLoading(false);

      finish(context, true);
      toast(value.message);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// Restore Address
  Future<void> restoreAddressData() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.data!.id,
      type: RESTORE,
    };

    await restoreAddress(req).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      finish(context, true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// ForceFully Delete Address
  Future<void> forceDeleteAddress() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.data!.id,
      type: FORCE_DELETE,
    };

    await restoreAddress(req).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      finish(context, true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  void _handleSetLocationClick() {
    Permissions.cameraFilesAndLocationPermissionsGranted().then((value) async {
      await setValue(PERMISSION_STATUS, value);

      if (value) {
        MapScreen(latitude: getDoubleAsync(LATITUDE), longitude: getDoubleAsync(LONGITUDE)).launch(context).then((value) {
          if (value != null) {
            addressCont.text = value['address'];
            latitudeCont.text = value['lat'].toString();
            longitudeCont.text = value['long'].toString();
            setState(() {});
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.data != null) {
      addressCont.text = widget.data!.address.validate();
      latitudeCont.text = widget.data!.longitude.validate();
      longitudeCont.text = widget.data!.latitude.validate();
      selectedStatusType = widget.data!.status.validate() == 1 ? ACTIVE : IN_ACTIVE;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: widget.data == null ? '${locale.add} ${locale.service} ${locale.address}' : '${locale.update} ${locale.address}',
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
                      deleteAddress(widget.data!.id.validate());
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
                      restoreAddressData();
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
                      forceDeleteAddress();
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
      child: RefreshIndicator(
        onRefresh: () async {
          currentPage = 1;

          init();
          setState(() {});
          return await 2.seconds.delay;
        },
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
                  controller: addressCont,
                  focus: addressFocus,
                  nextFocus: latitudeFocus,
                  errorThisFieldRequired: locale.thisFieldIsRequired,
                  decoration: inputDecoration(context, hint: locale.address),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Text(locale.chooseFromMap, style: boldTextStyle(color: primaryColor, size: 13)),
                      onPressed: () {
                        _handleSetLocationClick();
                      },
                    ).flexible(),
                  ],
                ),
                AppTextField(
                  textFieldType: TextFieldType.NUMBER,
                  controller: latitudeCont,
                  focus: latitudeFocus,
                  nextFocus: longitudeFocus,
                  errorThisFieldRequired: locale.thisFieldIsRequired,
                  decoration: inputDecoration(context, hint: locale.latitude),
                ),
                16.height,
                AppTextField(
                  textFieldType: TextFieldType.NUMBER,
                  controller: longitudeCont,
                  focus: longitudeFocus,
                  nextFocus: statusFocus,
                  errorThisFieldRequired: locale.thisFieldIsRequired,
                  decoration: inputDecoration(context, hint: locale.longitude),
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
                    if (widget.data == null || widget.data!.deletedAt == null) {
                      ifNotTester(context, () {
                        addAddress();
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
      ),
    );
  }
}
