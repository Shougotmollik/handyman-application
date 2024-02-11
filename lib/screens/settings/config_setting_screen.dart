import 'package:flutter/material.dart';

class ConfigSettingScreen extends StatefulWidget {
  const ConfigSettingScreen({Key? key}) : super(key: key);

  @override
  State<ConfigSettingScreen> createState() => _ConfigSettingScreenState();
}

class _ConfigSettingScreenState extends State<ConfigSettingScreen> {
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
