import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/back_widget.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_body.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class AppScaffold extends StatelessWidget {
  final String? appBarTitle;
  final List<Widget>? actions;

  final Widget child;
  final Color? scaffoldBackgroundColor;
  final bool showLoaderInCenter;
  final Widget? floatingActionButton;

  AppScaffold({
    this.appBarTitle,
    required this.child,
    this.actions,
    this.scaffoldBackgroundColor,
    this.floatingActionButton,
    this.showLoaderInCenter = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        appBarTitle.validate(),
        textColor: white,
        textSize: APP_BAR_TEXT_SIZE,
        elevation: 0.0,
        color: context.primaryColor,
        backWidget: BackWidget(),
        actions: actions,
      ),
      backgroundColor: scaffoldBackgroundColor,
      body: Body(child: child, showLoaderInCenter: showLoaderInCenter),
      floatingActionButton: floatingActionButton,
    );
  }
}
