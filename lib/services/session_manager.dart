import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class SessionManager {
  static const String HIGHEST_CARD_NUMBER_KEY = 'highest_card_number';
  static const String DELETED_CARDS_KEY = 'deleted_cards';
  static const int DEFAULT_CARDS_COUNT = 52;

  static final SessionManager _instance = SessionManager._internal();
  
  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  Future<void> resetSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(HIGHEST_CARD_NUMBER_KEY, DEFAULT_CARDS_COUNT);
    await prefs.remove(AppConstants.deletedCardsKey);
  }

  Future<int> getNextCardNumber() async {
    final prefs = await SharedPreferences.getInstance();
    int highestNumber = prefs.getInt(HIGHEST_CARD_NUMBER_KEY) ?? DEFAULT_CARDS_COUNT;
    int nextNumber = highestNumber + 1;
    await prefs.setInt(HIGHEST_CARD_NUMBER_KEY, nextNumber);
    return nextNumber;
  }

  Future<Set<int>> getDeletedCards() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? deletedCards = prefs.getStringList(AppConstants.deletedCardsKey);
    if (deletedCards == null) return {};
    return deletedCards.map((e) => int.parse(e)).toSet();
  }

  Future<void> addDeletedCard(int cardNumber) async {
    final prefs = await SharedPreferences.getInstance();
    Set<int> deletedCards = await getDeletedCards();
    deletedCards.add(cardNumber);
    await prefs.setStringList(
      AppConstants.deletedCardsKey,
      deletedCards.map((e) => e.toString()).toList(),
    );
  }

  Future<void> addDeletedCards(Set<int> cardNumbers) async {
    final prefs = await SharedPreferences.getInstance();
    final currentDeleted = await getDeletedCards();
    currentDeleted.addAll(cardNumbers);
    await prefs.setStringList(
      AppConstants.deletedCardsKey,
      currentDeleted.map((e) => e.toString()).toList(),
    );
  }
}
