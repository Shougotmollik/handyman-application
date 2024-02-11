import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:nb_utils/nb_utils.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  LanguagesScreenState createState() => LanguagesScreenState();
}

class LanguagesScreenState extends State<LanguagesScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: locale.language,
      child: LanguageListWidget(
        widgetType: WidgetType.LIST,
        onLanguageChange: (v) {
          appStore.setLanguage(v.languageCode!);
          setState(() {});
          finish(context, true);
        },
      ),
    );
  }
}
