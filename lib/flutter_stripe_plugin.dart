import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';

import 'card_brand.dart';
export 'card_brand.dart';

class FlutterStripePlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_stripe_plugin');

  static void initialize({@required String apiKey}) {
    _channel.invokeMethod<void>('initialize', apiKey);
  }

  static Future<String> getCardToken({
    @required String cardNumber,
    @required int expMonth,
    @required int expYear,
    @required String cvc,
  }) async {
    return await _channel.invokeMethod<String>(
      'getCardToken',
      <String, dynamic>{
        'card_number': cardNumber,
        'exp_month': expMonth,
        'exp_year': expYear,
        'cvc': cvc,
      },
    );
  }

  static Future<CardBrand> getCardBrand({
    @required String cardNumber,
  }) async {
    final brandStr =
        await _channel.invokeMethod<String>('getCardBrand', cardNumber);
    return cardBrandFromString(brandStr);
  }

  static Future<bool> validateCardNumber({
    @required String cardNumber,
  }) async {
    return await _channel.invokeMethod<bool>('validateCardNumber', cardNumber);
  }

  static Future<bool> validateExpMonth({
    @required int expMonth,
  }) async {
    return await _channel.invokeMethod<bool>('validateExpMonth', expMonth);
  }

  static Future<bool> validateExpDate(
      {@required int expMonth, @required int expYear}) async {
    return await _channel.invokeMethod<bool>(
      'validateExpDate',
      <String, int>{
        'exp_month': expMonth,
        'exp_year': expYear,
      },
    );
  }

  static Future<bool> validateCvc({
    @required String cvc,
  }) async {
    return await _channel.invokeMethod<bool>('validateCvc', cvc);
  }
}
