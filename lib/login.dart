
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _redirecting = false;
  late final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await supabase.auth.signInWithOtp(
        email: _emailController.text.trim(),
        emailRedirectTo:
        kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
      );
      if (mounted) {
        // context.showSnackBar('Check your email for a login link!');
        _emailController.clear();
        _passwordController.clear();
      }
    } on AuthException catch (error) {
      if (mounted) /*context.showSnackBar(error.message, isError: true)*/;
    } catch (error) {
      if (mounted) {
        //   context.showSnackBar('Unexpected error occurred', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

  }

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen(
          (data) {
        if (_redirecting) return;
        final session = data.session;
        if (session != null) {
          _redirecting = true;
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(builder: (context) => Promezutok()),
          // );
          Navigator.of(context).pushReplacement(
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
        }
      },
      onError: (error) {
        if (error is AuthException) {
          // context.showSnackBar(error.message, isError: true);
        } else {
          // context.showSnackBar('Unexpected error occurred', isError: true);
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authStateSubscription.cancel();
    _passwordController.dispose();
    super.dispose();
  }

  // Метод для переключения видимости пароля
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Коэффициенты масштабирования для адаптивного дизайна
    final widthScale = screenWidth / 390;
    final heightScale = screenHeight / 844;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xffE3F4FF),
          secondary: Color(0xff1E3045),
        ),
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) =>
            Scaffold(
              body: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20 * widthScale),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 171 * heightScale),
                              Text(
                                'SkillFusion',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 30 * heightScale,
                                    fontWeight: FontWeight.bold,
                                    color: CustomTheme.lightTheme.primaryColor
                                ),
                              ),
                              SizedBox(height: 66 * heightScale),

                              Text(
                                'Регистрация',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24 * heightScale,
                                    fontWeight: FontWeight.w600,
                                    color: CustomTheme.lightTheme.primaryColor
                                ),
                              ),

                              Padding(padding: const EdgeInsets.all(30)),

                              SizedBox(height: 52 * heightScale,width: 312*widthScale,
                                  child:
                                  TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
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

                              SizedBox(height: 30,),
                              SizedBox(height: 52 * heightScale,width: 312*widthScale,
                                child:
                                TextField(
                                  //controller: _emailController,
                                    controller: _passwordController,
                                    obscureText: _obscureText,
                                    decoration: InputDecoration(
                                      hintText: 'Пароль',
                                      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
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
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          // Изменение иконки в зависимости от состояния
                                          _obscureText ? Icons.visibility_off : Icons.visibility,
                                        ),   onPressed: _togglePasswordVisibility,
                                      ),
                                    )
                                ),
                              ),
                              SizedBox(height: 50 * heightScale),
                              // SizedBox(height: 52 * heightScale,width: 312*widthScale,
                              //     child:
                              //     TextField(
                              //       controller: _passwordController,
                              //       obscureText: true,
                              //       decoration: InputDecoration(
                              //         hintText: 'Пароль',
                              //         contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                              //         border: OutlineInputBorder(
                              //           borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              //         ),
                              //         enabledBorder: OutlineInputBorder(
                              //           borderSide: BorderSide(color: CustomTheme.lightTheme.primaryColor, width: 1.0),
                              //           borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              //         ),
                              //         focusedBorder: const OutlineInputBorder(
                              //           borderSide: BorderSide(color: Colors.blue, width: 2.0),
                              //           borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              //         ),
                              //       ),
                              //     )
                              // ),
                              SizedBox(height: 69 * heightScale),
                              // SizedBox(height: 20 * heightScale),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: _isLoading ? null :    _signIn,
                            //() {
                            // Navigator.of(context).push(
                            //   PageRouteBuilder(
                            //     pageBuilder: (context, animation, secondaryAnimation) {
                            //       // Navigate to the SecondScreen
                            //       return SkillScreen();
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
                            // Действие при нажатии на "Авторизоваться"
                            //  },
                            style: ElevatedButton.styleFrom(
                              //padding: EdgeInsets.symmetric(vertical: 15 * heightScale),
                              backgroundColor: Color(0xff1E3045),
                              fixedSize: Size(196, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                            ),
                            child: Text(_isLoading ? 'Отправка...' : 'Зарегестрироваться',
                              style: TextStyle(fontSize: 15),),
                          ),
                          Padding(padding: EdgeInsets.all(58*heightScale)),
                        ],
                      ),

                    ),
                  )

              ),
            ),
      ),
    );
  }
}
