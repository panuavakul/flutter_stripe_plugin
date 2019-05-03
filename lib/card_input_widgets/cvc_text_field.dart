import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CvcTextField extends StatefulWidget {
  CvcTextField({
    this.autoFocus = false,
    this.enable = true,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.onChanged,
    this.onCompleted,
    this.style,
    this.onEditingComplete,
    this.onSubmitted,
    this.labelText,
    this.errorText,
  });

  final bool autoFocus;
  final bool enable;
  final InputDecoration decoration;
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onChanged;
  final void Function(String) onCompleted;
  final TextStyle style;
  final VoidCallback onEditingComplete;
  final void Function(String) onSubmitted;
  final String labelText;
  final String errorText;

  @override
  _CvcTextFieldState createState() => _CvcTextFieldState();
}

class _CvcTextFieldState extends State<CvcTextField> {
  static const String _hintCvs = '123';

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: widget.autoFocus,
      enabled: widget.enable,
      controller: _controller,
      focusNode: widget.focusNode,
      keyboardType: TextInputType.number,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      style: widget.style,
      onChanged: (newValue) async {
        widget.onChanged?.call(newValue);
        if (newValue.length == 3) {
          widget.onCompleted?.call(newValue);
        }
      },
      decoration: widget.decoration.copyWith(
        labelText: widget.labelText,
        hintText: _hintCvs,
        errorText: widget.errorText,
      ),
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
    );
  }
}
