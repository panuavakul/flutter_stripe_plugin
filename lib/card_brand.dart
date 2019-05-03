enum CardBrand {
  visa,
  mastercard,
  amex,
  discover,
  dinersClub,
  jcb,
  unionpay,
  unknown
}

CardBrand cardBrandFromString(String brandStr) {
  switch (brandStr) {
    case 'Visa':
      return CardBrand.visa;
    case 'MasterCard':
      return CardBrand.mastercard;
    case 'American Express':
      return CardBrand.amex;
    case 'Discover':
      return CardBrand.discover;
    case 'Diners Club':
      return CardBrand.dinersClub;
    case 'JCB':
      return CardBrand.jcb;
    case 'UnionPay':
      return CardBrand.unionpay;
    default:
      return CardBrand.unknown;
  }
}
