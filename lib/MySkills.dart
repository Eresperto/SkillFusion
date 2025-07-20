import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Likes.dart';
import 'NewSkill.dart';
import 'cards.dart';
import 'constants.dart';
import 'main.dart';


class MySkillsScreen extends StatefulWidget {
  @override
  _MySkillsScreenState createState() => _MySkillsScreenState();
}
class _MySkillsScreenState extends State<MySkillsScreen> {
  List<Map<String, dynamic>> _tasks = [];
  late Future<List<Map<String, dynamic>>> _futureCards;
  bool _isCardLoading =true;
  bool cardExists = true;
  // Future<List<Map<String, dynamic>>> fetchMyCards() async {
  //   final response = await supabase
  //       .from('cards')
  //       .select()
  //       .eq('owner_id', supabase.auth.currentUser!.id);
  //   return response;
  // }

  @override
  void initState() {
    super.initState();
    _loadTasks();
   // _futureCards = _fetchMyCards();
  }

  Future<void> _loadTasks() async {
    try {
      final response = await supabase.from('cards').select().eq('owner_id', Supabase.instance.client.auth.currentUser!.id);
      if (response.isNotEmpty) {
        setState(() {
          _tasks = List<Map<String, dynamic>>.from(response);
          _isCardLoading=false;
        });
      }else {setState(() {
        _isCardLoading=false;
        cardExists = false;
      });
      }
    } catch (e) {
      print('Ошибка загрузки задач: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    // Получаем размеры экрана
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    // List<String> titles = [
    //   'Разработка для Android','Игра на гитаре'
    // ];
    // List<String> descriptions = [
    // 'Прежде всего, внедрение современных методик по разработке приложений',
    // 'Прежде всего, внедрение современных методик по разработке приложений'
    // ];
    // List<String> mytexts = [
    //   "Область скила","О вашем скиле","Что хотите вы?"
    // ];
    // int row = 3;
    // int col = 2;
    // var twoDList = List<List>.generate(row, (i) => List<dynamic>.generate(col, (index) => null, growable: false), growable: false);


    // Коэффициенты масштабирования для сохранения пропорций
    final double heightScale = screenHeight / 844;
    final double widthScale = screenWidth / 390;


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        body: SingleChildScrollView(
          child:  _isCardLoading
              ? const Padding(padding: EdgeInsets.only(top:300),
            child:  Center(child: CircularProgressIndicator(color: Colors.cyan)),)
        : Padding(
            padding: EdgeInsets.all(16.0 * widthScale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: EdgeInsets.only(top:60*heightScale)),
                Center(child:Text('Мои скилы',
                  style: TextStyle(fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: CustomTheme.lightTheme.primaryColor),
                ) ,
                ),
                Padding(padding: EdgeInsets.only(top: 6*heightScale)),
                // MiddleSkillCard(
                //   title: 'Разработка для Android',
                //   description:
                //   'Прежде всего, внедрение современных методик по разработке приложений',
                //   tags: ['Кодинг', 'Kotlin', 'Android'],
                //   widthScale: widthScale,
                //   heightScale: heightScale,
                // ),
                // SizedBox(height: 26.0 * heightScale),
                // MiddleSkillCard(
                //   title: 'Игра на гитаре',
                //   description:
                //   'Прежде всего, внедрение современных методик по разработке приложений',
                //   tags: ['Музыка', 'Kotlin', 'Гитара'],
                //   widthScale: widthScale,
                //   heightScale: heightScale,
                // ),
                cardExists?
                Column(
                  children: [
                    Container(
                      height: 520,
                      width: 520,
                      child:
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount:  _tasks.length,
                        itemBuilder: (context, index) {
                          final task = _tasks[index];
                          //final description = _tasks[index];

                          return Padding(
                            padding: EdgeInsets.only(left: 4,right: 4,top:4, bottom: 26),
                            child:

                            MiddleSkillCardImagePen(id: task["id"].toString(),owner_id:task["owner_id"].toString(),title: task["title"],
                                description: task["description"],image_url: task["image_url"],
                                tags: task['tags'].split(/*delimiterPattern*/'#'), widthScale: widthScale, heightScale: heightScale,isLiked: true, /*createdAt: task["created_at"],*/),
                          );

                        },
                      ),
                    )

                  ],
                )
                    :

                    Container(
                      height: 520,
                      width: 520,
                      child:
                      Center(child: Padding(padding: EdgeInsets.only(top:10),child: Text("Расскажите о своих скилах!",
                        style: TextStyle(
                          color: CustomTheme.lightTheme.primaryColor,
                          fontSize: screenSize.width * 0.06,
                          // Пропорциональный размер текста
                          fontWeight: FontWeight.bold,
                        ),),),),
                    ),


                SizedBox(height: 26.0 * heightScale),
                //Add
                Center(
                  child:
                  /*ClipOval(
                    child:*/
                  Container(
                    width: 61,
                    height: 61,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: CustomTheme.lightTheme.highlightColor,

                      ),

                      child:
                      IconButton(onPressed: (){
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) {
                              // Navigate to the SecondScreen
                              return NewSkillApp();
                            },
                            transitionsBuilder:
                                (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                // Apply slide transition
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );},
                          icon: Icon(Icons.add,size: 36.0 * widthScale, color: Colors.white,)) ,
                    ),
                 // ),


                ),
              ],
            ),
          ),
        ),
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
        ),
      ),

    );
  }
}



// lib/pages/my_cards_page.dart


// class MyCardsPage extends StatefulWidget {
//   const MyCardsPage({super.key});
//
//   @override
//   State<MyCardsPage> createState() => _MyCardsPageState();
// }
//
// class _MyCardsPageState extends State<MyCardsPage> {
//   late final CardService _cardService;
//   late Future<List<CardModel>> _futureMyCards;
//
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _imageUrlController = TextEditingController();
//   bool _isCreating = false;
//   String? _errorMsg;
//
//   @override
//   void initState() {
//     super.initState();
//     final supabaseClient = Supabase.instance.client;
//     _cardService = CardService(supabaseClient);
//     final userId = supabaseClient.auth.currentUser?.id;
//     if (userId != null) {
//       _futureMyCards = _cardService.fetchMyCards(userId);
//     } else {
//       // Обработка случая, когда пользователь не авторизован
//       _futureMyCards = Future.value([]);
//     }
//   }
//
//   Future<void> _refreshMyCards() async {
//     final userId = Supabase.instance.client.auth.currentUser?.id;
//     if (userId != null) {
//       setState(() {
//         _futureMyCards = _cardService.fetchMyCards(userId);
//       });
//     }
//   }
//
//   Future<void> _createCard() async {
//     final userId = Supabase.instance.client.auth.currentUser?.id;
//     if (userId == null) return;
//
//     final title = _titleController.text.trim();
//     final description = _descriptionController.text.trim();
//     final imageUrl = _imageUrlController.text.trim();
//
//     if (title.isEmpty || description.isEmpty) {
//       setState(() {
//         _errorMsg = 'Название и описание не могут быть пустыми.';
//       });
//       return;
//     }
//
//     setState(() {
//       _isCreating = true;
//       _errorMsg = null;
//     });
//
//     try {
//       await _cardService.createCard(
//         ownerId: userId,
//         title: title,
//         description: description,
//         imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
//       );
//
//       // Очистка полей ввода
//       _titleController.clear();
//       _descriptionController.clear();
//       _imageUrlController.clear();
//
//       // Обновление списка карточек
//       _refreshMyCards();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Карточка успешно создана!')),
//       );
//     } catch (e) {
//       setState(() {
//         _errorMsg = 'Ошибка при создании карточки: ${e.toString()}';
//       });
//     } finally {
//       setState(() {
//         _isCreating = false;
//       });
//     }
//   }
//
//   // Future<void> _deleteCard(String cardId) async {
//   //   try {
//   //     await _cardService.deleteCard(cardId);
//   //     _refreshMyCards();
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text('Карточка успешно удалена!')),
//   //     );
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Ошибка при удалении карточки: ${e.toString()}')),
//   //     );
//   //   }
//   // }
//
//   Future<void> _showCreateCardDialog() async {
//     showDialog(
//         context: context,
//         builder: (context) {
//       return AlertDialog(
//           title: const Text('Создать новую карточку'),
//           content: SingleChildScrollView(
//             child: Column(
//                 children: [
//                 if (_errorMsg != null) ...[
//             Text(
//             _errorMsg!,
//             style: const TextStyle(color: Colors.red),
//           ),
//           const SizedBox(height: 8),
//           ],
//       TextField(
//       controller: _titleController,
//       decoration: const InputDecoration(labelText: 'Название'),
//       ),
//                   TextField(
//                     controller: _descriptionController,
//                     decoration: const InputDecoration(labelText: 'Описание'),
//                   ),
//                   TextField(
//                     controller: _imageUrlController,
//                     decoration: const InputDecoration(
//                       labelText: 'URL изображения (опционально)',
//                     ),
//                   ),
//                 ],
//             ),
//           ),
//         actions: [
//           TextButton(
//             onPressed: _isCreating
//                 ? null
//                 : () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('Отмена'),
//           ),
//           ElevatedButton(
//             onPressed: _isCreating ? null : () {
//               _createCard().then((_) {
//                 Navigator.of(context).pop();
//               });
//             },
//             child: _isCreating
//                 ? const SizedBox(
//               width: 16,
//               height: 16,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: Colors.white,
//               ),
//             )
//                 : const Text('Создать'),
//           ),
//         ],
//       );
//         },
//     );
//   }
//
//   Future<void> _showDeleteConfirmationDialog(String cardId) async {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Удалить карточку'),
//           content: const Text('Вы уверены, что хотите удалить эту карточку?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Отмена'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // _deleteCard(cardId).then((_) {
//                 //   Navigator.of(context).pop();
//                 // });
//               },
//               child: const Text('Удалить'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Мои Карточки'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             tooltip: 'Создать карточку',
//             onPressed: _showCreateCardDialog,
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refreshMyCards,
//         child: FutureBuilder<List<CardModel>>(
//           future: _futureMyCards,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Ошибка: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('У вас пока нет карточек.'));
//             }
//
//             final myCards = snapshot.data!;
//             return ListView.builder(
//               itemCount: myCards.length,
//               itemBuilder: (context, index) {
//                 final card = myCards[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: ListTile(
//                     title: Text(card.title),
//                     subtitle: Text(card.description),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => _showDeleteConfirmationDialog(card.id),
//                       tooltip: 'Удалить карточку',
//                     ),
//                     onTap: () {
//                       // Опционально: добавить функционал для редактирования карточки
//                     },
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }