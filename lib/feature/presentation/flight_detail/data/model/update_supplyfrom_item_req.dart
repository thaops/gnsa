class UpdateSupplyfromItemReq {
  final String supplyFormDetailId;
  final String supplyFormDetailItemId;
  final String itemId;
  final int? supplement;
  final String? note;

  UpdateSupplyfromItemReq({
    required this.supplyFormDetailId,
    required this.supplyFormDetailItemId,
    required this.itemId,
    this.supplement,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'SupplyFormDetailId': supplyFormDetailId,
      'SupplyFormDetailItemId': supplyFormDetailItemId,
      'ItemId': itemId,
      'Supplement': supplement,
      'Note': note,
    };
  }
}
