import 'package:flutter/material.dart';
import 'package:crazy_card_bun/card_content.dart';
import 'package:crazy_card_bun/card_data.dart';
import 'package:crazy_card_bun/services/session_manager.dart';

class AddCardScreen extends StatefulWidget {
  final Function(CardContent)? onCardAdded;
  
  const AddCardScreen({
    super.key, 
    this.onCardAdded,
  });

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _taskController = TextEditingController();
  final _penaltyController = TextEditingController();
  final _numberController = TextEditingController();
  String _selectedIconPath = 'assets/image/icon/Icon1.jpg'; // default icon
  final SessionManager _sessionManager = SessionManager();

  final List<String> _iconOptions = [
    'assets/image/icon/Icon1.jpg',
    'assets/image/icon/Icon2.jpg',
    'assets/image/icon/Icon3.jpg',
    'assets/image/icon/Icon4.jpg',
    'assets/image/icon/Icon5.jpg',
    'assets/image/icon/Icon6.jpg',
    'assets/image/icon/Icon7.jpg',
    'assets/image/icon/Icon8.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _suggestNextCardNumber();
  }

  Future<void> _suggestNextCardNumber() async {
    final nextNumber = await _sessionManager.getNextCardNumber();
    _numberController.text = nextNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Card'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Card Description',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _taskController,
                decoration: const InputDecoration(
                  labelText: 'Task',
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _penaltyController,
                decoration: const InputDecoration(
                  labelText: 'Penalty',
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a penalty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a card number';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedIconPath,
                decoration: const InputDecoration(
                  labelText: 'Select Icon',
                ),
                items: _iconOptions.map((String iconPath) {
                  return DropdownMenuItem<String>(
                    value: iconPath,
                    child: Row(
                      children: [
                        Image.asset(
                          iconPath,
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 10),
                        Text(iconPath.split('/').last),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedIconPath = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newCard = CardContent(
                      number: int.parse(_numberController.text),
                      task: _taskController.text,
                      penalty: _penaltyController.text,
                      iconPath: _selectedIconPath,
                    );
                    await CardData.addCard(newCard);
                    if (widget.onCardAdded != null) {
                      widget.onCardAdded!(newCard);
                    }
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Add Card'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _taskController.dispose();
    _penaltyController.dispose();
    _numberController.dispose();
    super.dispose();
  }
}
