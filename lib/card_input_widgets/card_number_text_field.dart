import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe_plugin/card_brand.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_stripe_plugin/flutter_stripe_plugin.dart';
import 'package:flutter/services.dart';
import 'masked_text_input_formatter.dart';

class CardNumberTextField extends StatefulWidget {
  CardNumberTextField({
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
  _CardNumberTextFieldState createState() => _CardNumberTextFieldState();
}

class _CardNumberTextFieldState extends State<CardNumberTextField> {
  TextEditingController _controller;
  CardBrand _currentCardBrand = CardBrand.unknown;

  static const String _hintCardNumber = '1234 1234 1234 1234';

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle style = themeData.textTheme.subhead.merge(widget.style);

    return TextField(
      autofocus: widget.autoFocus,
      keyboardType: TextInputType.number,
      maxLines: 1,
      enabled: widget.enable,
      controller: _controller,
      style: widget.labelText == null ? style.copyWith(height: 1.15) : style,
      focusNode: widget.focusNode,
      onChanged: (newValue) async {
        final brand = await FlutterStripePlugin.getCardBrand(
            cardNumber: _controller.text.replaceAll(' ', ''));
        setState(() {
          _currentCardBrand = brand;
        });
        widget.onChanged?.call(newValue);
        if (newValue.length == 19) {
          widget.onCompleted?.call(newValue);
        }
      },
      decoration: widget.decoration.copyWith(
        labelText: widget.labelText,
        hintText: _hintCardNumber,
        errorText: widget.errorText,
        prefixIcon: Icon(_getBrandIcon(brand: _currentCardBrand)),
      ),
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      inputFormatters: [
        MaskedTextInputFormatter(
          mask: '0000 0000 0000 0000',
          separator: ' ',
          whiteListPattern: RegExp(r'\d+'),
        ),
        LengthLimitingTextInputFormatter(19),
      ],
    );
  }

  IconData _getBrandIcon({@required CardBrand brand}) {
    switch (brand) {
      case CardBrand.unknown:
        return FontAwesomeIcons.creditCard;
      case CardBrand.visa:
        return FontAwesomeIcons.ccVisa;
      case CardBrand.mastercard:
        return FontAwesomeIcons.ccMastercard;
      case CardBrand.amex:
        return FontAwesomeIcons.ccAmex;
      case CardBrand.discover:
        return FontAwesomeIcons.ccDiscover;
      case CardBrand.dinersClub:
        return FontAwesomeIcons.ccDinersClub;
      case CardBrand.jcb:
        return FontAwesomeIcons.ccJcb;
      case CardBrand.unionpay:
        return FontAwesomeIcons.solidCreditCard;
    }
    return FontAwesomeIcons.creditCard;
  }
}
