import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/components/theme_selection_dialog.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/screens/settings/language_screen.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: locale.appSettings,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SettingItemWidget(
              leading: ic_language.iconImage(size: 16),
              title: locale.language,
              trailing: trailing,
              onTap: () {
                LanguagesScreen().launch(context).then((value) {
                  setState(() {});
                });
              },
            ),
            SettingItemWidget(
              leading: ic_dark_mode.iconImage(size: 16),
              title: locale.appTheme,
              trailing: trailing,
              onTap: () async {
                await showInDialog(
                  context,
                  builder: (context) => ThemeSelectionDaiLog(),
                  contentPadding: EdgeInsets.zero,
                );
              },
            ),
            SnapHelperWidget<bool>(
              future: isAndroid12Above(),
              onSuccess: (data) {
                if (data) {
                  return SettingItemWidget(
                    leading: ic_android_12.iconImage(size: 18),
                    title: locale.enableMaterialYouTheme,
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch.adaptive(
                        value: appStore.useMaterialYouTheme,
                        onChanged: (v) {
                          showConfirmDialogCustom(
                            context,
                            primaryColor: context.primaryColor,
                            title: locale.thisActionWillRestart,
                            positiveText: locale.yes,
                            negativeText: locale.no,
                            onAccept: (_) {
                              appStore.setUseMaterialYouTheme(v.validate());

                              RestartAppWidget.init(context);
                            },
                          );
                        },
                      ).withHeight(24),
                    ),
                    onTap: null,
                  );
                }
                return Offstage();
              },
            ),
            16.height,
          ],
        ),
      ),
    );
  }
}
