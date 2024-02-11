import 'package:flutter/material.dart';

class PostJobListScreen extends StatefulWidget {
  const PostJobListScreen({Key? key}) : super(key: key);

  @override
  State<PostJobListScreen> createState() => _PostJobListScreenState();
}

class _PostJobListScreenState extends State<PostJobListScreen> {
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
