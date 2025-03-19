import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../widgets/card_widget.dart';
import '../widgets/card_dialog.dart';
import '../services/card_service.dart';
import '../services/session_manager.dart';
import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'add_card_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final SessionManager _sessionManager = SessionManager();
  late final CardService _cardService;
  
  List<CardModel> deck = [];
  List<CardModel> revealedCards = [];
  Set<int> deletedCardNumbers = {};
  bool isFlipping = false;
  bool defaultCardsOnly = false;

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    final prefs = await SharedPreferences.getInstance();
    _cardService = CardService(prefs);
    await _loadDeletedCards();
  }

  void _setupAnimation() {
    _flipController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: AppConstants.cardFlipDurationMs),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _loadDeletedCards() async {
    deletedCardNumbers = await _sessionManager.getDeletedCards();
    await _loadAndInitializeDeck();
  }

  Future<void> _loadAndInitializeDeck() async {
    final allCards = await _cardService.getCurrentDeck();
    final revealed = await _cardService.getRevealedCards();
    
    setState(() {
      revealedCards = revealed;
      deck = List.from(allCards.where((card) => 
        !deletedCardNumbers.contains(card.number) && 
        !revealed.any((r) => r.number == card.number)
      ));
      _shuffleDeck();
    });
  }

  void _shuffleDeck() {
    final random = Random();
    deck.shuffle(random);
  }

  void _drawCard() {
    if (deck.isNotEmpty && !isFlipping) {
      isFlipping = true;
      _flipController.forward().then((_) {
        setState(() {
          CardModel drawnCard = deck.removeLast();
          revealedCards.add(drawnCard);
          _cardService.addRevealedCard(drawnCard);
          _showCardDialog(drawnCard);
        });
        _flipController.reset();
        isFlipping = false;
      });
    }
  }

  void _showCardDialog(CardModel card) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CardDialog(card: card),
    );
  }

  void _showCardLogDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final List<CardModel> sortedCards = List.from(revealedCards.reversed);
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Lịch sử lá bài',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: sortedCards.length,
                    itemBuilder: (context, index) {
                      final card = sortedCards[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(
                              card.iconPath,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          title: Text(
                            'Lá bài số ${card.number}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.task,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                card.penalty,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red[700],
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Đóng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRemainingCardsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final List<CardModel> sortedCards = List.from(deck)..sort((a, b) => a.number.compareTo(b.number));
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.orange[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Các lá bài còn lại',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: sortedCards.length,
                    itemBuilder: (context, index) {
                      final card = sortedCards[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(
                              card.iconPath,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          title: Text(
                            'Lá bài số ${card.number}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.task,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                card.penalty,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red[700],
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[800],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Đóng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crazy Card Game'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[700]!, Colors.green[900]!],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (deck.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Hết bài rồi!',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: _drawCard,
                        child: CardWidget(
                          card: deck.last,
                          isRevealed: false,
                          flipAnimation: _flipAnimation,
                        ),
                      ),
                    const SizedBox(height: 20),
                    Text(
                      'Số lá bài còn lại: ${deck.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showRemainingCardsDialog,
                          icon: const Icon(Icons.visibility),
                          label: const Text('Xem bài'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showCardLogDialog,
                          icon: const Icon(Icons.history),
                          label: const Text('Lịch sử'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddCardScreen(),
                              ),
                            ).then((_) => _loadAndInitializeDeck());
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Thêm bài'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await _cardService.clearRevealedCards();
                            setState(() {
                              revealedCards.clear();
                            });
                            await _loadAndInitializeDeck();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Làm mới'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }
}
