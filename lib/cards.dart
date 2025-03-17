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
import 'constants.dart';
import 'login.dart';
import 'main.dart';

class MiniSkillCard extends StatelessWidget {
  // Карточка скила в списке
  final String skillName;
  final Size screenSize;
  final  int index;
  final  String image_url;
  MiniSkillCard({super.key, required this.skillName, required this.screenSize, required this.index, required this.image_url});
  @override
  Widget build(BuildContext context) {
    return
      Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: screenSize.width * 0.3461538461538462,
                height: screenSize.height*0.1066350710900474,
                margin: EdgeInsets.only(right: 10.0),
                child:
                Card(
                    child:
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        //'https://inusbwyedxylsbcxolat.supabase.co/storage/v1/object/public/images/images/1000005544.jpg',
                        image_url,
                        fit: BoxFit.cover,
                        // height: 110,
                        // width: 330/*315double.infinity*/,

                      ),
                    )
                  //         ElevatedButton(
                  //
                  //           onPressed: (){
                  //             // setState(() {
                  //             //
                  //             // });
                  //             showingIndex=index;
                  //             // setState{
                  //             //
                  //             //   }
                  //           },
                  // child: null,
                  // style: ElevatedButton.styleFrom(
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(15)
                  //     )
                  // ),
                  //         ),
                ),
              ),
              //     Container(
              //       width: screenSize.width * 0.3461538461538462,
              //       height:  screenSize.height*0.1066350710900474,
              //     //  margin: EdgeInsets.only(right: 40.0),
              //       decoration: BoxDecoration(
              //       ),
              //       child: ElevatedButton(
              //         onPressed: (){},
              //         child: null,
              //         style: ElevatedButton.styleFrom(
              //             shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(15)
              //             )
              //         ),
              //
              //         /*style: ElevatedButton.styleFrom(
              //   minimumSize: Size(
              //       screenSize.width * 0.3461538461538462,
              //       screenSize.height*0.1066350710900474)
              // )*/
              //       ),
              //     ),

              Text(
                skillName,
                style: TextStyle(
                  color: Colors.white/*CustomTheme.lightTheme.primaryColor*/,
                  fontSize: screenSize.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          // Padding(padding: EdgeInsets.only(right: 20))
        ],
      );
  }
}
class SkillChip extends StatelessWidget {
  // Чип для отображения тэгов скила
  final String label;

  SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: CustomTheme.lightTheme.primaryColor,
      ),

      child: Padding(
        padding:EdgeInsets.only(left: 15,right: 15, top:7.5,bottom:7.5),
        child: Text(label,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
      ),
    );
    // return Chip(
    //   label: Text(label,style: TextStyle(color: Colors.white),),
    //   backgroundColor: CustomTheme.lightTheme.primaryColor,
    // );
  }
}
class SkillChip2 extends StatelessWidget {
  // Чип для отображения тэгов скила
  final String label;

  SkillChip2({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: CustomTheme.lightTheme.secondaryHeaderColor,
      ),

      child: Padding(
        padding:EdgeInsets.only(left: 10 /*15*/,right: 10, top:3, bottom: 3/*top:7.5,bottom:7.5*/),
        child: Text(label, style: TextStyle(fontSize: 14, color: CustomTheme.lightTheme.primaryColor,fontWeight: FontWeight.w700),),
      ),
    );
    // return Chip(
    //   label: Text(label,style: TextStyle(color: Colors.white),),
    //   backgroundColor: CustomTheme.lightTheme.primaryColor,
    // );
  }
}
class SkillTirle extends StatelessWidget {
  // Чип для отображения тэгов скила
  final String label;

  SkillTirle({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: CustomTheme.lightTheme.secondaryHeaderColor,
      ),

      child: Padding(
        padding:EdgeInsets.only(left:10 /*15*/,right: 10, top:3, bottom: 3/*top:7.5,bottom:7.5*/),
        child: Text(label, style: TextStyle(fontSize: 17, color: CustomTheme.lightTheme.primaryColor,fontWeight: FontWeight.w700),),
      ),
    );
    // return Chip(
    //   label: Text(label,style: TextStyle(color: Colors.white),),
    //   backgroundColor: CustomTheme.lightTheme.primaryColor,
    // );
  }
}
// class MiddleSkillCard extends StatelessWidget {
//   final String id;
//   final String owner_id;
//   final String title;
//   final String description;
//   final List<String> tags;
//   final double widthScale;
//   final double heightScale;
//   //final DateTime createdAt;
//
//   // Правильный конструктор без @override и типа возвращаемого значения
//   MiddleSkillCard({
//     required this.id,
//     required this.owner_id,
//     required this.title,
//     required this.description,
//     required this.tags,
//     required this.widthScale,
//     required this.heightScale,
//     //  required this.createdAt,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // Код метода build
//     return  Column(
//       children: [
//         GestureDetector(
//           onTap:(){
//             Navigator.of(context).push(
//               PageRouteBuilder(
//                 pageBuilder: (context, animation, secondaryAnimation) {
//                   // Navigate to the SecondScreen
//                   return CardDetailPage(tags: tags,image_url:imcard: CardModel(id: id, owner_id: owner_id, title: title, description: description, createdAt:DateTime.now()));
//                 },
//                 transitionsBuilder:
//                     (context, animation, secondaryAnimation, child) {
//                   const begin = Offset(1.0, 0.0);
//                   const end = Offset.zero;
//                   const curve = Curves.easeInOut;
//                   var tween = Tween(begin: begin, end: end)
//                       .chain(CurveTween(curve: curve));
//                   var offsetAnimation = animation.drive(tween);
//                   return SlideTransition(
//                     // Apply slide transition
//                     position: offsetAnimation,
//                     child: child,
//                   );
//                 },
//               ),
//             );
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               color: Color(0xffffffff),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.grey, //New
//                     blurRadius: 7.0,
//                     offset: Offset(0, 5))
//               ],
//             ),
//
//             //elevation: 4.0 * heightScale,
//
//             child: Padding(
//               padding: EdgeInsets.all(16.0 * widthScale),
//               child: Padding(
//                 padding: EdgeInsets.only(left: 5),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 24.0 * widthScale,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 8.0 * heightScale),
//                     Padding(
//                       padding: EdgeInsets.only(left:10),
//                       child: Text(
//                         'О скиле',
//                         style: TextStyle(
//                           fontSize: 18.0 * widthScale,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(height: 8.0 * heightScale),
//                     Text(
//
//                       description,
//                       style: TextStyle(fontSize: 16.0 * widthScale),
//                     ),
//                     SizedBox(height: 16.0 * heightScale),
//
//                     Wrap(
//                       spacing: 8.0 * widthScale,
//                       children: tags
//                           .map((tag) => SkillChip(label: tag))
//                           .toList(),
//                     ),
//                   ],
//                 ),
//
//               )
//               ,
//             ),
//           ),
//         )
//         ,
//         // SizedBox(height: 26.0 * heightScale),
//       ],
//     );
//   }
// }
class Heartwidget extends StatefulWidget {
  final String id;
  final String? id2;
  final String owner_id;
  final String? owner_id2;
   final bool? isLiked;
  //final CardModel card;
  ///Прежний конструктор
  //const CardDetailPage({super.key, required this.card});
  const Heartwidget({Key? key,
    required this.id,
    required this.owner_id,
    this.owner_id2,
    this.id2,
      this.isLiked
  }) : super(key: key);


  @override
  State<Heartwidget> createState() => _HeartState();
}
class _HeartState extends State<Heartwidget> {
  //
  // @override
  // // TODO: implement widget
  // Heartwidget get widget => super.widget;
  bool _isLiked = false;




  bool _isCreating = false;
  // void likedesign(){
  //   _isLiked = !_isLiked;
  // }

  Future<void> likeCard(String userId, String cardId) async {
    try {
      final response = await supabase.from('likes').insert({
        'user_id': userId,
        'card_id': cardId,
        'created_at': DateTime.now().toIso8601String(),
      }).execute();

    } catch (e) {
      rethrow;
    }
  }

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
  @override
  Widget build(BuildContext context) {
    if(widget.isLiked!){
      _isLiked = true;
    }

    if(widget.id2==null && widget.owner_id2==null){_isCreating=false;}else{_isCreating=true;}
    // if(widget.isLiked!=null){_isLiked=true;}else{_isLiked=false;}
    return ClipOval(
      child: Container(
          color: CustomTheme.lightTheme.secondaryHeaderColor,
          width: 35,
          height: 35,
          child:
          IconButton(onPressed: () async {
            setState(() {
              _isLiked = !_isLiked;
            });

            _isLiked?
            await likeCard(Supabase.instance.client.auth.currentUser!.id,widget.id):
            deleteLike(Supabase.instance.client.auth.currentUser!.id, widget.id)/*;*/ ;

            if(_isCreating){
              CreateRoom(widget.owner_id, widget.id, widget.owner_id2!, widget.id2!);
            }

          }, icon: _isLiked?  SvgPicture.asset('assets/icons/heartClicked.svg'): SvgPicture.asset('assets/icons/heart.svg') ,)

      ),
    );
  }
}
class MiddleSkillCardImage extends StatelessWidget {
  final String id;
  final String owner_id;
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
  const MiddleSkillCardImage({Key? key,
    required this.id,
    required this.owner_id,
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
                    child:    Heartwidget(id: id,owner_id: owner_id,isLiked:isLiked/*isLiked: false,*/),
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

class MiddleSkillCardImagePen extends StatelessWidget {
  final String id;
  final String owner_id;
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
  const MiddleSkillCardImagePen({Key? key,
    required this.id,
    required this.owner_id,
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
      GestureDetector(
        onTap:(){
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                // Navigate to the SecondScreen
                return CardDetailPage(tags: tags,image_url:image_url,card: CardModel(id: id, owner_id: owner_id, title: title, description: description, createdAt:DateTime.now()));
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
                    child: IconButton(onPressed: (){

                    }, icon: Icon(Icons.add_circle,size: 40, color: CustomTheme.lightTheme.secondaryHeaderColor))
                    //Heartwidget(id: id,owner_id: owner_id,isLiked:isLiked/*isLiked: false,*/),
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
    ),
    );
  }
}
