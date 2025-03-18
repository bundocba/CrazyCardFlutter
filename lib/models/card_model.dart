class CardModel {
  final String challenge;
  final String penalty;
  final int iconIndex;
  final bool isCustomCard; // New field

  CardModel({
    required this.challenge,
    required this.penalty,
    required this.iconIndex,
    this.isCustomCard = false, // Default to false for original 52 cards
  });

  Map<String, dynamic> toJson() {
    return {
      'challenge': challenge,
      'penalty': penalty,
      'iconIndex': iconIndex,
      'isCustomCard': isCustomCard,
    };
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      challenge: json['challenge'],
      penalty: json['penalty'],
      iconIndex: json['iconIndex'],
      isCustomCard: json['isCustomCard'] ?? false,
    );
  }
}