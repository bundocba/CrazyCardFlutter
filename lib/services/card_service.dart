import 'dart:convert';
import 'package:shared_preferences.dart';
import '../models/card_model.dart';

class CardService {
  static const String CUSTOM_CARDS_KEY = 'custom_cards';
  final SharedPreferences _prefs;

  CardService(this._prefs);

  Future<List<CardModel>> getAllCards() async {
    // Get default cards
    List<CardModel> defaultCards = await getDefaultCards();
    
    // Get custom cards
    List<CardModel> customCards = await getCustomCards();
    
    // Combine both lists
    return [...defaultCards, ...customCards];
  }

  Future<List<CardModel>> getCustomCards() async {
    final String? customCardsJson = _prefs.getString(CUSTOM_CARDS_KEY);
    if (customCardsJson == null) return [];

    List<dynamic> decoded = json.decode(customCardsJson);
    return decoded.map((item) => CardModel.fromJson(item)).toList();
  }

  Future<void> addCustomCard(CardModel card) async {
    List<CardModel> customCards = await getCustomCards();
    customCards.add(card);

    final String encoded = json.encode(
      customCards.map((card) => card.toJson()).toList()
    );
    await _prefs.setString(CUSTOM_CARDS_KEY, encoded);
  }

  Future<void> removeCustomCard(int index) async {
    List<CardModel> customCards = await getCustomCards();
    if (index >= 0 && index < customCards.length) {
      customCards.removeAt(index);
      final String encoded = json.encode(
        customCards.map((card) => card.toJson()).toList()
      );
      await _prefs.setString(CUSTOM_CARDS_KEY, encoded);
    }
  }
}