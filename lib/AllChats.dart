import 'package:deeplink3/Likes.dart';
import 'package:deeplink3/NewSkill.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
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
import 'main.dart';

class MiniSkillCard extends StatelessWidget {
  // Карточка скила в списке
  final String skillName;
  final Size screenSize;

  MiniSkillCard({super.key, required this.skillName, required this.screenSize});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: screenSize.width * 0.3461538461538462,
          height: screenSize.height*0.1066350710900474,
          margin: EdgeInsets.only(right: 10.0),
          child: Card(
            color: CustomTheme.lightTheme.secondaryHeaderColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),

          ),
        ),
        Text(
          skillName,
          style: TextStyle(
            color: CustomTheme.lightTheme.primaryColor,
            fontSize: screenSize.width * 0.045,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}

class AllChats extends StatefulWidget{
  @override
  State<AllChats> createState() => _AllChatsState();
}
class _AllChatsState extends State<AllChats>{

  List<String> titles = [
    'Разработка для Android','Игра на гитаре'
  ];
  List<String> descriptions = [
    'Прежде всего, внедрение современных методик по разработке приложений',
    'Прежде всего, внедрение современных методик по разработке приложений'
  ];
  List<String> messages = [
    "Область скила","О вашем скиле"
  ];
  List<String> senders = [
    "Область скила","О вашем скиле"
  ];
  // int row = 3;
  // int col = 2;
  // var twoDList = List<List>.generate(row, (i) => List<dynamic>.generate(col, (index) => null, growable: false), growable: false);

  List<List<String>> alltags = [
    ['Кодинг', 'Kotlin', 'Android'],
    ['Музыка', /*'Kotlin',*/ 'Гитара'],
  ];


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    final double heightScale = screenHeight / 844;
    final double widthScale = screenWidth / 390;
    return Column(
      children: [
        Scaffold(

          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0 * widthScale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(padding: EdgeInsets.only(top:60*heightScale)),
                  Center(child:Text('Чаты',
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
                  Column(

                    children: [
                      Container(
                        height: 500,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: descriptions.length,
                          itemBuilder: (context, index) {
                            return ChatCard(Message: messages[index], screenSize: screenSize, time: titles[index], sender: senders[index]);
                          },
                        ),
                      )

                    ],
                  ),

                  SizedBox(height: 26.0 * heightScale),
                  //Add
                  Center(
                    child:
                    ClipOval(
                      child: Container(
                        color: CustomTheme.lightTheme.primaryColor,
                        width: 61,
                        height: 61,
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
                    ),


                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            height: screenHeight*0.1018957345971564,
            color: const Color(0xffe3f4ff),
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight:Radius.circular(15) )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: (){
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          // Navigate to the SecondScreen
                          return AccountPage();
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
                  }, iconSize: 30,
                      icon:SvgPicture.asset('assets/icons/book.svg'),
                      color: const Color(0xff1E3045)),
                  IconButton(onPressed: (){
                    // Navigator.of(context).push(
                    //   PageRouteBuilder(
                    //     pageBuilder: (context, animation, secondaryAnimation) {
                    //       // Navigate to the SecondScreen
                    //       return MySkillsScreen();
                    //     },
                    //     transitionsBuilder:
                    //         (context, animation, secondaryAnimation, child) {
                    //       const begin = Offset(1.0, 0.0);
                    //       const end = Offset.zero;
                    //       const curve = Curves.easeInOut;
                    //       var tween = Tween(begin: begin, end: end)
                    //           .chain(CurveTween(curve: curve));
                    //       var offsetAnimation = animation.drive(tween);
                    //
                    //       return SlideTransition(
                    //         // Apply slide transition
                    //         position: offsetAnimation,
                    //         child: child,
                    //       );
                    //     },
                    //   ),
                    // );
                  }, iconSize: 30,
                      icon:  SvgPicture.asset('assets/icons/cap.svg')
                      , color: const Color(0xff1E3045)),
                  IconButton(onPressed: (){
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          // Navigate to the SecondScreen
                          return Likes();
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
                  }, iconSize: 30,
                      icon: SvgPicture.asset('assets/icons/profile.svg')
                      , color: const Color(0xff1E3045))
                ],
              ),
            ),
          ),
        )
      ],
    );

  }
}

class ChatCard extends StatelessWidget {
  // Карточка скила в списке
  final String Message;
  final Size screenSize;
  final String time;
  final String sender;

  ChatCard({super.key, required this.Message, required this.screenSize,required this.time,required this.sender});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: screenSize.width * 0.3461538461538462,
          height: screenSize.height*0.1066350710900474,
          margin: EdgeInsets.only(right: 10.0),
          child: Row(
            children: [
              Icon(Icons.person),
              Column(
                children: [
                  Text(sender),
                  Text(Message),
                ],
              ),

            Text(time)
            ],
          )
        ),

      ],
    );
  }
}