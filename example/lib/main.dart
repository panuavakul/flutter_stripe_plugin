import 'package:flutter/material.dart';
import 'package:flutter_stripe_plugin/flutter_stripe_plugin.dart';
import 'package:flutter_stripe_plugin/card_input_widgets/card_number_text_field.dart';
import 'package:flutter_stripe_plugin/card_input_widgets/exp_date_text_field.dart';
import 'package:flutter_stripe_plugin/card_input_widgets/cvc_text_field.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  final _expDateController = ExpDateTextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: <Widget>[
                CardNumberTextField(),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ExpDateTextField(
                        controller: _expDateController,
                        errorText: 'Invalid date',
                      ),
                    ),
                    Container(width: 16),
                    Expanded(
                      child: CvcTextField(),
                    )
                  ],
                ),
                FlatButton(
                  onPressed: () {
                    print(_expDateController.getExpMonth());
                    print(_expDateController.getExpYear());
                  },
                  child: Text('Print Exp Date'),
                ),
                FlatButton(
                  onPressed: () {
                    FlutterStripePlugin.initialize(
                      apiKey: 'pk_test_k6Ct74hTMePKE2GX5QN2jt3900EqBzXe7X',
                    );
                  },
                  child: Text('Set Key'),
                ),
                FlatButton(
                  onPressed: () async {
                    final token = await FlutterStripePlugin.getCardToken(
                      cardNumber: '424242424242',
                      expMonth: 99,
                      expYear: 2021,
                      cvc: '123',
                    );
                    print(token);
                  },
                  child: Text('Get token'),
                ),
                FlatButton(
                  onPressed: () async {
                    final brand = await FlutterStripePlugin.getCardBrand(
                      cardNumber: '6200',
                    );
                    print(brand);
                  },
                  child: Text('Get token'),
                ),
                FlatButton(
                  onPressed: () async {
                    final validate =
                        await FlutterStripePlugin.validateCardNumber(
                      cardNumber: '4242424242424242',
                    );
                    print(validate);
                  },
                  child: Text('Validate Number'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
