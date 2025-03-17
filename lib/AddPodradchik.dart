import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Likes.dart';
import 'NewSkill.dart';
import 'cards.dart';
import 'main.dart';


class Adder extends StatefulWidget {
  @override
  _Adder createState() => _Adder();
}
class _Adder extends State<Adder> {
  @override
  Widget build(BuildContext context) {
    // Получаем размеры экрана
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

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

    List<String> alltags = [
      'Кодинг', 'Kotlin', 'Android',

    ];

    // Коэффициенты масштабирования для сохранения пропорций
    final double heightScale = screenHeight / 844;
    final double widthScale = screenWidth / 390;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(

            body: SingleChildScrollView(
            child: Padding(
            padding: EdgeInsets.all(16.0 * widthScale),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

        Padding(padding: EdgeInsets.only(top:60*heightScale)),
    Center(
      child:Text('Неполадки',
    style: TextStyle(fontSize: 30,
    fontWeight: FontWeight.w600,
    color: CustomTheme.lightTheme.primaryColor),
    ) ,
    ),
    Padding(padding: EdgeInsets.only(top: 6*heightScale)),

              Padding(padding: EdgeInsets.only(left: 0, top:39, right: 50),
                child:Column(
                  children: [
                  Text(
                  'Название неполадки'
                  ,
                  style: TextStyle(
                    fontSize: 19.0 * widthScale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                    Padding(padding: EdgeInsets.only(top:14)),
                    Wrap(
                      spacing: 8.0 * widthScale,
                      children: alltags
                          .map((tag) => SkillChip(label: tag))
                          .toList(),
                    ),
                    Padding(padding: EdgeInsets.only(top:24)),
               Column(
                 children: [
                   Padding(padding: EdgeInsets.only(top:14, right: 90),
                     child: Text(
                       'Описание',
                       style: TextStyle(
                         fontSize: 19.0 * widthScale,
                         fontWeight: FontWeight.w600,
                       ),
                     ),),
                   Padding(padding: EdgeInsets.only(top:14, left:30),
                     child: Text(
                       '          Прежде всего, внедрение современных методик играет важную роль в формировании анализа существующих паттернов поведения. Но высокое качество позиционных исследований позволяет оценить значение форм воздействия.',
                       style: TextStyle(
                         fontSize: 14.0 * widthScale,
                         fontWeight: FontWeight.w400,
                       ),
                     ),),


                 ],
               ),
                    Padding(padding: EdgeInsets.only(top:34)),
                    Padding(padding: EdgeInsets.only(left: 40),
                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomTheme.lightTheme.primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0 * widthScale,
                          vertical: 6.0 * heightScale,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0 * widthScale),
                        ),
                      ),

                      onPressed: (){},
                      // Действие при нажатии на кнопку "Дальше"



                      child: Text(
                        'Решить проблему',
                        style: TextStyle(fontSize: 15.0 * widthScale, color: Colors.white),
                      ),

                    ),
                    ),



                ],),


              ),




            ],
        ),
            ),
            ),
        ),
    );


  }

}