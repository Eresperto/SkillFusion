import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'main.dart';


/// Supabase client
//final supabase = Supabase.instance.client;

/// Simple preloader inside a Center widget
const preloader =
Center(child: CircularProgressIndicator(color: Colors.cyan));

/// Simple sized box to space out form elements
const formSpacer = SizedBox(width: 16, height: 16);

/// Some padding for all the forms to use
const formPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);

/// Error message to display the user when unexpected error occurs.
const unexpectedErrorMessage = 'Unexpected error occurred.';

/// Basic theme to change the look and feel of the app
final appTheme = ThemeData.light().copyWith(
  primaryColorDark: CustomTheme.lightTheme.secondaryHeaderColor,
  appBarTheme: const AppBarTheme(
    elevation: 1,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18,
    ),
  ),
  primaryColor: CustomTheme.lightTheme.primaryColor,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: CustomTheme.lightTheme.secondaryHeaderColor,
    ),
  ),
  // elevatedButtonTheme: ElevatedButtonThemeData(
  //   style: ElevatedButton.styleFrom(
  //     foregroundColor: Colors.white,
  //     backgroundColor: CustomTheme.lightTheme.primaryColor,
  //   ),
  // ),
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle:  TextStyle(
      color: CustomTheme.lightTheme.secondaryHeaderColor,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 2,
      ),
    ),
    focusColor: CustomTheme.lightTheme.primaryColor,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.black,
        width: 2,
      ),
    ),
  ),
  bottomAppBarTheme: BottomAppBarTheme(

  ),

);

/// Set of extension methods to easily display a snackbar
extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  // void showSnackBar({
  //   required String message,
  //   Color backgroundColor = Colors.white,
  // }) {
  //   ScaffoldMessenger.of(this).showSnackBar(SnackBar(
  //     content: Text(message),
  //     backgroundColor: backgroundColor,
  //   ));
  // }

  /// Displays a red snackbar indicating error
  // void showErrorSnackBar({required String message}) {
  //   showSnackBar(message: message, backgroundColor: Colors.blue);
  // }
}
// lib/services/card_service.dart

// lib/models/card_model.dart

class CardModel {
  final String id;
  final String owner_id;
  final String title;
  final String description;
  //final String? imageUrl;
 // final List<String> tags;
  final DateTime createdAt;

  CardModel({
    required this.id,
    required this.owner_id,
    required this.title,
    required this.description,
   // this.imageUrl,
    required this.createdAt,
  });

  /// Фабричный конструктор для создания экземпляра CardModel из JSON
  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as String,
      owner_id: json['owner_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
     // imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}


class CardService {
  final SupabaseClient _supabaseClient;

  CardService(this._supabaseClient);

  /// Получение карточек других пользователей
  Future<List<CardModel>> fetchOtherUsersCards(String currentUserId) async {
    try {
      final response = await _supabaseClient
          .from('cards')
          .select()
          .neq('owner_id', currentUserId)
          .order('created_at', ascending: false)
          /*.execute()*/;


      final data = response/*.data*/ as List<dynamic>;
      return data.map((json) => CardModel.fromJson(json)).toList();
    } catch (e) {
      // Обработка ошибок (можно логировать или показывать пользователю)
      rethrow;
    }
  }
  /// Получение собственных карточек пользователя
  // Future<List<CardModel>> fetchMyCards(String currentUserId) async {
  //   try {
  //     final response = await _supabaseClient
  //         .from('cards')
  //         .select()
  //         .eq('owner_id', currentUserId)
  //         .order('created_at', ascending: false)
  //         .get(); // Заменили execute() на get()
  //
  //     if (response.error != null) {
  //       throw response.error!;
  //     }
  //
  //     final data = response.data as List<dynamic>;
  //     return data.map((json) => CardModel.fromJson(json)).toList();
  //   } catch (e) {
  //     // Здесь можно добавить дополнительную обработку ошибок, например, логирование
  //     rethrow;
  //   }
  // }
  Future<List<CardModel>> fetchMyCards(String currentUserId) async {
    try {
      final response = await _supabaseClient
          .from('cards')
          .select()
          .eq('owner_id', currentUserId)
          .order('created_at', ascending: false)
          /*.execute()*/; // Используем execute()
      final data = response/*.data*/ as List<dynamic>;
      return data.map((json) => CardModel.fromJson(json)).toList();
    } catch (e) {
      // Обработка ошибок (можно логировать или показывать пользователю)
      rethrow;
    }
  }

  Future<List<CardModel>> getUserCards(String userId) async {
    try {
      final response = await _supabaseClient
          .from('cards')
          .select()
          .eq('owner_id', userId)
          .order('created_at', ascending: false)
          /*.execute()*/;

      final data = response/*.data*/ as List<dynamic>;
      return data.map((json) => CardModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Создание новой карточки
  Future<void> createCard({
    required String ownerId,
    required String title,
    required String description,
   // String? imageUrl,
    //required List<String> tags
  }) async {
    try {
      final response = await _supabaseClient.from('cards').insert({
        'owner_id': ownerId,
        'title': title,
        'description': description,
        //'image_url': imageUrl,
        //'tags': tags,
        'created_at': DateTime.now().toIso8601String(),
      })/*.execute()*/;
    } catch (e) {
      rethrow;
    }
  }

  // /// Получение карточек пользователей с взаимным лайком
  // Future<List<CardModelWithUser>> fetchMutualCards(String currentUserId) async {
  //   try {
  //     // 1. Получаем все chat_rooms, где текущий пользователь участвует
  //     final chatRoomsResponse = await _supabaseClient
  //         .from('chat_rooms')
  //         .select()
  //         .or('user1_id.eq.$currentUserId,user2_id.eq.$currentUserId')
  //         .execute();
  //
  //     final chatRooms = chatRoomsResponse.data as List<dynamic>;
  //     if (chatRooms.isEmpty) return [];
  //
  //     // 2. Извлекаем ID других пользователей
  //     final otherUserIds = chatRooms.map((room) {
  //       final roomMap = room as Map<String, dynamic>;
  //       return roomMap['user1_id'] == currentUserId
  //           ? roomMap['user2_id'] as String
  //           : roomMap['user1_id'] as String;
  //     }).toSet().toList(); // Используем Set для уникальности
  //
  //     if (otherUserIds.isEmpty) return [];
  //
  //     // 3. Получаем карточки этих пользователей вместе с информацией о пользователе
  //     final cardsResponse = await _supabaseClient
  //         .from('cards')
  //         .select('*, owner:profiles(name, avatar_url)')
  //         .in_('owner_id', otherUserIds)
  //         .order('created_at', ascending: false)
  //         .execute();
  //
  //
  //     final cardsData = cardsResponse.data as List<dynamic>;
  //     return cardsData.map((json) => CardModelWithUser.fromJson(json)).toList();
  //   } catch (e) {
  //     // Обработка ошибок
  //     rethrow;
  //   }
  // }

  Future<void> likeCard(String userId, String cardId) async {
    try {
      final response = await _supabaseClient.from('likes').insert({
        'user_id': userId,
        'card_id': cardId,
        'created_at': DateTime.now().toIso8601String(),
      })/*.execute()*/;

    } catch (e) {
      rethrow;
    }
  }

  // Получаем все лайки для карточки
  // Future<List<UserModel>> getUsersWhoLikedCard(String cardId) async {
  //   try {
  //     final response = await _supabaseClient
  //         .from('likes')
  //         .select('user_id')
  //         .eq('card_id', cardId)
  //         .execute();
  //
  //     final data = response.data as List<dynamic>;
  //     final userIds = data.map((item) => item['user_id'] as String).toList();
  //
  //     // Получаем информацию о пользователях, которые поставили лайк
  //     final usersResponse = await _supabaseClient
  //         .from('profiles')
  //         .select()
  //         .in_('id', userIds)
  //         .execute();
  //     final usersData = usersResponse.data as List<dynamic>;
  //     return usersData.map((json) => UserModel.fromJson(json)).toList();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  Future<List<UserModel>> getUsersWhoLikedCard(String cardId) async {
    try {
      final response = await _supabaseClient
          .from('likes')
          .select('user_id')
          .eq('card_id', cardId)
          /*.execute()*/;



      final data = response/*.data*/ as List<dynamic>;
      final userIds = data.map((item) => item['user_id'] as String).toList();

      final usersResponse = await _supabaseClient
          .from('profiles')
          .select()
          .inFilter('id', userIds)
          /*.execute()*/;
      // final usersResponse = await _supabaseClient
      //     .from('cards')
      //     .select()
      //     .in_('owner_id', userIds)
      //     .execute();



      final usersData = usersResponse/*.data*/ as List<dynamic>;
      return usersData.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  ///Получаем Айди карточек, лайкнувших пользователей
  // Future<List<UserModel>> getUsersWhoLikedCard(String cardId) async {
  //   try {
  //     final response = await _supabaseClient
  //         .from('likes')
  //         .select('user_id')
  //         .eq('card_id', cardId)
  //         .execute();
  //
  //     final data = response.data as List<dynamic>;
  //     final userIds = data.map((item) => item['user_id'] as String).toList();
  //
  //
  //     // Получаем информацию о пользователях, которые поставили лайк
  //     // final userRespCards  = await _supabaseClient.from("cards").select("id").eq("owner_id",userIds).execute();
  //     // final userCards=userRespCards.data as List<dynamic>;
  //     // return userCards.map((json) => UserModel.fromJson(json)).toList();
  //
  //     final usersResponse = await _supabaseClient
  //         .from('profiles')
  //         .select()
  //         .in_('id', userIds)
  //         .execute();
  //     final usersData = usersResponse.data as List<dynamic>;
  //     return usersData.map((json) => UserModel.fromJson(json)).toList();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

}
// lib/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}
// lib/models/card_model_with_user.dart


class CardModelWithUser extends CardModel {
  final UserModel owner;

  CardModelWithUser({
    required String id,
    required String owner_id,
    required String title,
    required String description,
    //String? imageUrl,
    required DateTime createdAt,
    required this.owner,
  }) : super(
    id: id,
    owner_id: owner_id,
    title: title,
    description: description,
    //imageUrl: imageUrl,
    createdAt: createdAt,
  );

  factory CardModelWithUser.fromJson(Map<String, dynamic> json) {
    return CardModelWithUser(
      id: json['id'] as String,
      owner_id: json['owner_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      //imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      owner: UserModel.fromJson(json['owner_id'] as Map<String, dynamic>),
    );
  }
}

