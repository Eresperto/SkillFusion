import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as path;

import 'MySkills.dart';
import 'cards.dart';
import 'main.dart';

class NewSkillApp extends StatefulWidget {
  @override
  _NewSkillScreen createState() => _NewSkillScreen();
}
class _NewSkillScreen extends State<NewSkillApp> {
  final SupabaseClient supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  XFile? _pickedFile;
  List<Map<String, dynamic>> _images = [];

  var _currentIndex = 0;
  final TextEditingController _textController = TextEditingController();
  final List<String> _inputValues = [];
  bool isBigField=false;
  bool isAddImage=false;
  String titleText="Название Скила";
  String descriptionText="Здесь вы можете описать навык , которому будете учить людей!";
  List<String> tagss=['Теги',' Скила'];
  double height=52;
  double fielsheight=35;
  // Асинхронный метод, который вызывается после ввода 3 значений.
  Future<void> _processInputs(List<String> inputs) async {
    // Здесь можно реализовать любую асинхронную логику,
    // например, отправку данных на сервер.
    await Future.delayed(Duration(seconds: 1));
    print("Обработка значений: $inputs");
    // Дополнительная логика обработки...
  }




  void _handleButtonPress() {
    String currentInput = _textController.text.trim();
    // if (currentInput.isEmpty && currentIndex<=3) {
    //   return; // Можно добавить уведомление об ошибке или другое поведение.
    // }


    setState(() {
      if(_inputValues.isEmpty){
        titleText=currentInput;
      }else if(_inputValues.length==1){
        descriptionText=currentInput;
      }else if(_inputValues.length==2){
        tagss=currentInput.split(/*delimiterPattern*/'#');
        isAddImage=true;
      }

      _inputValues.add(currentInput);
      _textController.clear();
      //2
      if (currentIndex != 4) {
        currentIndex++;
      }
    });

    if(currentIndex>=1){
      setState(() {
        height=100;
        fielsheight=60;
      });

    }

    // Если введено 4 значения, запускаем асинхронную обработку.
    //было 3 до возни с картинками
    if (currentIndex==4) {
    //if (_inputValues.length == 3) {
      createCard(_inputValues[0], _inputValues[1], _inputValues[2],);
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MySkillsScreen()));
     // createCard(_inputValues[0], _inputValues[1], _inputValues[2]).then((_) {
        // После обработки можно сбросить список для нового цикла.
        // setState(() {
        //   _inputValues.clear();
        // });


    //  });
    }
  }
  // Future<void> _fetchImages() async {
  //   try {
  //     // Получаем данные об изображениях из таблицы и сортируем по имени файла
  //     final response = await supabase.from('imagas').select().order('file_name', ascending: true);
  //     setState(() {
  //       _images = List<Map<String, dynamic>>.from(response);
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Ошибка загрузки изображений: $e')),
  //     );
  //   }
  // }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _pickedFile = pickedFile;
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, выберите изображение')),
      );
      return;
    }

    try {
      final fileName = path.basename(_pickedFile!.path);
      final filePath = 'images/$fileName';

      // Загружаем файл в хранилище Supabase
      await supabase.storage.from('images').uploadBinary(
        filePath,
        _imageBytes!,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      // Получаем публичный URL загруженного файла
      final publicUrl = supabase.storage.from('images').getPublicUrl(filePath);

      // Сохраняем данные об изображении в базу данных
      await supabase.from('imagas').insert({
        'file_name': fileName,
        'file_url': publicUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Изображение успешно загружено!')),
      );

      setState(() {
        _imageBytes = null;
        _pickedFile = null;
      });

      // Обновляем список изображений
      //_fetchImages();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки: $e')),
      );
    }
  }

  Future<void> createCard(String title, String description,String tags) async {
 //
    if (_pickedFile == null) {
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Пожалуйста, выберите изображение')),
     );
      return;
    }
 //String publicUrl="";
    try {
      final fileName = path.basename(_pickedFile!.path);
      final filePath = 'images/$fileName';

      // Загружаем файл в хранилище Supabase
      await supabase.storage.from('images').uploadBinary(
        filePath,
        _imageBytes!,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      // Получаем публичный URL загруженного файла
      final publicUrl = supabase.storage.from('images').getPublicUrl(filePath);

      // Сохраняем данные об изображении в базу данных
      await supabase.from('cards').insert({
        'owner_id': supabase.auth.currentUser?.id,
        'title': title,
        'description': description,
        'tags':tags,
         'image_url':publicUrl,
        'created_at': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Изображение успешно загружено!')),
      );

      setState(() {
        _imageBytes = null;
        _pickedFile = null;
      });

      // Обновляем список изображений
      //_fetchImages();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки: $e')),
      );
    }
    // try{
    //   await supabase.from('cards').insert({
    //     'owner_id': supabase.auth.currentUser?.id,
    //     'title': title,
    //     'description': description,
    //     'tags':tags,
    //    // 'image_url':publicUrl,
    //     'created_at': DateTime.now().toIso8601String(),
    //   });
    // final fileName = path.basename(_pickedFile!.path);
    // final filePath = 'images/$fileName';
    //
    // // Загружаем файл в хранилище Supabase
    // await supabase.storage.from('images').uploadBinary(
    //   filePath,
    //   _imageBytes!,
    //   fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
    // );
    //
    // // Получаем публичный URL загруженного файла
    // final publicUrl = supabase.storage.from('images').getPublicUrl(filePath);
    //
    // // Сохраняем данные об изображении в базу данных
    // await supabase.from('imagas').insert({
    //   'file_name': fileName,
    //   'file_url': publicUrl,
    // });
    //
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Изображение успешно загружено!')),
    // );
    //
    // setState(() {
    //   _imageBytes = null;
    //   _pickedFile = null;
    // });
    //
    //
    // // Обновляем список изображений
    // //_fetchImages();
    //

  // } catch (e) {
  // ScaffoldMessenger.of(context).showSnackBar(
  // SnackBar(content: Text('Ошибка загрузки: $e')),
  // );
  // }

  }
//,"Теги желаемого скила(#)"
  List<String> mytexts = [
    "Название скила","Описание скила","Теги вашего скила(#)"
  ];
  //,"Теги желаемого скила(#)"
  List<String> mydescriptt = [
    "Английский",
    "У меня уровень английского C1."
        /*"Смогу помочь вам дойти до этого же уровня."
        " Можно обучаться оналйн или офлайн",*/
    ,"#Английский #Лингвистика "
  ];


  final TextEditingController emailController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    super.dispose();
  }

  String currentText="";
  var currentIndex=0;
  String firstfield="";

  String secondfield="";
  String thirsfield="";

  // void onNewStep(){
  //   setState(() {
  //     for (currentIndex; currentIndex < 2; currentIndex++) {
  //       switch (currentIndex) {
  //         case 0:
  //           {
  //             firstfield = emailController.text;
  //             emailController.text = "";
  //             // currentText="";
  //           }
  //         case 1:
  //           {
  //             secondfield = emailController.text;
  //             emailController.text = "";
  //             // currentText="";
  //           }
  //         case 2:
  //           {
  //             thirsfield == emailController.text;
  //             emailController.text = "";
  //             //   currentText="";
  //
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => MySkillsScreen()));
  //             createCard(firstfield, secondfield);
  //           //  createCard(_inputValues[0], _inputValues[1]);
  //           }
  //       }
  //     //  _inputValues[currentIndex] = emailController.text.toString();
  //
  //
  //     }
  //   });
  // }

  void onTabTapped() {
    setState(() {
      _currentIndex = _currentIndex+1;
    });
  }


  @override
  Widget build(BuildContext context) {
    // Получаем размеры экрана
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    // Коэффициенты масштабирования
    final double heightScale = screenHeight / 844;
    final double widthScale = screenWidth / 390;

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home:   Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   titleTextStyle: TextStyle(color: CustomTheme.lightTheme.primaryColor,fontSize: 24*heightScale),
        //   title: Text('Новый скилл'),
        // ),
        body: Padding(
            padding: EdgeInsets.all(16.0 * widthScale),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                 // ElevatedButton(onPressed: _pickImage, child: Text("")),
                  SizedBox(height: 125,),
                  //SizedBox(height: 175,),
                  Center(child: Text(
                    "Новый скил",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, fontFamily: "Montserrat"),
                  ),),

                  SizedBox(height: 30.0 * heightScale),
                  //SizedBox(height: 100.0 * heightScale),




                          //SizedBox(height: 13*heightScale,),


                MiddleSkillCardImage(id: '1', owner_id: 'momater', title:titleText /*_inputValues==null? _inputValues[0]: titleText*/, description: descriptionText/*_inputValues[1].isEmpty? descriptionText: _inputValues[1]*/, tags:tagss /*_inputValues[2]==null? tagss: _inputValues[2].split('#')*/, image_url: 'https://inusbwyedxylsbcxolat.supabase.co/storage/v1/object/public/images/images/1000040703.png', widthScale: widthScale, heightScale: heightScale, isLiked:false)
,

                Padding(
                    padding: EdgeInsets.only(left:20, top:20),
                child:  SizedBox( height: height * heightScale,width: 312*widthScale,
                    child: isAddImage?
                    // Center(
                    //     child:Column(
                    //       children: [
                    //         Container(
                    //             height: 110,
                    //             width: 330,
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(20),
                    //               border: Border.all(
                    //                 color: CustomTheme.lightTheme.primaryColor,
                    //                 width: 1.5,
                    //               ),
                    //             ),
                    //             child:  _imageBytes != null?
                    //             // Padding(
                    //             //   padding: const EdgeInsets.all(8.0),
                    //              /* child:*/
                    //             ClipRRect(
                    //               borderRadius: BorderRadius.circular(20),
                    //               child:
                    //                 Image.memory(_imageBytes!, height: 200, fit: BoxFit.cover, )
                    //             )
                    //     //)
                    //                 : Center(child:
                    //
                    //             Center(
                    //               child:
                    //               /*ClipOval(
                    //   child:*/
                    //               Container(
                    //                 width: 61,
                    //                 height: 61,
                    //                 decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.circular(20),
                    //                   color: CustomTheme.lightTheme.highlightColor,
                    //
                    //                 ),
                    //
                    //                 child:
                    //                 IconButton(onPressed: _pickImage,
                    //                     icon: Icon(Icons.add,size: 36.0 * widthScale, color: Colors.white,)) ,
                    //               ),
                    //             ),
                    //             )
                    //         ),
                    //
                    //         Row(mainAxisAlignment: MainAxisAlignment.start,
                    //           children: [
                    //             SizedBox(width: 39*widthScale,),
                    //             Text(
                    //
                    //               "${mytexts[currentIndex]}",
                    //
                    //               style: TextStyle(
                    //                   fontSize: 24.0 * widthScale,
                    //                   fontWeight: FontWeight.bold,
                    //                   color: CustomTheme.lightTheme.primaryColor
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //
                    //         SizedBox(height: 13*heightScale,),
                    //


                        //:
                    Center(
                      child:Column(
                        children: [
                          Container(
                              height: 100,
                              width: 330,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: CustomTheme.lightTheme.primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              child:  _imageBytes != null?
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              /* child:*/
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child:
                                  Image.memory(_imageBytes!, height: 200, fit: BoxFit.cover, )
                              )
                              //)
                                  : Center(child:

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
                                  IconButton(onPressed: _pickImage,
                                      icon: Icon(Icons.add,size: 36.0 * widthScale, color: Colors.white,)) ,
                                ),
                              ),
                              )
                          ),
                        ],
                      ),
                    )
                    :
                    TextField(

                      controller: _textController,
                      // controller: emailController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: mydescriptt[currentIndex],
                        contentPadding: EdgeInsets.only(bottom: fielsheight,left: 20),/*.all()*//*symmetric(vertical: *//*17*//*fielsheight, horizontal: 20.0),*/
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomTheme.lightTheme.primaryColor, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                    )
                ),
                ),

                  //       ],
                  //
                  //     )
                  //
                  //
                  // ),


                  SizedBox(height: 24.0 * heightScale),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.help_outline,
                        size: 24.0 * widthScale,
                        color: CustomTheme.lightTheme.primaryColor,
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      Text("Что здесь писать?", style: TextStyle( color: CustomTheme.lightTheme.primaryColor),)
                    ],

                  ),
                  SizedBox(height: 90,),
                  Center(
                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomTheme.lightTheme.primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0 * widthScale,
                          vertical: 12.0 * heightScale,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0 * widthScale),
                        ),
                      ),

                      onPressed: _handleButtonPress,
                    //  onPressed: onNewStep,
                      // Действие при нажатии на кнопку "Дальше"



                      child: Text(
                        'Дальше',
                        style: TextStyle(fontSize: 20.0 * widthScale, color: Colors.white),
                      ),

                    ),
                  ),
                ],
              ),
            )

        ),
      ),
    );
  }
}



// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Инициализация Supabase
//   await Supabase.initialize(
//     url: 'https://ihqzpasymvozjlpllsez.supabase.co', // Замените на ваш URL Supabase
//     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlocXpwYXN5bXZvempscGxsc2V6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI0MzkwMDUsImV4cCI6MjA0ODAxNTAwNX0.uCEKq46zAabGXD5vb1tlwQbv0CuYVmDoNf-Psrncg1s', // Замените на ваш анонимный ключ
//   );
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Получение данных из Supabase',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: DataListPage(),
//     );
//   }
// }
//
// class DataListPage extends StatefulWidget {
//   @override
//   _DataListPageState createState() => _DataListPageState();
// }
//
// class _DataListPageState extends State<DataListPage> {
//   final SupabaseClient _supabaseClient = Supabase.instance.client;
//   Future<List<dynamic>>? _futureData;
//
//   @override
//   void initState() {
//     super.initState();
//     // Начинаем загрузку данных при инициализации виджета
//     _futureData = _fetchData();
//   }
//
//   // Метод для получения данных из таблицы 'users'
//   Future<List<dynamic>> _fetchData() async {
//     try {
//       final List<dynamic> response = await _supabaseClient
//           .from('users') // Замените 'users' на название вашей таблицы
//           .select();
//
//       return response;
//     } catch (error) {
//       // Обрабатываем возможные исключения
//       throw Exception('Ошибка при получении данных: $error');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Список пользователей'),
//       ),
//       body: FutureBuilder<List<dynamic>>(
//         future: _futureData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             // Отображаем индикатор загрузки
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             // Отображаем сообщение об ошибке
//             return Center(child: Text('Ошибка: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             // Если данных нет, отображаем соответствующее сообщение
//             return Center(child: Text('Данных нет'));
//           } else {
//             // Отображаем данные в списке
//             final users = snapshot.data!;
//             return ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 final user = users[index];
//                 return ListTile(
//                   leading: Icon(Icons.person),
//                   title: Text(user['name'] ?? 'Без имени'),
//                   subtitle: Text(user['email'] ?? 'Без email'),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }