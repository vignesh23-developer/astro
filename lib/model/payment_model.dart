class PaymentStatusModel {
  final bool hasEntry;
  final bool hasAdvance;

  PaymentStatusModel({
    required this.hasEntry,
    required this.hasAdvance,
  });

  factory PaymentStatusModel.fromJson(Map<String, dynamic> json) {
    return PaymentStatusModel(
      hasEntry: json['hasEntry'] ?? false,
      hasAdvance: json['hasAdvance'] ?? false,
    );
  }
}