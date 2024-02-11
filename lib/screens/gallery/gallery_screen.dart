import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/back_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:nb_utils/nb_utils.dart';

import 'gallery_component.dart';

class GalleryScreen extends StatefulWidget {
  final String serviceName;
  final List<String> attachments;

  GalleryScreen({required this.serviceName, required this.attachments});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  void initState() {
    afterBuildCreated(() {
      setStatusBarColor(context.primaryColor);
    });
    super.initState();
  }

  @override
  void dispose() {
    setStatusBarColor(Colors.transparent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "${locale.gallery} ${'- ${widget.serviceName}'}",
        textColor: Colors.white,
        color: context.primaryColor,
        backWidget: BackWidget(),
      ),
      body: AnimatedWrap(
        spacing: 16,
        runSpacing: 16,
        listAnimationType: ListAnimationType.Scale,
        scaleConfiguration: ScaleConfiguration(duration: 300.milliseconds, delay: 50.milliseconds),
        itemCount: widget.attachments.length,
        itemBuilder: (context, i) {
          return GalleryComponent(images: widget.attachments, index: i);
        },
      ).paddingSymmetric(horizontal: 16, vertical: 16),
    );
  }
}
