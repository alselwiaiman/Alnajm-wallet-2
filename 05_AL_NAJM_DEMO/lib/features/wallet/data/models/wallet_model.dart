import '../../domain/entities/wallet_entity.dart';

class WalletModel extends WalletEntity {
  WalletModel({
    required super.id,
    required super.userId,
    required super.balance,
    required super.currency,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      balance: (json['balance'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'balance': balance,
      'currency': currency,
    };
  }
}
