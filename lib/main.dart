import 'package:flutter/material.dart';
import 'dart:math';
import 'card_data.dart';
import 'card_content.dart';
import 'services/session_manager.dart';  // Updated import
import 'package:crazy_card_bun/screens/add_card_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final SessionManager _sessionManager = SessionManager();
  static const String cardBackImage = 'assets/image/Game_Board.png';
  List<CardContent> deck = [];
  List<CardContent> revealedCards = [];
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool isFlipping = false;
  Set<int> deletedCardNumbers = {};
  // Add flag to track if we want default cards only
  bool defaultCardsOnly = false;

  @override
  void initState() {
    super.initState();
    _loadDeletedCards();
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
  }

  Future<void> _loadDeletedCards() async {
    deletedCardNumbers = await _sessionManager.getDeletedCards();
    await _loadAndInitializeDeck();
  }

  Future<void> _loadAndInitializeDeck() async {
    final allCards = await CardData.getAllCards();
    setState(() {
      // Filter out both deleted cards and revealed cards
      deck = List.from(allCards.where((card) => 
        !deletedCardNumbers.contains(card.number) && 
        !revealedCards.any((revealed) => revealed.number == card.number)
      ));
      _shuffleDeck();
    });
  }

  void _shuffleDeck() {
    final random = Random();
    deck.shuffle(random);  // Using built-in shuffle method
  }

  void _initializeDeck() {
    _loadAndInitializeDeck();
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _drawCard() {
    if (deck.isNotEmpty && !isFlipping) {
      isFlipping = true;
      
      // Get screen size and center point
      final screenSize = MediaQuery.of(context).size;
      final centerPoint = Offset(screenSize.width / 2, screenSize.height / 2);

      // Start flip animation
      _flipController.forward().then((_) {
        setState(() {
          CardContent drawnCard = deck.removeLast();
          revealedCards.add(drawnCard);
          
          // Show the dialog after the card is drawn
          _showCardDialog(drawnCard);
        });
        _flipController.reset();
        isFlipping = false;
      });
    }
  }

  void _showCardDialog(CardContent card) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: 280,  // Slightly wider than the card
            padding: const EdgeInsets.all(0), // Remove padding
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
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
                      fontSize: 22,  // Increased size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Icon Image
                Image.asset(
                  card.iconPath,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 20),

                // Task Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    card.task,
                    style: const TextStyle(
                      fontSize: 18,  // Increased size
                      fontWeight: FontWeight.bold,  // Made bold
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 12),

                // Penalty Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    card.penalty,
                    style: const TextStyle(
                      fontSize: 16,  // Increased size
                      fontWeight: FontWeight.bold,  // Made bold
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 20),

                // Close Button
                Container(
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
                        fontSize: 18,  // Increased size
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildCard(CardContent card) {
    return Container(
      width: 200,
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Card Header
          Container(
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
                fontSize: 20,  // Increased size
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              children: [
                // Icon Image
                Image.asset(
                  card.iconPath,
                  width: 120,  // Increased size
                  height: 120, // Increased size
                  fit: BoxFit.contain,
                ),
                
                const SizedBox(height: 20),
                
                // Task Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    card.task,
                    style: const TextStyle(
                      fontSize: 16,  // Increased size
                      fontWeight: FontWeight.bold,  // Made bold
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Penalty Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    card.penalty,
                    style: const TextStyle(
                      fontSize: 14,  // Increased size
                      fontWeight: FontWeight.bold,  // Made bold
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 200,
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            'assets/image/Game_Board.png',  // Updated path
            width: 200,
            height: 280,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading image: $error');
              return Container(
                width: 200,
                height: 280,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCardLogDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create a reversed list to show newest items first
        final List<CardContent> sortedCards = List.from(revealedCards.reversed);
        
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Lịch sử lá bài',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: sortedCards.length,
                    itemBuilder: (context, index) {
                      final card = sortedCards[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Card Header
                            Container(
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // Card Content
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  // Icon Image
                                  Image.asset(
                                    card.iconPath,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 12),
                                  // Task Text
                                  Text(
                                    card.task,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  // Penalty Text
                                  Text(
                                    card.penalty,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Đóng',
                    style: TextStyle(
                      color: Colors.white,
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
    List<CardContent> displayedCards = List<CardContent>.from(deck)
      ..sort((a, b) => a.number.compareTo(b.number));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(16),
                color: Colors.white, // Added white background
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Remaining Cards',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            Set<int> cardsToDelete = displayedCards.map((card) => card.number).toSet();
                            await _sessionManager.addDeletedCards(cardsToDelete);
                            setState(() {
                              deletedCardNumbers.addAll(cardsToDelete);
                              displayedCards.clear();
                              this.setState(() {
                                deck.clear();
                              });
                            });
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Delete All',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                      ),
                      color: Colors.white, // Added white background
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: displayedCards.length,
                        itemBuilder: (context, index) {
                          final card = displayedCards[index];
                          return Dismissible(
                            key: Key(card.number.toString() + DateTime.now().toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              setState(() {
                                // Add the card number to deletedCardNumbers set
                                deletedCardNumbers.add(card.number);
                                displayedCards.removeAt(index);
                                this.setState(() {
                                  deck.removeWhere((item) => item.number == card.number);
                                });
                              });
                              if (displayedCards.isEmpty) {
                                Navigator.pop(context);
                              }
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              color: Colors.white, // Added white background
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Card ${card.number}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              displayedCards.removeAt(index);
                                              this.setState(() {
                                                deck.removeWhere((item) => item.number == card.number);
                                              });
                                            });
                                            if (displayedCards.isEmpty) {
                                              Navigator.pop(context);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      card.task,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      card.penalty,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[900]!, Colors.blue[300]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Remaining: ${deck.length}',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // View Cards button
              Center(
                child: ElevatedButton.icon(
                  onPressed: _showRemainingCardsDialog,
                  icon: const Icon(Icons.list),
                  label: const Text('View Cards'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[900],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Reduced space between button and card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0), // Added small padding
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _flipAnimation,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(_flipAnimation.value * pi),
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: _drawCard,
                            child: deck.isEmpty
                                ? Container(
                                    width: 200,
                                    height: 280,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Empty',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                  )
                                : _buildCardBack(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Reduced space between card and bottom buttons
              // Bottom buttons with reduced padding
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddCardScreen(
                              onCardAdded: (newCard) async {
                                await _loadAndInitializeDeck();
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add New'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _showCardLogDialog,
                      icon: const Icon(Icons.history),
                      label: const Text('History'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await _sessionManager.resetSession();
                        setState(() {
                          revealedCards.clear();
                          deletedCardNumbers.clear();
                        });
                        await _loadAndInitializeDeck();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
