import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:nb_utils/nb_utils.dart';

class Body extends StatelessWidget {
  final Widget child;
  final bool showLoaderInCenter;

  const Body({Key? key, required this.child, required this.showLoaderInCenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      height: context.height(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          if (showLoaderInCenter)
            Positioned(
              bottom: !showLoaderInCenter ? 8 : null,
              left: !showLoaderInCenter ? 0 : null,
              right: !showLoaderInCenter ? 0 : null,
              child: Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
            ),
        ],
      ),
    );
  }
}
