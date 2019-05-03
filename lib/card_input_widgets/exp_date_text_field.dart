import 'package:flutter/material.dart';
import 'masked_text_input_formatter.dart';
import 'package:flutter/services.dart';

class ExpDateTextField extends StatefulWidget {
  ExpDateTextField({
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
    this.errorText,
    this.labelText,
  });

  final bool autoFocus;
  final bool enable;
  final InputDecoration decoration;
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(int, int) onChanged;
  final void Function(int, int) onCompleted;
  final TextStyle style;
  final VoidCallback onEditingComplete;
  final void Function(String) onSubmitted;
  final String labelText;
  final String errorText;

  @override
  _ExpDateTextFieldState createState() => _ExpDateTextFieldState();
}

class _ExpDateTextFieldState extends State<ExpDateTextField> {
  TextEditingController _controller;

  static const String _hintDate = '07/21';

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.enable,
      autofocus: widget.autoFocus,
      controller: _controller,
      focusNode: widget.focusNode,
      keyboardType: TextInputType.number,
      onSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      onChanged: (newValue) async {
        final month = ExpDateTextEditingController._getExpMonth(newValue);
        final year = ExpDateTextEditingController._getExpYear(newValue);
        widget.onChanged?.call(month, year);
        if (newValue.length == 5) {
          widget.onCompleted?.call(month, year);
        }
      },
      decoration: widget.decoration.copyWith(
        labelText: widget.labelText,
        hintText: _hintDate,
        errorText: widget.errorText,
      ),
      inputFormatters: [
        MaskedTextInputFormatter(
          mask: '00/00',
          separator: '/',
          remaskWhenComplete: false,
          whiteListPattern: RegExp(r'\d+'),
        ),
        _ExpDateFormatter(),
        LengthLimitingTextInputFormatter(5),
      ],
    );
  }
}

class ExpDateTextEditingController extends TextEditingController {
  /// Public methods
  int getExpMonth() {
    return _getExpMonth(text);
  }

  int getExpYear() {
    return _getExpYear(text);
  }

  /// Private methods
  static int _getExpMonth(String string) {
    if (string.length > 1) {
      return int.parse(string.substring(0, 2));
    } else if (string.length == 1) {
      return int.parse(string.substring(0, 1));
    } else {
      return null;
    }
  }

  static int _getExpYear(String string) {
    if (string.length == 4) {
      return int.parse(string.substring(3, 4));
    } else if (string.length == 5) {
      return int.parse(string.substring(3, 5));
    } else {
      return null;
    }
  }
}

class _ExpDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > oldValue.text.length &&
        newValue.text.length == 2) {
      if (int.parse(newValue.text.substring(0, 1)) > 1) {
        print('0${newValue.text}');
        return TextEditingValue(
            text:
                '0${newValue.text.substring(0, 1)}/${newValue.text.substring(1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 2,
            ));
      }
    }
    return newValue;
  }
}
