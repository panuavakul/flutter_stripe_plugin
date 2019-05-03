package com.panuavakul.flutterstripeplugin.flutter_stripe_plugin

import android.util.Log
import com.stripe.android.SourceCallback
import com.stripe.android.exception.InvalidRequestException
import com.stripe.android.model.Card
import com.stripe.android.model.Source
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.lang.Exception

class FlutterStripePlugin(_registrar: Registrar): MethodCallHandler {
  private val registrar = _registrar
  private var stripeService: StripeService? = null

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "flutter_stripe_plugin")
      channel.setMethodCallHandler(FlutterStripePlugin(registrar))
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method){
      "initialize" -> {
        val stripeKey = call.arguments as String
        stripeService = StripeService(registrar, stripeKey)
      }
      "getCardToken" -> {
        try {
          if (stripeService == null){
            result.error("STRIPE_ERROR", "SERVICE_NOT_INITIALIZED", "initialize() have yet to be called")
            return
          }

          val cardNumber = call.argument<String>("card_number")
          val expMonth = call.argument<Int>("exp_month")
          val expYear = call.argument<Int>("exp_year")
          val cvc = call.argument<String>("cvc")

          val card = stripeService!!.createCard(cardNumber!!, expMonth!!, expYear!!, cvc!!)

          if (card.validateCard()) {
            stripeService!!.createCardToken(card, object: SourceCallback{
              override fun onSuccess(source: Source) {
                result.success(source?.id)
              }

              override fun onError(error: Exception) {
                if (error is InvalidRequestException){
                  /// Send back the API error to flutter
                  /// The error could should be found here
                  /// https://stripe.com/docs/error-codes
                  result.error("STRIPE_ERROR", error.errorCode, error.statusCode)
                } else {
                  /// Get something other than API error
                  result.error("STRIPE_ERROR", error.message, "This error is thrown when Stripe SDK return an Error that isn't an API error")
                }
              }
            })
          } else {
            result.error("STRIPE_ERROR", "CARD_ERROR", "The given card information cannot be validated")
          }

        } catch (error: Exception){
          result.error("STRIPE_UNEXPECTED_ERROR", error.toString(), "Some thing went wrong when getting card token")
        }
      }
      "getCardBrand" -> {
        try {
          val cardNumber = call.arguments as String
          val card = Card(cardNumber, null, null, null)
          result.success(card.brand)
        } catch (error: Exception) {
          result.error("STRIPE_UNEXPECTED_ERROR", error.toString(), "Some thing went wrong when checking card brand")
        }
      }
      "validateCardNumber" -> {
        val cardNumber = call.arguments as String
        val validation = validateValue(cardNumber, null, null, null)
        result.success(validation)
      }
      "validateExpMonth" -> {
        val expMonth = call.arguments as Int
        val validation = validateValue(null, expMonth, null, null)
        result.success(validation)
      }
      "validateExpDate" -> {
        val expMonth = call.argument<Int>("exp_month")
        val expYear = call.argument<Int>("exp_year")
        val validation = validateValue(null, expMonth, expYear, null)
        result.success(validation)
      }
      "validateCvc" -> {
        val cvc = call.arguments as String
        val validation = validateValue(null, null, null, cvc)
        result.success(validation)
      }
      else -> result.notImplemented()
    }
  }

  private fun validateValue(cardNumber: String?, expMonth: Int?, expYear: Int?, cvc: String?): Boolean? {
    val card = Card(cardNumber, expMonth, expYear, cvc)

    if (cardNumber != null) {
      return card.validateNumber()
    }

    if (expMonth != null && expYear == null) {
      return card.validateExpMonth()
    }

    if (expMonth != null && expYear != null) {
      return card.validateExpiryDate()
    }

    if (cvc != null) {
      return card.validateCVC()
    }

    /// Impossible case
    return null
  }
}
