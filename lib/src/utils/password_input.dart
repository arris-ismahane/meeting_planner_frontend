import 'package:flutter/material.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:rxdart/rxdart.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController? controller;
  final Widget? label;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final bool autoFocus;
  final bool enabled;
  const PasswordInput({
    Key? key,
    this.controller,
    this.label,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autoFocus = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends BasicState<PasswordInput> {
  final _subject = BehaviorSubject.seeded(true);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _subject,
        initialData: _subject.value,
        builder: (context, snapshot) {
          final obscure = snapshot.data!;

          return TextFormField(
            autofocus: widget.autoFocus,
            onFieldSubmitted: widget.onFieldSubmitted,
            obscureText: obscure,
            controller: widget.controller,
            validator: widget.validator,
            textInputAction: widget.textInputAction,
            enabled: widget.enabled,
            decoration: InputDecoration(
              label: widget.label,
              border: const OutlineInputBorder(),
              suffix: InkWell(
                child: _getIcon(obscure),
                onTap: () => _subject.add(!obscure),
              ),
            ),
          );
        });
  }

  Widget _getIcon(bool obscure) {
    return Icon(
      obscure ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
      size: 16,
    );
  }

  @override
  List<ChangeNotifier> get notifiers => [];

  @override
  List<Subject> get subjects => const [];
}
