import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: locale.aboutApp,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SettingItemWidget(
              leading: ic_shield_done.iconImage(size: 18),
              title: locale.privacyPolicy,
              onTap: () {
                checkIfLink(context, getStringAsync(PRIVACY_POLICY), title: locale.privacyPolicy);
              },
            ),
            SettingItemWidget(
              leading: ic_document.iconImage(size: 18),
              title: locale.termsConditions,
              onTap: () {
                checkIfLink(context, getStringAsync(TERMS_AND_CONDITION), title: locale.termsConditions);
              },
            ),
            SettingItemWidget(
              leading: ic_help_and_support.iconImage(size: 16),
              title: locale.helpSupport,
              onTap: () {
                checkIfLink(context, appStore.inquiryEmail.validate(), title: locale.helpSupport);
              },
            ),
            SettingItemWidget(
              leading: calling.iconImage(size: 16),
              title: locale.helplineNumber,
              onTap: () {
                checkIfLink(context, appStore.helplineNumber.validate(), title: locale.helplineNumber);
              },
            ),
          ],
        ),
      ),
    );
  }
}
