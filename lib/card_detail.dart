// // lib/pages/card_detail_page.dart
//
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import 'User_card_page.dart';
// import 'constants.dart';
//
//
// class CardDetailPage extends StatefulWidget {
//   final CardModel card;
//
//   const CardDetailPage({super.key, required this.card});
//
//   @override
//   State<CardDetailPage> createState() => _CardDetailPageState();
// }
//
// class _CardDetailPageState extends State<CardDetailPage> {
//   late final CardService _cardService;
//   late List<UserModel> _usersWhoLikedCard;
//
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _cardService = CardService(Supabase.instance.client);
//     _loadUsersWhoLikedCard();
//   }
//
//   Future<void> _loadUsersWhoLikedCard() async {
//     final users = await _cardService.getUsersWhoLikedCard(widget.card.id);
//     setState(() {
//       _usersWhoLikedCard = users;
//       _isLoading = false;
//     });
//   }
//
//   Future<void> _likeCard() async {
//     final userId = Supabase.instance.client.auth.currentUser?.id;
//     if (userId == null) return;
//
//     await _cardService.likeCard(userId, widget.card.id);
//     await _loadUsersWhoLikedCard();
//   }
//
//   Future<void> _viewUserCards(String userId) async {
//     final userCards = await _cardService.fetchOtherUsersCards(userId);
//
//     // Переход на экран с карточками пользователя, который поставил лайк
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => UserCardsPage(userId: userId, cards: userCards),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.card.title),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//         children: [
//           Card(
//             margin: const EdgeInsets.all(16),
//             child: ListTile(
//               title: Text(widget.card.title),
//               subtitle: Text(widget.card.description),
//               trailing: IconButton(
//                 icon: const Icon(Icons.favorite_border),
//                 onPressed: _likeCard,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text('Пользователи, поставившие лайк:'),
//           const SizedBox(height: 8),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _usersWhoLikedCard.length,
//               itemBuilder: (context, index) {
//                 final user = _usersWhoLikedCard[index];
//                 return ListTile(
//                   title: Text(user.name),
//                   leading: CircleAvatar(
//                     backgroundImage: user.avatarUrl != null
//                         ? NetworkImage(user.avatarUrl!)
//                         : null,
//                     child: user.avatarUrl == null
//                         ? const Icon(Icons.person)
//                         : null,
//                   ),
//                   onTap: () => _viewUserCards(user.id),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// lib/pages/card_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Likes.dart';
import 'MySkills.dart';
import 'User_card_page.dart';
import 'cards.dart';
import 'constants.dart';
import 'main.dart';

class CardDetailPage extends StatefulWidget {
  final CardModel card;
  final List<String> tags;
  final String image_url;
///Прежний конструктор
  //const CardDetailPage({super.key, required this.card});
  const CardDetailPage({Key? key, required this.card, required this.tags, required this.image_url}) : super(key: key);
  @override
  State<CardDetailPage> createState() => _CardDetailPageState();
}
class MiddleSkillCardImageDelete extends StatelessWidget {
  final String id;
  final String id2;
  final String owner_id;
  final String owner_id2;
  final String title;
  final String description;
  final List<String> tags;
  final double widthScale;
  final double heightScale;
  final bool? isLiked;
  final String image_url;

  // MiddleSkillCardImage({
  //   required this.id,
  //   required this.owner_id,
  //   required this.title,
  //   required this.description,
  //   required this.tags,
  //   required this.image_url,
  //   required this.widthScale,
  //   required this.heightScale,
  //   this.isLiked
  // });
  const MiddleSkillCardImageDelete({Key? key,
    required this.id,
    required this.id2,
    required this.owner_id,
    required this.owner_id2,
    required this.title,
    required this.description,
    required this.tags,
    required this.image_url,
    required this.widthScale,
    required this.heightScale,
    this.isLiked
  }) : super(key: key);
  // const AndroidDevelopmentCard({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: EdgeInsets.only(/*top:60,*/ bottom: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, //New
                  blurRadius: 3,
                  //blurRadius: 7.0,
                  offset: Offset(0, 2)
              )
            ],
          ),

          clipBehavior: Clip.antiAlias, // Чтобы скругление применялось к вложенным виджетам
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              // Секция с изображением и наложенными элементами
              Padding(padding: EdgeInsets.only(left: 13, right: 13,/* top:10*/),
                child:  Stack(
                  children: [
                    // Изображение с пониженной экспозицией
                    ColorFiltered(
                        colorFilter: ColorFilter.matrix(
                          <double>[
                            // Уменьшаем яркость (экспозицию), здесь коэффициент 0.7
                            /*0.7*/0.75, 0.0, 0.0, 0.0, 0.0,
                            0.0, /*0.7*/0.75, 0.0, 0.0, 0.0,
                            0.0, 0.0, /*0.7*/0.75, 0.0, 0.0,
                            0.0, 0.0, 0.0, 1.0, 0.0,
                          ],
                        ),
                        child:
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            //'https://inusbwyedxylsbcxolat.supabase.co/storage/v1/object/public/images/images/1000005544.jpg',
                            image_url,
                            fit: BoxFit.cover,
                            height: 110,
                            width: 380/*315double.infinity*/,
                            //width: 330/*315double.infinity*/,

                          ),
                        )
                    ),
                    // Теги (Кодинг, Kotlin, Android) в верхней левой части
                    // Заголовок по центру изображения
                    Padding(
                      padding: EdgeInsets.only(left: 282, top:15),
                      child:     Heartwidget(owner_id: owner_id,id: id,owner_id2: owner_id2,id2: id2,isLiked: false,),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top:17, left: 14),
                      child:  SkillTirle(label:title),),
                    // Positioned.fill(
                    //   top: 10,
                    //   left: 8,
                    //   right:77,
                    //   bottom:60,
                    //
                    //   child:
                    //    //   Padding(padding: EdgeInsets.only(bo),),
                    //    //  SkillChip2(label:'Разработка для Android'),
                    //   // Text(
                    //   //   'Разработка для Android',
                    //   //   style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    //   //     color: Colors.white,
                    //   //     fontWeight: FontWeight.bold,
                    //   //
                    //   //   ),
                    //   // ),
                    // ),
                    // Positioned(
                    //   top: 60,
                    //   left: 8,
                    //   child:
                    Padding(
                      padding: EdgeInsets.only(top:71, left:14),
                      child:    Wrap(
                        spacing: 8.0 * widthScale,
                        children: tags
                            .map((tag) => SkillChip2(label: tag))
                            .toList(),
                      ),

                    )

                    //  ),
                  ],
                ),),
              // Секция с описанием и рейтингом
              Padding(
                padding: const EdgeInsets.only(top:12, left: 20,right: 15, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only( left: 17,),child: Text(
                            'О скилле',
                            style: TextStyle(fontSize: 17, color: CustomTheme.lightTheme.primaryColor,fontWeight: FontWeight.w700)/*Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,*/
                          // ),
                        ),),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only( right: 35,),child:
                        Row(
                          children: [

                            Text(
                                '4.5',
                                style: TextStyle(fontSize: 17, color: CustomTheme.lightTheme.primaryColor,fontWeight: FontWeight.w700)
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.star, color: Colors.amber, size: 20),

                          ],
                        ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 2,
                      style: TextStyle(fontSize: 14, color: CustomTheme.lightTheme.primaryColor,fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 20),

                  ],
                ),
              ),

              // SizedBox(height: 4),
            ],
          ),

        ),
      );
  }
}
class MiddleSkillCardDelete extends StatelessWidget {
  final String id;
  final String id2;
  final String owner_id;
  final String owner_id2;
  final String title;
  final String description;
  final List<String> tags;
  final double widthScale;
  final double heightScale;


  // Правильный конструктор без @override и типа возвращаемого значения
  MiddleSkillCardDelete({
    required this.id,
    required this.id2,
    required this.owner_id,
    required this.owner_id2,
    required this.title,
    required this.description,
    required this.tags,
    required this.widthScale,
    required this.heightScale,

  });

  Future<void> deleteLike(String user1Id, String card1Id) async {
    try {
      final response = await supabase
          .from('likes')
          .delete()
          .eq('user_id', user1Id)
          .eq('card_id', card1Id)
          .execute();
    } catch (e) {
      rethrow;
    }

  }
  Future<void> CreateRoom(String user1Id, String card1Id,String user2Id, String card2Id) async {
    try {
      final response = await supabase.from('chat_rooms').insert({
        'user1_id': user1Id,
        'card1_id':card1Id,
        'user2_id': user2Id,
        'card2_id': card2Id,
        'created_at': DateTime.now().toIso8601String(),
      }).execute();

    } catch (e) {
      rethrow;
    }

  }
  bool _isLiked = false;
  void likedesign(){
    if(_isLiked==false){

      _isLiked=true;
    }else{_isLiked=true;}
  }

  @override
  Widget build(BuildContext context) {
    // Код метода build

    return  Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, //New
                  blurRadius: 7.0,
                  offset: Offset(0, 5))
            ],
          ),

          //elevation: 4.0 * heightScale,

          child: Padding(
            padding: EdgeInsets.all(16.0 * widthScale),
            child: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 24.0 * widthScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Heartwidget(owner_id: owner_id,id: id,owner_id2: owner_id2,id2: id2,)
                      // ClipOval(
                      //   child: Container(
                      //       color: CustomTheme.lightTheme.secondaryHeaderColor,
                      //       width: 35,
                      //       height: 35,
                      //       child:
                      //       IconButton(onPressed: () async {
                      //         likedesign();
                      //         //await likeCard(Supabase.instance.client.auth.currentUser!.id,id);
                      //           await CreateRoom(owner_id, id, owner_id2, id2);
                      //           await deleteLike(owner_id, id);
                      //       }, icon: _isLiked?  SvgPicture.asset('assets/icons/heartClicked.svg'): SvgPicture.asset('assets/icons/heart.svg') ,)
                      //   ),
                      // ),
                    ],
                  ),

                  SizedBox(height: 8.0 * heightScale),
                  Padding(
                    padding: EdgeInsets.only(left:10),
                    child: Text(
                      'О скиле',
                      style: TextStyle(
                        fontSize: 18.0 * widthScale,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  SizedBox(height: 8.0 * heightScale),
                  Text(

                    description,
                    style: TextStyle(fontSize: 16.0 * widthScale),
                  ),
                  SizedBox(height: 16.0 * heightScale),

                  Wrap(
                    spacing: 8.0 * widthScale,
                    children: tags
                        .map((tag) => SkillChip(label: tag))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 26.0 * heightScale),
      ],
    );
  }
}

class _CardDetailPageState extends State<CardDetailPage> {
  // late final CardService _cardService;
   late List<UserModel> _usersWhoLikedCard;

   bool _isLoading = true;
  // bool _isCardLoading =true;
  List<Map<String, dynamic>> skills = [];
  List<Map<String, dynamic>> Allskills = [];

   Future<List<CardModel>>? _futureData;

  late final CardService _cardService;
  // Список пользователей, поставивших лайк (в примере далее используется первый из списка)
  List<UserModel> _likers = [];
  String statee ="";
  // Все карточки пользователя B (лайкнувшего)
  List<CardModel> _userBCards = [];
  bool _isLoadingLikers = true;
  bool _isLoadingUserCards = true;
   List<List<String>> alltags = [
     ['Кодинг', 'Kotlin', 'Android'],
     ['Музыка', /*'Kotlin',*/ 'Гитара'],
     ['Музыка', /*'Kotlin',*/ 'Гитара'],
     ['Музыка', /*'Kotlin',*/ 'Гитара'],
     ['Музыка', /*'Kotlin',*/ 'Гитара'],
     ['Музыка', /*'Kotlin',*/ 'Гитара'],
     ['Музыка', /*'Kotlin',*/ 'Гитара'],
     ['Музыка', /*'Kotlin',*/ 'Гитара'],
     ['Музыка', /*'Kotlin',*/ 'Гитара'],
     ['Музыка', /*'Kotlin',*/ 'Гитара'],
     ['Музыка', /*'Kotlin',*/ 'Гитара'],
     ['Музыка', /*'Kotlin',*/ 'Гитара'],
     ['Музыка', /*'Kotlin',*/ 'Гитара'],
     ['Музыка', /*'Kotlin',*/ 'Гитара'],
     ['Музыка', /*'Kotlin',*/ 'Гитара'],
     ['Музыка', /*'Kotlin',*/ 'Гитара'],
     ['Музыка', /*'Kotlin',*/ 'Гитара'],
     ['Музыка', /*'Kotlin',*/ 'Гитара'],
   ];
///Старый initstate
  // @override
  // void initState() {
  //   super.initState();
  //   _cardService = CardService(Supabase.instance.client);
  //   _loadUsersWhoLikedCard();
  //  // _loadAllCards();
  // }
   @override
   void initState() {
     super.initState();
     _cardService = CardService(Supabase.instance.client);
     _loadLikers();
     /*_futureData=*/getUsersCardsWhoLiked(widget.card.id);

   }

  // Future<void> _loadAllCards() async {
  //   try {
  //     final response = await supabase.from('cards').select()/*.neq("owner_id", Supabase.instance.client.auth.currentUser?.id)*/;
  //     if (response.isNotEmpty) {
  //       setState(() {
  //         skills = List<Map<String, dynamic>>.from(response);
  //         _isCardLoading=false;
  //       });
  //     }
  //   } catch (e) {
  //     print('Ошибка загрузки задач: $e');
  //   }
  // }
///Прежняя загрузка карточек
//   Future<void> _loadUsersWhoLikedCard() async {
//     ///Получение лайков c карточек
//     final cards = await _cardService.getUsersWhoLikedCard(widget.card.id);
//     //final users = await _cardService.getUsersWhoLikedCard(widget.card.id);
//    // _loadAllCards();
//     setState(() {
//       _usersWhoLikedCard = users;
//             _isLoading = false;
//     });
//    //  try {
//    //    final response = await supabase.from('cards').select()/*.neq("owner_id", Supabase.instance.client.auth.currentUser?.id)*/;
//    //    if (response.isNotEmpty) {
//    //      Allskills = List<Map<String, dynamic>>.from(response);
//    //      for(int i=0;i<cards.length;i++) {
//    //        for (int j = 0; j < Allskills.length; j++) {
//    //          if (cards[i] == Allskills[j]) {
//    //            skills.add(Allskills[j]);
//    //          }
//    //        }
//    //      }
//    //      _isCardLoading=false;
//    //      _usersWhoLikedCard = cards;
//    //      //_usersWhoLikedCard = users;
//    //      _isLoading = false;
//    //      setState(() {
//    //
//    //      });
//    //        //skills = List<Map<String, dynamic>>.from(response);
//    //
//    //
//    //    }
//    //  } catch (e) {
//    //    print('Ошибка загрузки задач: $e');
//    //  }
//     // setState(() {
//     //   _usersWhoLikedCard = cards;
//     //   //_usersWhoLikedCard = users;
//     //   _isLoading = false;
//     // });
//   }
///Прежний лайк
//   Future<void> _loadUsersWhoLikedCard(/*String cardId*/) async {
//     final users = await _cardService.getUsersWhoLikedCard(/*widget.card.id*/cardId);
//     setState(() {
//       _usersWhoLikedCard = users;
//       _isLoading = false;
//     });
//   }
  // Future<void> _loadUsersWhoLikedCard() async {
  //   final users = await _cardService.getUsersWhoLikedCard(widget.card.id);
  //   setState(() {
  //     _usersWhoLikedCard = users;
  //     _isLoading = false;
  //   });
  // }
  // Future<void> _likeCard() async {
  //   final userId = Supabase.instance.client.auth.currentUser?.id;
  //   if (userId == null) return;
  //
  //   await _cardService.likeCard(userId, widget.card.id);
  //   await _loadUsersWhoLikedCard();
  // }

  // Future<void> _likeCard() async {
  //   final userId = Supabase.instance.client.auth.currentUser?.id;
  //   if (userId == null) return;
  //
  //   await _cardService.likeCard(userId, widget.card.id);
  //   await _loadUsersWhoLikedCard();
  // }
  ///Получение карточек пользователей, поставивших лацк
  // Future<List<CardModel>> getUsersCardsWhoLiked(String cardId) async {
  //   try {
  //     final response = await supabase
  //         .from('likes')
  //         .select('user_id')
  //         .eq('card_id', cardId)
  //         .execute();
  //     final data = response.data as List<dynamic>;
  //     final userIds = data.map((item) => item['user_id'] as String).toList();
  //     // final usersResponse = await _supabaseClient
  //     //     .from('profiles')
  //     //     .select()
  //     //     .in_('id', userIds)
  //     //     .execute();
  //     final usersResponse = await supabase
  //         .from('cards')
  //         .select()
  //         .in_('owner_id', userIds)
  //         .execute();
  //
  //
  //     // final dat = usersResponse.data as List<dynamic>;
  //     // return dat.map((json) => CardModel.fromJson(json)).toList();
  //     // final usersData = usersResponse.data as List<dynamic>;
  //     // return usersData.map((json) => UserModel.fromJson(json)).toList();
  //   } catch (e) {
  //     rethrow;
  //   }
  //   try {
  //     final response = await supabase.from('cards').select()/*.neq("owner_id", Supabase.instance.client.auth.currentUser?.id)*/;
  //     if (response.isNotEmpty) {
  //       setState(() {
  //         skills = List<Map<String, dynamic>>.from(response);
  //         _isCardLoading=false;
  //       });
  //     }
  //   } catch (e) {
  //     print('Ошибка загрузки задач: $e');
  //   }
  // }


  Future<void> getUsersCardsWhoLiked(String cardId) async {
    try {
      final response = await supabase
          .from('likes')
          .select('user_id')
          .eq('card_id', cardId)
          .execute();
      final data = response.data as List<dynamic>;
      final userIds = data.map((item) => item['user_id'] as String).toList();
      // final usersResponse = await _supabaseClient
      //     .from('profiles')
      //     .select()
      //     .in_('id', userIds)
      //     .execute();
      final usersResponse = await supabase
          .from('cards')
          .select()
          .in_('owner_id', userIds)
          .execute();

      setState(() {
        skills= List<Map<String, dynamic>>.from(usersResponse.data);
        _isLoading=false;
      });

      // final dat = usersResponse.data as List<dynamic>;
      // return dat.map((json) => CardModel.fromJson(json)).toList();
      // final usersData = usersResponse.data as List<dynamic>;
      // return usersData.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      print('Ошибка загрузки задач: $e');
      rethrow;
    }
  }

  Future<void> _viewUserCards(String userId) async {
    final userCards = await _cardService.fetchOtherUsersCards(userId);

    // Переход на экран с карточками пользователя, который поставил лайк
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserCardsPage(userId: userId, cards: userCards),
      ),
    );
  }

  // Метод для загрузки пользователей, поставивших лайк на карточку A
  Future<void> _loadLikers() async {
     try {
      final likers = await _cardService.getUsersWhoLikedCard(widget.card.id);
      setState(() {
        _likers = likers;
        _isLoadingLikers = false;
      });
      // Если есть хотя бы один лайк, берем первого пользователя (User B)
      if (likers.isNotEmpty) {
        _loadUserBCards(likers.first.id);
      } else {
        setState(() {
          _isLoadingUserCards = false;
        });
      }
    } catch (e) {
      print("Ошибка при загрузке лайкнувших: $e");
      setState(() {
        _isLoadingLikers = false;
        _isLoadingUserCards = false;
      });
    }
  }

  // Метод для загрузки всех карточек пользователя B
  Future<void> _loadUserBCards(String userBId) async {
    try {
      final cards = await _cardService.getUserCards(userBId);
      setState(() {
        _userBCards = cards;
        _isLoadingUserCards = false;
      });
    } catch (e) {
      print("Ошибка при загрузке карточек пользователя B: $e");
      setState(() {
        _isLoadingUserCards = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenSize = MediaQuery.of(context).size;
    // final currentSkill = skillData[_selectedIndex];
    // Коэффициенты масштабирования для адаптивного дизайна
    final widthScale = screenWidth / 390;
    final heightScale = screenHeight / 844;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card.title),
      ),
      body:
          // SingleChildScrollView(/*
          //   child:*/
         Column(
              children: [
                Padding(padding: EdgeInsets.all(16),child: MiddleSkillCardImagePen(id: widget.card.id, owner_id: widget.card.owner_id, title: widget.card.title, description: widget.card.description, tags: widget.tags, widthScale: 1, heightScale: 1, image_url: widget.image_url,),),
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.cyan))
                      : Column(
                    children: [
                      const Text('Пользователи, поставившие лайк:'),
                      const SizedBox(height: 20),

                      Container(
                        height: 370,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: skills.length,
                          itemBuilder: (context, index) {
                            final current=skills[index];
                            return Padding(
                              padding: EdgeInsets.all(4),
                              child:
                              MiddleSkillCardImageDelete(id:current["id"].toString(),owner_id:current["owner_id"],id2:widget.card.id,owner_id2: widget.card.owner_id,title: current["title"],
                                description: current["description"],image_url: current["image_url"],
                                tags: current['tags'].split(/*delimiterPattern*/'#'), widthScale: widthScale, heightScale: heightScale,isLiked: false, /*createdAt: task["created_at"],*/)

                              // MiddleSkillCardDelete(id:current["id"].toString(),owner_id:current["owner_id"],id2:widget.card.id,owner_id2: widget.card.owner_id, title:current["title"],
                              //   description: current["description"],
                              //   tags: current['tags'].split(/*delimiterPattern*/'#')/*alltags[index]*/, widthScale: 1, heightScale: 1,),

                            );  },
                        ),
                      ),


                      // Expanded(
                      //   child: ListView.builder(
                      //     itemCount: _usersWhoLikedCard.length,
                      //     itemBuilder: (context, index) {
                      //       final user = _usersWhoLikedCard[index];
                      //       return ListTile(
                      //         title: Text(user.name),
                      //         leading: CircleAvatar(
                      //           backgroundImage: user.avatarUrl != null
                      //               ? NetworkImage(user.avatarUrl!)
                      //               : null,
                      //           child: user.avatarUrl == null
                      //               ? const Icon(Icons.person)
                      //               : null,
                      //         ),
                      //         onTap: () => _viewUserCards(user.id),
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),



      bottomNavigationBar: BottomAppBar(
        height: screenHeight*0.0829383886255924,
        //  height: screenHeight*0.1018957345971564,
        color: const Color(0xffffffff),
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight:Radius.circular(15) )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: (){
                //  _signOut();
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => AccountPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
                iconSize: 40,
                //iconSize: 30,
                icon:SvgPicture.asset('assets/icons/book.svg'),
                // color: const Color(0xff1E3045)
              ),
              IconButton(onPressed: (){
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => MySkillsScreen(),
                    //  pageBuilder: (context, animation1, animation2) => MyCardsPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
                  iconSize: 25,
                  //iconSize: 30,
                  // icon:  SvgPicture.asset('assets/icons/cap.svg')
                  icon:  SvgPicture.asset('assets/icons/capblue.svg')
                  , color: const Color(0xff1E3045)),
              IconButton(onPressed: (){
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    //  pageBuilder: (context, animation1, animation2) => Likes(),
                    pageBuilder: (context, animation1, animation2) => Likes(),
                    // pageBuilder: (context, animation1, animation2) => ChatPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
                  iconSize: 10,
                  //iconSize: 30,
                  icon: SvgPicture.asset('assets/icons/profile.svg')
                  // icon: SvgPicture.asset('assets/icons/profileblue.svg')
                  , color: const Color(0xff1E3045))
            ],
          ),
        ),
      ),);
   }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //       title: Text(widget.card.title),
  //   ),
  //   body: SingleChildScrollView(
  //   child: Column(
  //   crossAxisAlignment: CrossAxisAlignment.stretch,
  //   children: [
  //   // Блок с деталями карточки A
  //   Card(
  //   margin: const EdgeInsets.all(16),
  //   child: ListTile(
  //   title: Text(widget.card.title),
  //   subtitle: Text(widget.card.description),
  //   ),
  //   ),
  //   const Divider(),
  //   Padding(
  //   padding: const EdgeInsets.all(16.0),
  //   child: Text(
  //   "Карточки пользователя B (лайкнувшего карточку):",
  //   style: Theme.of(context).textTheme.subtitle1,
  //   ),
  //   ),
  //   // Если идет загрузка карточек пользователя B, показываем индикатор
  //   _isLoadingUserCards
  //   ? const Center(child: CircularProgressIndicator())
  //       : _userBCards.isEmpty
  //   ?  const Center(
  //   child: Padding(
  //   padding: EdgeInsets.symmetric(horizontal: 16),
  //   child: Text("Нет карточек у пользователя B."/*statee*/),
  //   ),
  //   )
  //       : ListView.builder(
  //   shrinkWrap: true,
  //   physics: const NeverScrollableScrollPhysics(),
  //   itemCount: _userBCards.length,
  //   itemBuilder: (context, index) {
  //   final card = _userBCards[index];
  //   return Card(
  //     margin: const EdgeInsets.symmetric(
  //         horizontal: 16, vertical: 8),
  //     child: ListTile(
  //       title: Text(card.title),
  //       subtitle: Text(card.description),
  //     ),
  //   );
  //   },
  //   ),
  //   ],
  //   ),
  //   ),
  //   );
  // }
 }