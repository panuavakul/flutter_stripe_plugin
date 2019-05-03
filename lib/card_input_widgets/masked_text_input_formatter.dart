import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shamelessly copied and modified from
/// https://gist.github.com/sebdeveloper6952/4c7a10faa4fd45bce56e91e9b07b80ee
class MaskedTextInputFormatter extends TextInputFormatter {
  MaskedTextInputFormatter({
    @required this.mask,
    @required this.separator,
    this.remaskWhenComplete = true,
    this.whiteListPattern,
  }) {
    assert(mask != null);
    assert(separator != null);
  }

  /// The mask for this text
  /// eg. 0000 0000 0000 0000
  final String mask;

  /// The seperator for this mask
  /// eg. /
  final String separator;

  /// Should remask the whole string when it is completed
  final bool remaskWhenComplete;

  /// Which pattern to allow
  final RegExp whiteListPattern;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length > 0) {
      /// Check if insert or erase
      if (newValue.text.length > oldValue.text.length) {
        /// Check if the last input character match the white list
        if (whiteListPattern != null) {
          if (!newValue.text
              .substring(newValue.text.length - 1)
              .contains(whiteListPattern)) {
            return oldValue;
          }
        }
        if (newValue.text.length > mask.length) {
          return oldValue;
        } else if (newValue.text.length == mask.length && remaskWhenComplete) {
          /// If the whole text is entered then remask the string
          final rawText = newValue.text.replaceAll(separator, '');

          var index = 0;
          final maskedString = mask.split('').map((templateChar) {
            if (templateChar == separator) {
              return separator;
            } else {
              final character = rawText[index];
              index += 1;
              return character;
            }
          }).join('');

          return TextEditingValue(
            text: maskedString,
            selection: TextSelection.collapsed(
              offset: newValue.selection.end,
            ),
          );
        } else if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      } else {
        /// When erasing if the last character is the separator when remove the separator
        if (newValue.text.endsWith(separator) && newValue.text.length > 1) {
          return newValue.copyWith(
            text: newValue.text.substring(0, newValue.text.length - 1),
            selection: TextSelection.collapsed(
              offset: newValue.selection.end - 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}
