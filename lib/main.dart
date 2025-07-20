import 'package:deeplink3/AddPodradchik.dart';
import 'package:deeplink3/Likes.dart';
import 'package:deeplink3/NewRegistr.dart';
import 'package:deeplink3/NewSkill.dart';
import 'package:deeplink3/NewSplash.dart';
import 'package:deeplink3/card_detail.dart';
import 'package:deeplink3/chat_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';


import 'MySkills.dart';
import 'NewLogin.dart';
import 'cards.dart';
import 'chatOpt.dart';
import 'constants.dart';
import 'login.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://inusbwyedxylsbcxolat.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImludXNid3llZHh5bHNiY3hvbGF0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE3NzA3NTMsImV4cCI6MjA0NzM0Njc1M30.9YCVfM4nffV6W4MUbEipxQo7yJwxSym5HzclQVMqMJw',
  );

  runApp(const MyApp());
  //runApp(MaterialApp(home: DataListPage(),) );/
 // runApp(MaterialApp(home: SplashPage(),));
}

//СВЕТЛАЯ ТЕМА
class CustomTheme {
  static ThemeData get lightTheme { //1
    return ThemeData( //2
        primaryColor: const Color(0xff1E3045),
        scaffoldBackgroundColor: Colors.white,
        highlightColor:  Color(0xff2383FF),
        secondaryHeaderColor: const Color(0xffe3f4ff),
        fontFamily: 'Montserrat', //3
        buttonTheme: ButtonThemeData( // 4
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11.0)),
          buttonColor: const Color(0xff1E3045),
        )
    );
  }
}

int showingIndex = 0;

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supabase Flutter',
      theme: ThemeData.light().copyWith(
        primaryColor: Color(0xff1E3045),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor:Color(0xff1E3045),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Color(0xff1E3045),
            backgroundColor:/* Color(0xff1E3045)*/CustomTheme.lightTheme.secondaryHeaderColor,
          ),
        ),
      ),
      home:
      //MySkillsScreen()

      supabase.auth.currentSession == null
          ?
      const LoginPage()
     // const RegisterPage(isRegistering: isRegistering)
            //: const AccountPage(),
           : const Promezutok(),
    );
  }
}



extension ContextExtension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(this).colorScheme.error
            : Theme.of(this).snackBarTheme.backgroundColor,
      ),
    );
  }
}


class AccountPage extends StatefulWidget {
  // const AccountPage({super.key});
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  bool _showSecondDesign = false;
 // final FocusNode _focusNode = FocusNode();
  late final CardService _cardService;
  late Future<List<CardModelWithUser>> _futureMutualCards;
  bool _isCardLoading =true;
  int _selectedIndex = 0;
  final description ="Я обучаю программированию для Android. Научу создавать приложения на Java и Kotlin, работать с Android Studio. У меня 5 лет опыта разработки мобильных приложений. Приходите!";
  final title ="Разработка для андроид";
  final List<List<String>> tags =[["Кодинг","Kotlin","Android"]];

  List<Map<String, dynamic>> _tasks = [];
  final List<Map<String, String>> skillData = [
    {
      'param1': 'Кодинг',
      'param2': 'Kotlin',
      'param3': 'Android',
    },
    {
      'param1': 'Рисование',
      'param2': 'Цифровое искусство',
      'param3': 'Procreate',
    },
    {
      'param1': 'Гитара',
      'param2': 'Акустическая',
      'param3': 'Уроки 1-10',
    },
    // Добавляйте сколько нужно…
  ];





  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();

  List<Map<String, dynamic>> skills = [];
  List<Map<String, dynamic>>  skillsAll = [];
  List<Map<String, dynamic>> ids = [];
  List<Map<String, dynamic>> ids2 = [];
  List<Map<String, dynamic>> ids3 = [];
  List<Map<String, dynamic>> skills2 = [];
  List<Map<String, dynamic>> skills3 = [];
 // List<Map<String, dynamic>> ids3 = [];

  String? _avatarUrl;
  var _loading = true;

  /// Called once a user id is received within `onAuthenticated()`
  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      final userId = supabase.auth.currentSession!.user.id;
      final data =
      await supabase.from('profiles').select().eq('id', userId).single();
      _usernameController.text = (data['username'] ?? '') as String;
      _websiteController.text = (data['website'] ?? '') as String;
      _avatarUrl = (data['avatar_url'] ?? '') as String;
    } on PostgrestException catch (error) {
      if (mounted) /*context.showSnackBar(error.message, isError: true)*/;
    } catch (error) {
      if (mounted) {
       // context.showSnackBar('Unexpected error occurred', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  /// Called when user taps `Update` button
  // Future<void> _updateProfile() async {
  //   setState(() {
  //     _loading = true;
  //   });
  //   final userName = _usernameController.text.trim();
  //   final website = _websiteController.text.trim();
  //   final user = supabase.auth.currentUser;
  //   final updates = {
  //     'id': user!.id,
  //     'username': userName,
  //     'website': website,
  //     'updated_at': DateTime.now().toIso8601String(),
  //   };
  //   try {
  //     await supabase.from('profiles').upsert(updates);
  //     if (mounted) context.showSnackBar('Successfully updated profile!');
  //   } on PostgrestException catch (error) {
  //     if (mounted) context.showSnackBar(error.message, isError: true);
  //   } catch (error) {
  //     if (mounted) {
  //       context.showSnackBar('Unexpected error occurred', isError: true);
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _loading = false;
  //       });
  //     }
  //   }
  // }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      if (mounted) /*context.showSnackBar(error.message, isError: true)*/;
    } catch (error) {
      if (mounted) {
        /*context.showSnackBar('Unexpected error occurred', isError: true)*/;
      }
    } finally {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    }
  }

  late FocusNode _focusNode;
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    final supabaseClient = Supabase.instance.client;
    _cardService = CardService(supabaseClient);
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId != null) {
    //  _futureMutualCards = _cardService.fetchMutualCards(userId);
    } else {
      // Обработка случая, когда пользователь не авторизован
      _futureMutualCards = Future.value([]);
    }
   // _loadTasks();
    fetchMutualCardsMain(supabase.auth.currentUser!.id);
    _getProfile();
    //_focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
     _usernameController.dispose();
     _websiteController.dispose();
    // Удаляем слушатель перед тем, как удалить FocusNode
    //_focusNode.removeListener(_onFocusChange);
    // Очищаем FocusNode при удалении виджета

     _focusNode.dispose();
    super.dispose();
  }
  void _onFocusChange() {
    setState(() {
      _showSecondDesign = _focusNode.hasFocus;
    });
  }

  Future<void> _loadTasks() async {
    try {
      final response = await supabase.from('cards').select()/*.neq("owner_id", Supabase.instance.client.auth.currentUser?.id)*/;
      if (response.isNotEmpty) {
        setState(() {
          skillsAll = List<Map<String, dynamic>>.from(response);
          _isCardLoading=false;
        });
      }
    } catch (e) {
      print('Ошибка загрузки задач: $e');
    }
  }
  List<Map<String, dynamic>> mergeLists(
      List<Map<String, dynamic>> list1, List<Map<String, dynamic>> list2) {
    return [...list1, ...list2]; // Простое объединение списков
  }

  Future<void> fetchMutualCardsMain(String currentUserId) async {
    try {
      // 1. Получаем все chat_rooms, где текущий пользователь участвует
      final chatRoomsResponse = await supabase
          .from('chat_rooms')
          .select('card2_id')
          //.select()
          .eq('user1_id',currentUserId)
          /*.execute()*/;
      final data = chatRoomsResponse/*.data*/ as List<dynamic>;
      final userIds = data.map((item) => item['card2_id'].toString()).toList();

      final chatRoomsResponse2 = await supabase
          .from('chat_rooms')
          .select('card1_id')
          //.select()
          .eq('user2_id',currentUserId)
          /*.execute()*/;
      final data2 = chatRoomsResponse2/*.data*/ as List<dynamic>;
      final userIds2 = data2.map((item) => item['card1_id'].toString()).toList();

      userIds.addAll(userIds2);
      userIds2.addAll(userIds);
      // userIds2;
      // skills2 = List<Map<String, dynamic>>.from(chatRoomsResponse.data);
      // skills3 = List<Map<String, dynamic>>.from(chatRoomsResponse2.data);
      ids=mergeLists(skills3, skills2);
      final usersResponse = await supabase
          .from('cards')
          .select()
          .inFilter('id', userIds)
         // .eq('id',1)
          /*.execute()*/;
///Получение всех карточек для поиска
      final response = await supabase.from('cards').select();

      setState(() {
        skills= List<Map<String, dynamic>>.from(usersResponse/*.data*/);
        skillsAll = List<Map<String, dynamic>>.from(response);
        _isCardLoading=false;
      });

 //      final data =chatRoomsResponse.data as List<dynamic>;
 //      List<String> ids2 = data.map((item) => item['user1_id'] as String).toList();
 // final data2 =chatRoomsResponse2.data as List<dynamic>;
 //      List<String> ids3 = data2.map((item) => item['user2_id'] as String).toList();


    //  final response = await supabase.from('cards').select()/*.eq('id', 2)*/.in_('id', );/*.neq("owner_id", Supabase.instance.client.auth.currentUser?.id)*/;
   //   final response = await supabase.from('cards').select()/*.neq("owner_id", Supabase.instance.client.auth.currentUser?.id)*/;
   //    setState(() {
   //     // skills = List<Map<String, dynamic>>.from(response);
   //     // skills = List<Map<String, dynamic>>.from(response);
   //      skills=mergeLists(skills2, skills3);
   //      //skills = List<Map<String, dynamic>>.from(chatRoomsResponse2.data);
   //      _isCardLoading=false;
   //    });
      // final cardsData = cardsResponse.data as List<dynamic>;
      // return cardsData.map((json) => CardModelWithUser.fromJson(json)).toList();
    } catch (e) {
      // Обработка ошибок
      rethrow;
    }
  }

  final List<String> activeSkills = ['Android', 'Гитара', 'Английский'];


  void _openSearch() {
    // Метод для открытия поискового режима
    setState(() {
      _isSearching = true;
    });
    // Запрашиваем фокус для поля ввода
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _closeSearch() {
    // Метод для закрытия поискового режима
    _focusNode.unfocus();
    setState(() {
      _isSearching = false;
    });
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
    int selectedIndex = 0;
    // Регулярное выражение для разделения по запятым, точкам с запятой, двоеточиям и вертикальным чертам

    return Scaffold(
        body:
        //_showSecondDesign? _secondDesign(): mainDesign(),
        _isSearching? _secondDesign(): mainDesign(),
         //bottom bar
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
                     icon:SvgPicture.asset('assets/icons/bookblue.svg'),
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
                    // icon:  SvgPicture.asset('assets/icons/capblue.svg')
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
      );
  }

  Widget _searchdecor(){
    return  GestureDetector(
      onTap: _openSearch, // Открываем поисковый режим при нажатии на поле
      child: AbsorbPointer(
        // Запрещаем взаимодействие с полем, чтобы все действия обрабатывались через GestureDetector
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Color(0xffe3f4ff),
          ),
          child:/* _showSecondDesign ? _secondDesign():*/
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.menu, color: CustomTheme.lightTheme.primaryColor,)),

              SizedBox(height: 37 ,width: 260,
                  child:
                  // TextField(
                  //
                  //   //controller: _textController,
                  //   focusNode: _focusNode,
                  //   // controller: emailController,
                  //   keyboardType: TextInputType.multiline,
                  //   maxLines: null,
                  //   decoration: InputDecoration(
                  //   //  hintText: mydescriptt[currentIndex],
                  //     contentPadding: EdgeInsets.only(bottom: 17,left: 20),/*.all()*//*symmetric(vertical: *//*17*//*fielsheight, horizontal: 20.0),*/
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  //       borderSide:  BorderSide(color: CustomTheme.lightTheme.primaryColor, width: 1.0),
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(color: CustomTheme.lightTheme.primaryColor, width: 1.0),
                  //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  //     ),
                  //     focusedBorder: const OutlineInputBorder(
                  //       borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  //     ),
                  //   ),
                  // )
                  TextField(
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: '',
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      border: InputBorder.none,
                    ),
                  )
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.search, color: CustomTheme.lightTheme.primaryColor,))
            ],
          )
          ,
        )
      ),
    );
  }
  Widget _secondDesign() {
    RegExp delimiterPattern = RegExp(r'[#]');
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0 ),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(padding: EdgeInsets.only(top:60)),
            //_search(),
            Center(
                child:Column(
                  children: [
                    //_search(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Color(0xffe3f4ff),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(onPressed: (){_closeSearch();}, icon: Icon(Icons.arrow_back, color: CustomTheme.lightTheme.primaryColor,)),
                          SizedBox(height: 47,width: 260,
                              child:
                              TextField(
                                focusNode: _focusNode,
                                decoration: InputDecoration(
                                  hintText: '',
                                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                  border: InputBorder.none,
                                ),
                              )
                          ),
                          IconButton(onPressed: (){}, icon: Icon(Icons.search, color: CustomTheme.lightTheme.primaryColor,))
                        ],
                      ),
                   ),
                  ],
                )
            ),
            //  Padding(padding: EdgeInsets.only(top: 20*heightScale)),
            Container(
              height: 692,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: skillsAll.length,
               // itemCount: skills.length,
                itemBuilder: (context, index) {
                  final current=skillsAll[index];
                  return Padding(
                      padding: EdgeInsets.all(4),
                    child: MiddleSkillCardImage(id:current["id"].toString(),owner_id:current["owner_id"],title:current["title"],
                      description: current["description"],image_url: current["image_url"],
                      tags: current['tags'].split(/*delimiterPattern*/'#'), widthScale: 1, heightScale: 1,isLiked:false),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
  Widget mainDesign(){
    late Map<String, dynamic> currentSkill = skills[_selectedIndex];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenSize = MediaQuery.of(context).size;
    // Коэффициенты масштабирования для адаптивного дизайна
    final widthScale = screenWidth / 390;
    final heightScale = screenHeight / 844;
    RegExp delimiterPattern = RegExp(r'[#]');
  //  final currentSkill = skills[_selectedIndex];
  //  final currentSkilltags =;

    // Разделение строки по указанным разделителям
   // List<String> result = input.split(delimiterPattern);

    // Вывод результата
 //   print(result);
    return   SingleChildScrollView(
      // Позволяет экрану прокручиваться при необходимости
      child:  _isCardLoading
        ? const Padding(padding: EdgeInsets.only(top:300),
        child:
        Center(child: CircularProgressIndicator(color: Colors.cyan)),)
        :
      //skills.isNotEmpty?

      Padding(
        padding: EdgeInsets.all(16)/*only(left: 16, top:16)*/,
        child: Column(
          // Основная колонка элементов
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 65,),
            //Поиск
            _searchdecor(),
            SizedBox(height: 32,),
            Padding(
                padding: EdgeInsets.only(left:16.0),
              child: Text(

                'Активные скилы',
                style: TextStyle(
                  fontSize: screenSize.width * 0.06,
                  // Пропорциональный размер текста
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 25.0),

            Column(
              children: [
                // Горизонтальный ListView
                skills.isNotEmpty?
                SizedBox(
                  height: 126,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: skills.length,
                    itemBuilder: (context, index) {
                      //final item = skillData[index];
                      final item = skills[index];


                      return      GestureDetector(
                        onTap:(){
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) {
                                // Navigate to the SecondScreen
                                return ChatPage();
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
                          );
                        },
                        child:
                        Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  //'https://inusbwyedxylsbcxolat.supabase.co/storage/v1/object/public/images/images/1000005544.jpg',
                                  item['image_url'],
                                  fit: BoxFit.cover,
                                  width: screenSize.width * 0.3461538461538462,
                                  height: screenSize.height*0.1066350710900474,/*315double.infinity*/

                                ),
                              ),

                              SizedBox(height: 4.5,),
                              Center(
                                child: Text(
                                  item['title'] ?? '',
                                  style: TextStyle(
                                    color: CustomTheme.lightTheme.primaryColor,
                                    fontSize: screenSize.width * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),)
                      ;

                    },
                  ),
                ):Center(child: Padding(padding: EdgeInsets.only(top:10),child: Text("Пока нет взаимных карточек"),),),
                const SizedBox(height: 22),

                // Padding(
                //     padding: EdgeInsets.all(16),
                //   child: ,
                // ),
                Padding(
                  padding: EdgeInsets.only(right:190.0, ),
                  child: Text(
                    'Менеджмент',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.06,
                      // Пропорциональный размер текста
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: 530,
                  child:
                          Expanded(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: /*skillsAll.length*/2,
                                // itemCount: skills.length,
                                itemBuilder: (context, index) {
                                  final current=skillsAll[index];
                                  return Padding(
                                    padding: EdgeInsets.all(4),
                                    child: MiddleSkillCardImage(id:current["id"].toString(),owner_id:current["owner_id"],title:current["title"],
                                      description: current["description"],image_url: current["image_url"],
                                      tags: current['tags'].split(/*delimiterPattern*/'#'), widthScale: 1, heightScale: 1,isLiked:false),
                                  );
                                },
                              ),
                          )
                ),
                SizedBox(height: 10.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Icon(Icons.arrow_drop_down_sharp) ,
                    TextButton(child: Text("Показать больше",),
                      onPressed: (){
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.only(right:190.0, ),
                  child: Text(
                    'Искусство',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.06,
                      // Пропорциональный размер текста
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                    height: 560,
                    child:
                    Expanded(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: /*skillsAll.length*/2,
                        // itemCount: skills.length,
                        itemBuilder: (context, index) {
                          final current=skillsAll[index+2];
                          return Padding(
                            padding: EdgeInsets.all(4),
                            child: MiddleSkillCardImage(id:current["id"].toString(),owner_id:current["owner_id"],title:current["title"],
                                description: current["description"],image_url: current["image_url"],
                                tags: current['tags'].split(/*delimiterPattern*/'#'), widthScale: 1, heightScale: 1,isLiked:false),
                          );
                        },
                      ),
                    )
                ),
                SizedBox(height: 10.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Icon(Icons.arrow_drop_down_sharp) ,
                    TextButton(child: Text("Показать больше",),
                      onPressed: (){
                      },
                    ),
                  ],
                ),

//MiddleSkillCardImage(),
               // BigSkillCard(title: currentSkill['title'] ?? '', description: currentSkill['description'] ?? '', tags:  currentSkill['tags'].split(/*delimiterPattern*/'#')/*.removeAt(0)*//*[currentSkill['param3'] ?? '']*/, widthScale: 1, heightScale: 1),
              ],
            ),



          //   BigSkillCard(title: "Разработка для андроид", description: "Я обучаю программированию для Android. Научу создавать приложения на Java и Kotlin, работать с Android Studio. У меня 5 лет опыта разработки мобильных приложений. Приходите!",
          //       tags: ["Кодинг","Kotlin", "Android"], widthScale: widthScale, heightScale: heightScale),
           ],
        ),

            //: Center(child: Padding(padding: EdgeInsets.only(top:200),child: Text("Пока нет взаимных карточек"),),)
    ),);
  }

}

class Promezutok extends StatefulWidget {
  const Promezutok({super.key});
  @override
  State<Promezutok> createState() => _PromezutokState();
}

class _PromezutokState extends State<Promezutok>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 0),(){
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            // Navigate to the SecondScreen
            //return Likes();
            //return CardDetailPage(card: CardModel(id: '1', ownerId: 'ad71148d-6894-4f8d-a56f-8b1db5da336d', title: 'Android', description: 'Я обучаю программированию для Android. Научу создавать приложения на Java и Kotlin, работать с Android Studio. У меня 5 лет опыта разработки мобильных приложений. Приходите!', createdAt: DateTime(200)));
            return AccountPage();
            //return MySkillsScreen();
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
        ),);
    //  Navigator.pop(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

}
