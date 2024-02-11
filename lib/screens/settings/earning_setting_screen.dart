import 'package:flutter/material.dart';

class EarningSettingScreen extends StatefulWidget {
  const EarningSettingScreen({Key? key}) : super(key: key);

  @override
  State<EarningSettingScreen> createState() => _EarningSettingScreenState();
}

class _EarningSettingScreenState extends State<EarningSettingScreen> {
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
    return Scaffold();
  }
}
