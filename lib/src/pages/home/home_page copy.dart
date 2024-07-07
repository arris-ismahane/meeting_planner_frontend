import 'package:flutter/material.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:meeting_planner/src/utils/widget_utils.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends BasicState<HomePage2> {
  @override
  Widget build(BuildContext context) {
    return WidgetUtils.wrapRoute(
      (context, type) => Scaffold(
        appBar: AppBar(
          title: Text(lang.homePage),
        ),
        body: ListView(
          children: [Text("WELCOME 2")],
        ),
      ),
    );
  }
}
