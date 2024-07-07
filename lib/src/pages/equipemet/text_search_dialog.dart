import 'package:flutter/material.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:meeting_planner/src/utils/utils_mixin.dart';

class TextSearchDialog extends StatefulWidget {
  final String title;
  final String? initValue;
  final Function(String? value)? onSave;
  const TextSearchDialog({
    super.key,
    required this.title,
    required this.onSave,
    this.initValue,
  });

  @override
  State<TextSearchDialog> createState() => TextSearchDialogState();
}

class TextSearchDialogState extends BasicState<TextSearchDialog>
    with UtilsMixin {
  final textCtrl = TextEditingController();

  @override
  void initState() {
    textCtrl.text = widget.initValue ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(widget.title)),
      content: SizedBox(
        height: 200,
        width: 400,
        child: Center(
          child: Form(
            child: TextFormField(
              controller: textCtrl,
              decoration: getDecoration(widget.title, false),
            ),
          ),
        ),
      ),
      actions: [
        saveCancelButtons(
          onSave: () {
            widget.onSave
                ?.call(textCtrl.text.isNotEmpty ? textCtrl.text : null);
          },
          saveLabel: lang.save,
        )
      ],
    );
  }
}
