class UpdateSupplyfromItemReq {
  final String supplyFormDetailId;
  final String supplyFormDetailItemId;
  final String itemId;
  final int? supplement;
  final String type;
  final String? note;

  UpdateSupplyfromItemReq({
    required this.supplyFormDetailId,
    required this.supplyFormDetailItemId,
    required this.itemId,
    this.supplement,
    required this.type,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'SupplyFormDetailId': supplyFormDetailId,
      'DetailItemId': supplyFormDetailItemId,
      'ItemId': itemId,
      'Supplement': supplement,
      'Type': type,
      'Note': note,
    };
  }
}
