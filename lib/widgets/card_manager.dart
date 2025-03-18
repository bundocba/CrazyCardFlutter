import 'package:flutter/material.dart';
import 'dart:math';
import '../card_content.dart';
import '../card_data.dart';

class CardManager extends StatefulWidget {
  const CardManager({super.key});

  @override
  State<CardManager> createState() => _CardManagerState();
}

class _CardManagerState extends State<CardManager> with TickerProviderStateMixin {
  static const String cardBackImage = 'assets/image/Game_Board.png';
  List<CardContent> deck = [];
  List<CardContent> revealedCards = [];
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool isFlipping = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOut,
      ),
    );
    _loadAndInitializeDeck();
  }

  Future<void> _loadAndInitializeDeck() async {
    final allCards = await CardData.getAllCards();
    setState(() {
      deck = List.from(allCards);
      _shuffleDeck();
    });
  }

  void _shuffleDeck() {
    final random = Random();
    deck.shuffle(random);
  }

  void _initializeDeck() {
    _loadAndInitializeDeck();
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _drawCard(BuildContext context) {
    if (deck.isNotEmpty && !isFlipping) {
      isFlipping = true;
      
      final screenSize = MediaQuery.of(context).size;
      final centerPoint = Offset(screenSize.width / 2, screenSize.height / 2);

      _flipController.forward().then((_) {
        setState(() {
          CardContent drawnCard = deck.removeLast();
          revealedCards.add(drawnCard);
          _showCardDialog(context, drawnCard);
        });
        _flipController.reset();
        isFlipping = false;
      });
    }
  }

  void _showCardDialog(BuildContext context, CardContent card) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogHeader(card),
                const SizedBox(height: 20),
                _buildCardIcon(card),
                const SizedBox(height: 20),
                _buildTaskText(card),
                const SizedBox(height: 12),
                _buildPenaltyText(card),
                const SizedBox(height: 20),
                _buildCloseButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogHeader(CardContent card) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue[900],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Text(
        'Lá bài số ${card.number}',
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCardIcon(CardContent card) {
    return Image.asset(
      card.iconPath,
      width: 120,
      height: 120,
      fit: BoxFit.contain,
    );
  }

  Widget _buildTaskText(CardContent card) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        card.task,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPenaltyText(CardContent card) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        card.penalty,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.red,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
        ),
        child: Text(
          'Đóng',
          style: TextStyle(
            fontSize: 18,
            color: Colors.blue[900],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void resetGame() {
    setState(() {
      revealedCards.clear();
      _loadAndInitializeDeck();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: resetGame,
              child: const Text('Reset Game'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCustomCardScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Add Custom Card'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _drawCard(context),
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(pi * _flipAnimation.value),
            alignment: Alignment.center,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                cardBackImage,
                width: 200,
                height: 280,
                fit: BoxFit.cover,
              ),
            ),
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
    );
  }
}
