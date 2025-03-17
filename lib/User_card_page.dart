// lib/pages/user_cards_page.dart

import 'package:flutter/material.dart';

import 'constants.dart';


class UserCardsPage extends StatelessWidget {
  final String userId;
  final List<CardModel> cards;
  const UserCardsPage({super.key, required this.userId, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Карточки пользователя')),
      body: cards.isEmpty
          ? const Center(child: Text('Нет карточек у этого пользователя.'))
          : ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(card.title),
              subtitle: Text(card.description),
              // Можно добавить изображение или другие данные
            ),
          );
        },
      ),
    );
  }
}