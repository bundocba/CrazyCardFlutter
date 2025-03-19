import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/card_model.dart';
import '../card_data.dart';

class CardService {
  static const String REVEALED_CARDS_KEY = 'revealed_cards';
  static const String CURRENT_DECK_KEY = 'current_deck';
  
  final SharedPreferences _prefs;
  
  CardService(this._prefs);

  Future<List<CardModel>> getDefaultCards() async {
    // Get all cards from CardData class
    final allCards = await CardData.getAllCards();
    
    // Convert CardContent to CardModel
    return allCards.map((content) => CardModel(
      number: content.number,
      task: content.task,
      penalty: content.penalty,
      iconPath: content.iconPath,
    )).toList();
  }

  Future<List<CardModel>> getCurrentDeck() async {
    final String? deckJson = _prefs.getString(CURRENT_DECK_KEY);
    if (deckJson == null) {
      final defaultCards = await getDefaultCards();
      await saveDeck(defaultCards);
      return defaultCards;
    }
    
    final List<dynamic> decoded = json.decode(deckJson);
    return decoded.map((item) => CardModel.fromJson(item)).toList();
  }

  Future<void> saveDeck(List<CardModel> deck) async {
    final encoded = json.encode(deck.map((card) => card.toJson()).toList());
    await _prefs.setString(CURRENT_DECK_KEY, encoded);
  }

  Future<List<CardModel>> getRevealedCards() async {
    final String? cardsJson = _prefs.getString(REVEALED_CARDS_KEY);
    if (cardsJson == null) return [];
    
    final List<dynamic> decoded = json.decode(cardsJson);
    return decoded.map((item) => CardModel.fromJson(item)).toList();
  }

  Future<void> addRevealedCard(CardModel card) async {
    final revealed = await getRevealedCards();
    revealed.add(card);
    
    final encoded = json.encode(revealed.map((card) => card.toJson()).toList());
    await _prefs.setString(REVEALED_CARDS_KEY, encoded);
  }

  Future<void> clearRevealedCards() async {
    await _prefs.remove(REVEALED_CARDS_KEY);
  }
}