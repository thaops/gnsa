class CardAddReqModel {
  final String supplyFormDetailId;
  final String cartId;
  final int quantity;

  CardAddReqModel({
    required this.supplyFormDetailId,
    required this.cartId,
    required this.quantity,
  });
  Map<String, dynamic> toJson() {
    return {
      'SupplyFormDetailId': supplyFormDetailId,
      'CartId': cartId,
      'Quantity': quantity,
    };
  }
}