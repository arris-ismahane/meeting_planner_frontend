import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UiUtils {
  static Widget requiredPostFix(String text,
      [bool required = true, double titleWidth = 150]) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(10),
        SizedBox(
          width: titleWidth,
          child: SelectableText(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (required) ...[
          const Gap(5),
          const SelectableText(
            "*",
            style: TextStyle(color: Colors.red),
          ),
        ]
      ],
    );
  }

  static Widget errorText(String message) {
    return Text(message, style: TextStyle(color: Colors.red));
  }
}
