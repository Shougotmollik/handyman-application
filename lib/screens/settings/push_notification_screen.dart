import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/back_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/service_model.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/service/service_list_screen.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/colors.dart';

class PushNotificationScreen extends StatefulWidget {
  @override
  _PushNotificationScreenState createState() => _PushNotificationScreenState();
}

class _PushNotificationScreenState extends State<PushNotificationScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleCont = TextEditingController();
  TextEditingController typeCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  FocusNode titleFocus = FocusNode();
  FocusNode typeFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  String selectedNotificationTypeValue = NOTIFICATION_TYPE_ALL;

  ServiceData? selectedService;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  Future<void> sendNotification() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      Map request = {
        "type": selectedNotificationTypeValue,
        "title": titleCont.text.validate(),
        "description": descriptionCont.text.validate(),
      };
      if (selectedNotificationTypeValue == NOTIFICATION_TYPE_SERVICES) {
        if (selectedService != null) {
          request.putIfAbsent('service_id', () => selectedService!.id);
        } else {
          toast(locale.pickAService);
          pickService();

          return;
        }
      }
      appStore.setLoading(true);
      await sendPushNotification(request).then((value) {
        appStore.setLoading(false);
        toast(value.message);

        finish(context, true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  void pickService() async {
    List<ServiceData>? id = await ServiceListScreen(pickService: true).launch(context);

    if (id != null) {
      selectedService = id.first;
      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        locale.pushNotificationSettings,
        textColor: Colors.white,
        color: primaryColor,
        showBack: Navigator.canPop(context),
        backWidget: BackWidget(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              AppTextField(
                textFieldType: TextFieldType.NAME,
                controller: titleCont,
                focus: titleFocus,
                nextFocus: typeFocus,
                errorThisFieldRequired: locale.thisFieldIsRequired,
                decoration: inputDecoration(context, hint: locale.title),
              ),
              16.height,
              DropdownButtonFormField<String>(
                items: [
                  DropdownMenuItem(
                    child: Text(locale.all, style: primaryTextStyle()),
                    value: NOTIFICATION_TYPE_ALL,
                  ),
                  DropdownMenuItem(
                    child: Text(locale.services, style: primaryTextStyle()),
                    value: NOTIFICATION_TYPE_SERVICES,
                  ),
                ],
                dropdownColor: context.cardColor,
                focusNode: typeFocus,
                decoration: inputDecoration(context, hint: locale.selectNotificationType),
                value: selectedNotificationTypeValue,
                validator: (value) {
                  if (value == null) return errorThisFieldRequired;
                  return null;
                },
                onChanged: (c) {
                  hideKeyboard(context);
                  selectedNotificationTypeValue = c.validate();
                },
              ),
              16.height,
              if (selectedNotificationTypeValue == NOTIFICATION_TYPE_SERVICES)
                Column(
                  children: [
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (selectedService != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(locale.selectedService, style: boldTextStyle()).paddingOnly(bottom: 8),
                              Text('${selectedService!.name}', style: primaryTextStyle()),
                            ],
                          ),
                        TextButton(
                          onPressed: () async {
                            pickService();
                          },
                          child: Text(locale.pickAService),
                        ),
                      ],
                    ),
                    24.height,
                  ],
                ),
              AppTextField(
                textFieldType: TextFieldType.MULTILINE,
                controller: descriptionCont,
                focus: descriptionFocus,
                errorThisFieldRequired: locale.thisFieldIsRequired,
                decoration: inputDecoration(context, hint: locale.message),
              ),
              32.height,
              AppButton(
                text: locale.send,
                color: primaryColor,
                width: context.width(),
                onTap: () {
                  ifNotTester(context, () {
                    sendNotification();
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
