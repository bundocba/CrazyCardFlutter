import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../utils/constants.dart';

class CardWidget extends StatelessWidget {
  final CardModel card;
  final bool isRevealed;
  final Animation<double>? flipAnimation;

  const CardWidget({
    Key? key,
    required this.card,
    this.isRevealed = false,
    this.flipAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.cardWidth,
      height: AppConstants.cardHeight,
      child: flipAnimation != null
          ? AnimatedBuilder(
              animation: flipAnimation!,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(flipAnimation!.value * 3.14),
                  alignment: Alignment.center,
                  child: _buildCardContent(),
                );
              },
            )
          : _buildCardContent(),
    );
  }

  Widget _buildCardContent() {
    if (!isRevealed) {
      return _buildCardBack();
    }
    return _buildCardFront();
  }

  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        image: DecorationImage(
          image: AssetImage(AppConstants.cardBackImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            card.iconPath,
            width: AppConstants.cardIconSize,
            height: AppConstants.cardIconSize,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              card.task,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
} 