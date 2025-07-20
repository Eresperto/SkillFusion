import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'MySkills.dart';
import 'NewSkill.dart';
import 'cards.dart';
import 'constants.dart';
import 'main.dart';


class Likes extends StatefulWidget {
  @override
  _Likes createState() => _Likes();
}







class _Likes extends State<Likes> {
  @override

   bool firstchosen = true;
  late Future<List<Map<String, dynamic>>> _futureCards;
  late final CardService _cardService;
  late Future<List<CardModelWithUser>> _futureMutualCards;
  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _futureCards = _fetchCards();
    final supabaseClient = Supabase.instance.client;
    _cardService = CardService(supabaseClient);
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId != null) {
      //_futureMutualCards = _cardService.fetchMutualCards(userId);
    } else {
      // Обработка случая, когда пользователь не авторизован
      _futureMutualCards = Future.value([]);
    }
   // _loadSkills();
    getUsersCardsWhoLiked();
  }
  Future<void> _refreshMutualCards() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      setState(() {
       // _futureMutualCards = _cardService.fetchMutualCards(userId);
      });
    }
  }


  Future<List<Map<String, dynamic>>> _fetchCards() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    final response = await Supabase.instance.client
        .from('cards')
        .select()
        .neq('owner_id', userId as Object);

    // response возвращает dynamic, приводим к List
    final List<dynamic> data = response;
    return data.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<void> _likeCard(String cardId, String ownerId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    // Записываем лайк
    await Supabase.instance.client.from('likes').insert({
      'liker_id': userId,
      'card_id': cardId,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Проверяем взаимность
    final isMutual = await _checkMutualLike(cardId, ownerId);
    if (isMutual) {
      // Создаём (или получаем) чат
      await _createChatRoom(ownerId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('У вас взаимный лайк! Чат открыт.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Лайк поставлен!')),
      );
    }

    setState(() {
      _futureCards = _fetchCards();
    });
  }
  Future<bool> _checkMutualLike(String cardId, String ownerId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return false;

    // 1) Получаем список карточек текущего пользователя (userId)
    final myCards = await Supabase.instance.client
        .from('cards')
        .select('id')
        .eq('owner_id', userId);

    // Если у пользователя вообще нет карточек, ранний выход
    if (myCards == null || (myCards as List).isEmpty) return false;

    // Преобразуем список в формат ['cardId1','cardId2',...]
    final myCardIds = (myCards as List)
        .map((item) => (item as Map)['id'] as String)
        .toList();

    // 2) Проверяем, лайкнул ли владелец карточки (ownerId) какую-нибудь из myCardIds
    // Для этого используем .filter("card_id", "in", "(...)")
    // Обратите внимание: строковые идентификаторы нужно обернуть в одинарные кавычки
    final cardIdsString = myCardIds.map((id) => "'$id'").join(',');
    final inCondition = '($cardIdsString)';

    final likesResponse = await Supabase.instance.client
        .from('likes')
        .select()
        .filter('card_id', 'in', inCondition)
        .eq('liker_id', ownerId);

    // likesResponse вернёт список записей из таблицы `likes`
    final List<dynamic> likesData = likesResponse;
    // Если не пустой — взаимный лайк есть
    return likesData.isNotEmpty;
  }
  // Future<void> createChatRoom(String userBId) async {
  //   final userAId = supabase.auth.currentUser?.id;
  //   // Проверить, нет ли уже комнаты
  //   final existingRoom = await supabase
  //       .from('chat_rooms')
  //       .select()
  //       .or('and(user1_id.eq.$userAId,user2_id.eq.$userBId),and(user1_id.eq.$userBId,user2_id.eq.$userAId)')
  //       .maybeSingle(); // вернёт null, если записи нет
  //
  //   if (existingRoom == null) {
  //     await supabase.from('chat_rooms').insert({
  //       'user1_id': userAId,
  //       'user2_id': userBId,
  //       'created_at': DateTime.now().toIso8601String(),
  //     });
  //   }
  // }
  Future<void> _createChatRoom(String otherUserId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final existing = await Supabase.instance.client
        .from('chat_rooms')
        .select()
        .or(
        'and(user1_id.eq.$userId,user2_id.eq.$otherUserId),and(user1_id.eq.$otherUserId,user2_id.eq.$userId)')
        .maybeSingle();

    if (existing == null) {
      await Supabase.instance.client.from('chat_rooms').insert({
        'user1_id': userId,
        'user2_id': otherUserId,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }
  Future<void> getUsersCardsWhoLiked(/*String cardId*/) async {
    try {
      final response = await supabase
          .from('likes')
          .select('card_id')
          .eq('user_id', Supabase.instance.client.auth.currentUser!.id)
          /*.execute()*/;
      final data = response/*.data*/ as List<dynamic>;
      final userIds = data.map((item) => item['card_id'].toString()).toList();

      // final usersResponse = await _supabaseClient
      //     .from('profiles')
      //     .select()
      //     .in_('id', userIds)
      //     .execute();
      final usersResponse = await supabase
          .from('cards')
          .select()
          .inFilter('id', userIds)
          /*.execute()*/;

      setState(() {
        _tasks= List<Map<String, dynamic>>.from(usersResponse/*.data*/);
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

  Future<void> _loadSkills() async {
    try {
      final response = await supabase.from('cards').select().neq('owner_id',supabase.auth.currentSession!.user.id);
      if (response.isNotEmpty) {
        setState(() {
          _tasks = List<Map<String, dynamic>>.from(response);
          _isLoading=false;
        });
      }
    } catch (e) {
      print('Ошибка загрузки задач: $e');
    }
  }

  Widget build(BuildContext context) {
    // Получаем размеры экрана
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    // Коэффициенты масштабирования для сохранения пропорций
    final double heightScale = screenHeight / 844;
    final double widthScale = screenWidth / 390;

    List<String> titles = [
      'Разработка для Android','Игра на гитаре'
    ];
    List<String> descriptions = [
      'Прежде всего, внедрение современных методик по разработке приложений',
      'Прежде всего, внедрение современных методик по разработке приложений'
    ];
    List<String> mytexts = [
      "Область скила","О вашем скиле","Что хотите вы?"
    ];
    // int row = 3;
    // int col = 2;
    // var twoDList = List<List>.generate(row, (i) => List<dynamic>.generate(col, (index) => null, growable: false), growable: false);

    List<List<String>> alltags = [
      ['Кодинг', 'Kotlin', 'Android'],
      ['Музыка', /*'Kotlin',*/ 'Гитара'],
    ];

    void onChange(){
      setState(() {
        if(firstchosen==true){
          firstchosen=false;
        }else{firstchosen = true;}
      });
    }

    Widget otherlike(){
      return
         RefreshIndicator(
          onRefresh: _refreshMutualCards,
          child: FutureBuilder<List<CardModelWithUser>>(
            future: _futureMutualCards,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.cyan));
              } else if (snapshot.hasError) {
                return Center(child: Text('Ошибка: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Нет взаимных карточек'));
              }

              final mutualCards = snapshot.data!;
              return ListView.builder(
                itemCount: mutualCards.length,
                itemBuilder: (context, index) {
                  final card = mutualCards[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: card.owner.avatarUrl != null
                          ? CircleAvatar(
                        backgroundImage: NetworkImage(card.owner.avatarUrl!),
                      )
                          : const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(card.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(card.description),
                          // if (card.imageUrl != null) ...[
                          //   const SizedBox(height: 8),
                          //   Image.network(card.imageUrl!),
                          // ],
                        ],
                      ),
                      trailing: Text('От ${card.owner.name}'),
                    ),
                  );
                },
              );
            },
          ),
        );
    }

    Widget yourlike(){

      return SingleChildScrollView(
         child:  _isLoading
              ? const Padding(padding: EdgeInsets.only(top:300),
            child:  Center(child: CircularProgressIndicator(color: Colors.cyan)),)
          :
         _tasks.isNotEmpty?
         Padding(
          padding: EdgeInsets.all(16.0 * widthScale),
          //padding: EdgeInsets.all(16.0 * widthScale),
          child:
          Container(
            height: 607,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                //AndroidDevelopmentCard();
                final current=_tasks[index];
                return MiddleSkillCardImage(id:current["id"].toString(),owner_id:current["owner_id"],title:current["title"],
                  description: current["description"],image_url:current['image_url'],
                  tags: current['tags'].split(/*delimiterPattern*/'#'), widthScale: 1, heightScale: 1,isLiked: true,);
              },
            ),
          ),

              //Add
              // Center(
              //   child:
              //   ClipOval(
              //     child: Container(
              //       color: CustomTheme.lightTheme.primaryColor,
              //       width: 61,
              //       height: 61,
              //       child:
              //       IconButton(onPressed: (){
              //         Navigator.of(context).push(
              //           PageRouteBuilder(
              //             pageBuilder: (context, animation, secondaryAnimation) {
              //               // Navigate to the SecondScreen
              //               return NewSkillApp();
              //             },
              //             transitionsBuilder:
              //                 (context, animation, secondaryAnimation, child) {
              //               const begin = Offset(1.0, 0.0);
              //               const end = Offset.zero;
              //               const curve = Curves.easeInOut;
              //               var tween = Tween(begin: begin, end: end)
              //                   .chain(CurveTween(curve: curve));
              //               var offsetAnimation = animation.drive(tween);
              //
              //               return SlideTransition(
              //                 // Apply slide transition
              //                 position: offsetAnimation,
              //                 child: child,
              //               );
              //             },
              //           ),
              //         );},
              //           icon: Icon(Icons.add,size: 36.0 * widthScale, color: Colors.white,)) ,
              //     ),
              //   ),
              //
              //
              // ),

          ) : Center(child:
         Padding(
             padding: EdgeInsets.only(top:200),
      child:   Text("Вы пока на ставили лайк на карточки!"),),
         ),
        );
    }


    return Scaffold(
        bottomNavigationBar:
        BottomAppBar(
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
                  //icon:SvgPicture.asset('assets/icons/bookblue.svg'),
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
                    icon:  SvgPicture.asset('assets/icons/cap.svg')
                     //icon:  SvgPicture.asset('assets/icons/capblue.svg')
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
                    //icon: SvgPicture.asset('assets/icons/profile.svg')
                     icon: SvgPicture.asset('assets/icons/profileblue.svg')
                    , color: const Color(0xff1E3045))
              ],
            ),
          ),
        ),
      body:
      Column(

        children: [
          Padding(padding: EdgeInsets.only(top:90)),
          Text('Лайки',
            style: TextStyle(fontSize: 30,
                fontWeight: FontWeight.w600,
                color: CustomTheme.lightTheme.primaryColor),
          ) ,
          Padding(padding: EdgeInsets.only(top: 7)),
          // Row(
          //   children: [
          //     Padding(padding: EdgeInsets.only(left: 30)),
          //     TextButton(onPressed: onChange,
          //       child:  Text(
          //         "Ваши",
          //         style: TextStyle(
          //             fontSize: 17,
          //             fontWeight:  firstchosen? FontWeight.w600: FontWeight.w400,
          //             color: firstchosen? CustomTheme.lightTheme.primaryColor: Colors.grey) ,),),
          //
          //     Padding(padding: EdgeInsets.only(left:71 )),
          //     TextButton(onPressed: onChange,
          //       child:  Text(
          //         "Пользовательские",
          //         style: TextStyle(fontSize: 17,
          //             fontWeight: firstchosen? FontWeight.w400 :  FontWeight.w600,
          //             color: firstchosen? Colors.grey: CustomTheme.lightTheme.primaryColor) ,),),
          //   ],
          // ),

        SizedBox(child: /*firstchosen? otherlike():*/yourlike(),height: 600,),


        ],
      ),
    );







        ///Старые лайки

  }
}