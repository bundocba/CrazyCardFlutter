import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../services/card_service.dart';
import '../card_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _taskController = TextEditingController();
  final _penaltyController = TextEditingController();
  late CardService _cardService;
  int _selectedIconIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeCardService();
  }

  Future<void> _initializeCardService() async {
    final prefs = await SharedPreferences.getInstance();
    _cardService = CardService(prefs);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Get current deck to determine next card number
      final currentDeck = await _cardService.getCurrentDeck();
      int maxNumber = 0;
      for (var card in currentDeck) {
        if (card.number > maxNumber) {
          maxNumber = card.number;
        }
      }

      // Create new card with next number
      final newCard = CardModel(
        number: maxNumber + 1,
        task: "Làm: ${_taskController.text}",
        penalty: "Phạt: ${_penaltyController.text}",
        iconPath: CardData.iconPaths[_selectedIconIndex],
      );

      // Add the card to the deck
      currentDeck.add(newCard);
      await _cardService.saveDeck(currentDeck);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thêm lá bài thành công!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm lá bài mới'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Chọn biểu tượng:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: CardData.iconPaths.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIconIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedIconIndex == index
                                ? Colors.blue
                                : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          CardData.iconPaths[index],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _taskController,
                decoration: const InputDecoration(
                  labelText: 'Nhiệm vụ',
                  border: OutlineInputBorder(),
                  hintText: 'Ví dụ: Hát một bài hát',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nhiệm vụ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _penaltyController,
                decoration: const InputDecoration(
                  labelText: 'Hình phạt',
                  border: OutlineInputBorder(),
                  hintText: 'Ví dụ: Nhảy 10 cái',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập hình phạt';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Thêm lá bài',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    _penaltyController.dispose();
    super.dispose();
  }
}
