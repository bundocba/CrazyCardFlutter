import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../utils/constants.dart';

class CardDialog extends StatelessWidget {
  final CardModel card;

  const CardDialog({
    Key? key,
    required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Container(
        width: AppConstants.dialogWidth,
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.borderRadius),
                  topRight: Radius.circular(AppConstants.borderRadius),
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
            ),

            const SizedBox(height: 20),

            // Icon Image
            Image.asset(
              card.iconPath,
              width: AppConstants.dialogIconSize,
              height: AppConstants.dialogIconSize,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            // Task Text
            Padding(
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
            ),

            const SizedBox(height: 12),

            // Penalty Text
            Padding(
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppConstants.borderRadius),
                      bottomRight: Radius.circular(AppConstants.borderRadius),
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
            ),
          ],
        ),
      ),
    );
  }
} 