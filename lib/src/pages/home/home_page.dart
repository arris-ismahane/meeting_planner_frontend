import 'package:flutter/material.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:meeting_planner/src/utils/widget_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasicState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WidgetUtils.wrapRoute(
      (context, type) => Scaffold(
        appBar: AppBar(
          title: Text(lang.homePage),
        ),
        body: ListView(
          children: [Text("WELCOME")],
        ),
      ),
    );
  }
}
