package com.panuavakul.flutterstripeplugin.flutter_stripe_plugin

import com.stripe.android.SourceCallback
import com.stripe.android.Stripe
import com.stripe.android.model.Card
import com.stripe.android.model.SourceParams
import io.flutter.plugin.common.PluginRegistry.Registrar


class StripeService(registrar: Registrar, stripeApiKey: String) {
    private val stripe = Stripe(registrar.context(), stripeApiKey)

    fun createCardToken(card: Card, completion: SourceCallback) {
        stripe.createSource(SourceParams.createCardParams(card), completion)
    }

    fun createCard(cardNumber: String, expMonth: Int, expYear: Int, cvc: String) : Card {
        return Card(cardNumber, expMonth, expYear, cvc)
    }
}
