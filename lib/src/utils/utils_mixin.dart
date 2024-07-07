import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:meeting_planner/src/settings/lang.dart';
import 'package:meeting_planner/src/utils/alert_vertical_widget.dart';
import 'package:meeting_planner/src/utils/progress_wrapper.dart';
import 'package:rxdart/rxdart.dart';

mixin UtilsMixin<T extends StatefulWidget> on BasicState<T> {
  final progressSubject = BehaviorSubject.seeded(false);
  int _startHour = 8;
  int _endHour = 20;
  InputDecoration getDecoration(String label, bool required,
          {String? hinttext,
          Widget? suffixIcon,
          OutlineInputBorder? border,
          Widget? labelWidget}) =>
      InputDecoration(
        suffixIcon: suffixIcon,
        border: border ?? const OutlineInputBorder(),
        label: labelWidget != null ? labelWidget : getLabel(label, required),
        hintText: hinttext,
      );

  Widget getLabel(String label, bool required) {
    return required
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label),
              const Gap(15),
              const Text(
                "*",
                style: TextStyle(color: Colors.red),
              ),
            ],
          )
        : Text(label);
  }

  Future<SnackBarClosedReason> showSnackBar2(
      BuildContext context, String content) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(content),
            action: SnackBarAction(
              label: lang.ok.toUpperCase(),
              onPressed: () {},
            ),
          ),
        )
        .closed;
  }

  Stream confirm(String title, String message) {
    return showAlertDialog(
            context: context,
            title: title,
            message: message,
            actions: getOkCancel())
        .asStream()
        .where((event) => event == true);
  }

  Future showAlertDialog(
      {required BuildContext context,
      String? title,
      String? message,
      List<Widget>? actions}) async {
    var lang = getLang(context);
    var result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? ""),
        content: SizedBox(
          height: 300,
          width: 300,
          child: AlertVerticalWidget(
            message ?? "",
            type: AlertType.WARNING,
            iconData: Icons.warning,
            iconSize: 64,
            margin: 10,
            color: Colors.red,
          ),
        ),
        actions: (actions?.isEmpty ?? true)
            ? <Widget>[
                TextButton(
                  child: Text(lang.ok.toUpperCase()),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ]
            : actions,
      ),
    );
    return result;
  }

  Future<void> showConfirmDialog(Widget textButton, {String? message}) async {
    return showAlertDialog(
      context: context,
      title: lang.pleaseConfirm,
      message: message ?? lang.confirmDelete,
      actions: <Widget>[
        TextButton(
          child: Text(lang.no.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        textButton,
      ],
    );
  }

  Widget getOkButton() => TextButton(
      onPressed: () => Navigator.of(context).pop(true), child: Text(lang.ok));

  Widget getCancelButton() => TextButton(
      onPressed: () => Navigator.of(context).pop(false),
      child: Text(lang.cancel));

  List<Widget> getOkCancel() => [getCancelButton(), getOkButton()];

  Widget saveCancelButtons({
    Function()? onCancel,
    required Function()? onSave,
    String? saveLabel,
    String? cancelLabel,
    Stream<bool>? progressStream,
    bool skipCancel = false,
    bool elevatedCancelButton = false,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.end,
  }) =>
      Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (!skipCancel) ...[
            elevatedCancelButton
                ? ElevatedButton(
                    onPressed: onCancel ?? Navigator.of(context).pop,
                    child: Text(cancelLabel ?? lang.cancel.toUpperCase()),
                  )
                : OutlinedButton(
                    onPressed: onCancel ?? Navigator.of(context).pop,
                    child: Text(cancelLabel ?? lang.cancel.toUpperCase()),
                  ),
            Gap(16),
          ],
          ProgressWrapper(
            progressStream: progressStream ?? progressSubject,
            child: _getSaveButton(saveLabel, onSave),
            progressChild: _getSaveButton(saveLabel, null),
          ),
        ],
      );

  Widget _getSaveButton(String? label, Function()? onPressed) {
    return FilledButton(
        onPressed: onPressed,
        child: Text(
          label ?? lang.save.toUpperCase(),
        ));
  }

  void updateStartEndHours({required int startHour, required int endHour}) {
    setState(() {
      _startHour = startHour;
      _endHour = endHour;
    });
  }

  int get startHour => _startHour;
  int get endHour => _endHour;
  List<int> get weekend => [6, 7];
}
