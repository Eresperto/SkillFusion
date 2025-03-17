//  // import 'dart:async';
// // //
// // // import 'package:deeplink3/profile.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_svg/svg.dart';
// // //
// // // import 'package:supabase_flutter/supabase_flutter.dart';
// // // import 'package:timeago/timeago.dart';
// // //
// // // import 'Chat.dart';
// // // import 'constants.dart';
// // // import 'main.dart';
// // // import 'message.dart';
// // //
// // // class ChatScreen extends StatefulWidget {
// // //   @override
// // //   _ChatScreenState createState() => _ChatScreenState();
// // // }
// // //
// // // class _ChatScreenState extends State<ChatScreen> {
// // //   Stream<List<Messages>>? _messagesStream;
// // //   final Map<String, Profile> _profileCache = {};
// // //
// // //   // @override
// // //   // void initState() {
// // //   //   super.initState();
// // //   //   final myUserId = supabase.auth.currentUser!.id;
// // //   //   _messagesStream = supabase
// // //   //       .from('messages')
// // //   //       .stream(primaryKey: ['id'])
// // //   //       .order('created_at')
// // //   //       .map((maps) => maps
// // //   //       .map((map) => Messages.fromMap(map: map, myUserId: myUserId))
// // //   //       .toList());
// // //   // }
// // //
// // //   Future<Profile> _getProfile(String profileId) async {
// // //     if (_profileCache.containsKey(profileId)) {
// // //       return _profileCache[profileId]!;
// // //     }
// // //     final data = await supabase.from('profiles').select().eq('id', profileId).single();
// // //     final profile = Profile.fromMap(data);
// // //     _profileCache[profileId] = profile;
// // //     return profile;
// // //   }
// // //   @override
// // //   void initState() {
// // //     final myUserId = supabase.auth.currentUser!.id;
// // //     _messagesStream = supabase
// // //         .from('messages')
// // //         .stream(primaryKey: ['id'])
// // //         .order('created_at')
// // //         .map((maps) => maps
// // //         .map((map) => Messages.fromMap(map: map, myUserId: myUserId))
// // //         .toList());
// // //     super.initState();
// // //   }
// // //
// // //   Future<void> _loadProfileCache(String profileId) async {
// // //     if (_profileCache[profileId] != null) {
// // //       return;
// // //     }
// // //     final data =
// // //     await supabase.from('profiles').select().eq('id', profileId).single();
// // //     final profile = Profile.fromMap(data);
// // //     setState(() {
// // //       _profileCache[profileId] = profile;
// // //     });
// // //   }
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(backgroundColor: Colors.white,title: const Text('Чаты')),
// // //       body: StreamBuilder<List<Messages>>(
// // //         stream: _messagesStream,
// // //         builder: (context, snapshot) {
// // //           if (snapshot.hasData) {
// // //             final messages = snapshot.data!;
// // //             return Column(
// // //               children: [
// // //                 Expanded(
// // //                   child: messages.isEmpty
// // //                       ? const Center(
// // //                     child: Text('Начните ваше общение здесь!'),
// // //                   )
// // //                       : ListView.builder(
// // //                     reverse: true,
// // //                     itemCount: messages.length,
// // //                     itemBuilder: (context, index) {
// // //                       final message = messages[index];
// // //
// // //                       /// I know it's not good to include code that is not related
// // //                       /// to rendering the widget inside build method, but for
// // //                       /// creating an app quick and dirty, it's fine 😂
// // //                       _loadProfileCache(message.profileId);
// // //
// // //                       return _ChatBubble(
// // //                         message: message,
// // //                         profile: _profileCache[message.profileId],
// // //                       );
// // //                     },
// // //                   ),
// // //                 ),
// // //                 const _MessageBar(),
// // //               ],
// // //             );
// // //           } else {
// // //             return preloader;
// // //           }
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // class _MessageBar extends StatefulWidget {
// // //   const _MessageBar({
// // //     Key? key,
// // //   }) : super(key: key);
// // //
// // //   @override
// // //   State<_MessageBar> createState() => _MessageBarState();
// // // }
// // //
// // // class _MessageBarState extends State<_MessageBar> {
// // //   late final TextEditingController _textController;
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Padding(
// // //       padding: const EdgeInsets.all(16.0),
// // //       child: Row(
// // //         children: [
// // //           Expanded(
// // //             child: TextField(
// // //               controller: _textController,
// // //               decoration: InputDecoration(
// // //                 hintText: "Type your message",
// // //                 filled: true,
// // //                 fillColor: Colors.grey[200],
// // //                 border: OutlineInputBorder(
// // //                   borderRadius: BorderRadius.circular(30.0),
// // //                   borderSide: BorderSide.none,
// // //                 ),
// // //                 contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
// // //                 suffixIcon: IconButton(
// // //                   icon: const Icon(Icons.attach_file),
// // //                   onPressed: () {},
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //           const SizedBox(width: 10),
// // //           CircleAvatar(
// // //             backgroundColor: Colors.blue,
// // //             radius: 25,
// // //             child: IconButton(
// // //                 icon: const Icon(Icons.send, color: Colors.white),
// // //                 onPressed: () => _submitMessage()
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //
// // //   }
// // //
// // //   @override
// // //   void initState() {
// // //     _textController = TextEditingController();
// // //     super.initState();
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     _textController.dispose();
// // //     super.dispose();
// // //   }
// // //   void _submitMessage() async {
// // //     final text = _textController.text;
// // //     final myUserId = supabase.auth.currentUser!.id;
// // //     if (text.isEmpty) {
// // //       return;
// // //     }
// // //     _textController.clear();
// // //     try {
// // //       await supabase.from('messages').insert({
// // //         'profile_id': myUserId,
// // //         'content': text,
// // //       });
// // //     } on PostgrestException catch (error) {
// // //       //context.showErrorSnackBar(message: error.message);
// // //     } catch (_) {
// // //       // context.showErrorSnackBar(message: unexpectedErrorMessage);
// // //     }
// // //   }
// // // }
// // //
// // //
// // // class _ChatBubble extends StatelessWidget {
// // //   const _ChatBubble({
// // //     Key? key,
// // //     required this.message,
// // //     required this.profile,
// // //   }) : super(key: key);
// // //
// // //   final Messages message;
// // //   final Profile? profile;
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     List<Widget> chatContents = [
// // //       if (!message.isMine)
// // //         CircleAvatar(
// // //           child: profile == null
// // //               ? preloader
// // //               : Text(profile!.username.substring(0, 2)),
// // //         ),
// // //       const SizedBox(width: 12),
// // //       Flexible(
// // //         child: Container(
// // //           padding: const EdgeInsets.symmetric(
// // //             vertical: 10,
// // //             horizontal: 12,
// // //           ),
// // //           decoration: BoxDecoration(
// // //             color: message.isMine
// // //                 ? const Color(0xffe5f4ff)
// // //
// // //             // ? const Color(0xff2D435D)
// // //                 : const Color(0xfff7f7f9),
// // //             borderRadius: BorderRadius.circular(8),
// // //           ),
// // //           child: Text(
// // //             message.content,
// // //             style: TextStyle(
// // //                 color: Theme.of(context).primaryColor, /*message.isMine
// // //                   ? Colors.white
// // //                   : Theme.of(context).primaryColor,*/
// // //                 fontSize: 20,
// // //                 fontWeight: FontWeight.w400
// // //             ),
// // //
// // //           ),
// // //         ),
// // //       ),
// // //       const SizedBox(width: 12),
// // //       Text(format(message.createdAt, locale: 'en_short')),
// // //       const SizedBox(width: 60),
// // //     ];
// // //     if (message.isMine) {
// // //       chatContents = chatContents.reversed.toList();
// // //     }
// // //     return Padding(
// // //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
// // //       child: Row(
// // //         mainAxisAlignment:
// // //         message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
// // //         children: chatContents,
// // //       ),
// // //     );
// // //   }
// // // }
//
// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:timeago/timeago.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:rxdart/rxdart.dart';
// //
// // import 'Chat.dart';
// // import 'constants.dart';
// // import 'main.dart';
// // import 'message.dart';
// // import 'profile.dart';
// //
// // class ChatScreen extends StatefulWidget {
// //   @override
// //   _ChatScreenState createState() => _ChatScreenState();
// // }
// //
// // class _ChatScreenState extends State<ChatScreen> {
// //   final Map<String, Profile> _profileCache = {};
// //   final BehaviorSubject<List<Messages>> _messagesController = BehaviorSubject.seeded([]);
// //   Stream<List<Messages>> get _messagesStream => _messagesController.stream;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchMessages();
// //   }
// //
// //   void _fetchMessages() {
// //     final myUserId = supabase.auth.currentUser!.id;
// //     supabase
// //         .from('messages')
// //         .stream(primaryKey: ['id'])
// //         .order('created_at')
// //         .map((maps) => maps.map((map) => Messages.fromMap(map: map, myUserId: myUserId)).toList())
// //         .listen((messages) {
// //       _messagesController.add(messages);
// //     });
// //   }
// //
// //   Future<Profile> _getProfile(String profileId) async {
// //     if (_profileCache.containsKey(profileId)) return _profileCache[profileId]!;
// //     final data = await supabase.from('profiles').select().eq('id', profileId).single();
// //     final profile = Profile.fromMap(data);
// //     _profileCache[profileId] = profile;
// //     return profile;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(backgroundColor: Colors.white, title: const Text('Чаты')),
// //       body: StreamBuilder<List<Messages>>(
// //         stream: _messagesStream,
// //         builder: (context, snapshot) {
// //           if (!snapshot.hasData) return preloader;
// //           final messages = snapshot.data!;
// //           return Column(
// //             children: [
// //               Expanded(
// //                 child: messages.isEmpty
// //                     ? const Center(child: Text('Начните ваше общение здесь!'))
// //                     : ListView.builder(
// //                   reverse: true,
// //                   itemCount: messages.length,
// //                   itemBuilder: (context, index) {
// //                     final message = messages[index];
// //                     return _ChatBubble(
// //                       message: message,
// //                       getProfile: () => _getProfile(message.profileId),
// //                     );
// //                   },
// //                 ),
// //               ),
// //               const _MessageBar(),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _messagesController.close();
// //     super.dispose();
// //   }
// // }
// //
// // class _MessageBar extends StatefulWidget {
// //   const _MessageBar();
// //
// //   @override
// //   State<_MessageBar> createState() => _MessageBarState();
// // }
// //
// // class _MessageBarState extends State<_MessageBar> {
// //   late final TextEditingController _textController;
// //
// //   @override
// //   void initState() {
// //     _textController = TextEditingController();
// //     super.initState();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _textController.dispose();
// //     super.dispose();
// //   }
// //
// //   void _submitMessage() async {
// //     final text = _textController.text.trim();
// //     final myUserId = supabase.auth.currentUser!.id;
// //     if (text.isEmpty) return;
// //
// //     final newMessage = Messages(
// //       id: DateTime.now().millisecondsSinceEpoch.toString(), // Временный ID
// //       profileId: myUserId,
// //       content: text,
// //       createdAt: DateTime.now(),
// //       isMine: true,
// //     );
// //
// //     _textController.clear();
// //     _ChatScreenState? chatScreenState = context.findAncestorStateOfType<_ChatScreenState>();
// //     chatScreenState?._messagesController.add([...chatScreenState._messagesController.value, newMessage]);
// //
// //     try {
// //       await supabase.from('messages').insert({'profile_id': myUserId, 'content': text});
// //     } catch (error) {
// //       print('Ошибка отправки сообщения: $error');
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(16.0),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: TextField(
// //               controller: _textController,
// //               decoration: InputDecoration(
// //                 hintText: "Type your message",
// //                 filled: true,
// //                 fillColor: Colors.grey[200],
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(30.0),
// //                   borderSide: BorderSide.none,
// //                 ),
// //                 contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
// //                 suffixIcon: IconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 10),
// //           CircleAvatar(
// //             backgroundColor: Colors.blue,
// //             radius: 25,
// //             child: IconButton(
// //                 icon: const Icon(Icons.send, color: Colors.white),
// //                 onPressed: _submitMessage),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class _ChatBubble extends StatelessWidget {
// //   const _ChatBubble({
// //     required this.message,
// //     required this.getProfile,
// //   });
// //
// //   final Messages message;
// //   final Future<Profile> Function() getProfile;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return FutureBuilder<Profile>(
// //       future: getProfile(),
// //       builder: (context, snapshot) {
// //         final profile = snapshot.data;
// //
// //         return Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
// //           child: Row(
// //             mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
// //             children: [
// //               if (!message.isMine)
// //                 CircleAvatar(
// //                   child: profile == null ? preloader : Text(profile.username.substring(0, 2)),
// //                 ),
// //               const SizedBox(width: 12),
// //               Flexible(
// //                 child: Container(
// //                   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
// //                   decoration: BoxDecoration(
// //                     color: message.isMine ? const Color(0xffe5f4ff) : const Color(0xfff7f7f9),
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                   child: Text(
// //                     message.content,
// //                     style: TextStyle(
// //                       color: Theme.of(context).primaryColor,
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.w400,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(width: 12),
// //               Text(format(message.createdAt, locale: 'en_short')),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
//
//  import 'dart:async';
//  import 'package:deeplink3/profile.dart';
//  import 'package:flutter/material.dart';
//  import 'package:supabase_flutter/supabase_flutter.dart';
//  import 'package:timeago/timeago.dart';
//  import 'Chat.dart';
//  import 'constants.dart';
//  import 'main.dart';
//  import 'message.dart';
//
//  class ChatScreen extends StatefulWidget {
//    @override
//    _ChatScreenState createState() => _ChatScreenState();
//  }
//
//  /// Объединённая модель для сообщения и профиля
//  class MessageWithProfile {
//    final Messages message;
//    final Profile? profile;
//
//    MessageWithProfile({required this.message, required this.profile});
//  }
//
//  class _ChatScreenState extends State<ChatScreen> {
//    Stream<List<MessageWithProfile>>? _messagesStream;
//
//    @override
//    void initState() {
//      super.initState();
//      final myUserId = supabase.auth.currentUser!.id;
//      _messagesStream = supabase
//          .from('messages')
//      // Выполняем вложенный запрос для получения профилей
//          .select('*, profiles:profiles(*)')
//          .stream(primaryKey: ['id'])
//          .order('created_at')
//          .map((maps) => maps.map((map) {
//        // Преобразуем сообщение
//        final message = Messages.fromMap(map: map, myUserId: myUserId);
//        // Извлекаем данные профиля (ключ 'profiles' благодаря alias)
//        final profileData = map['profiles'];
//        Profile? profile;
//        if (profileData != null) {
//          profile = Profile.fromMap(profileData);
//        }
//        return MessageWithProfile(message: message, profile: profile);
//      }).toList());
//    }
//
//    @override
//    Widget build(BuildContext context) {
//      return Scaffold(
//        appBar: AppBar(
//          backgroundColor: Colors.white,
//          title: const Text('Чаты'),
//        ),
//        body: StreamBuilder<List<MessageWithProfile>>(
//          stream: _messagesStream,
//          builder: (context, snapshot) {
//            if (snapshot.hasData) {
//              final messages = snapshot.data!;
//              return Column(
//                children: [
//                  Expanded(
//                    child: messages.isEmpty
//                        ? const Center(
//                      child: Text('Начните ваше общение здесь!'),
//                    )
//                        : ListView.builder(
//                      reverse: true,
//                      itemCount: messages.length,
//                      itemBuilder: (context, index) {
//                        final messageWithProfile = messages[index];
//                        return _ChatBubble(
//                          message: messageWithProfile.message,
//                          profile: messageWithProfile.profile,
//                        );
//                      },
//                    ),
//                  ),
//                  const _MessageBar(),
//                ],
//              );
//            } else {
//              return preloader;
//            }
//          },
//        ),
//      );
//    }
//  }
//
//  class _MessageBar extends StatefulWidget {
//    const _MessageBar({Key? key}) : super(key: key);
//
//    @override
//    State<_MessageBar> createState() => _MessageBarState();
//  }
//
//  class _MessageBarState extends State<_MessageBar> {
//    late final TextEditingController _textController;
//
//    @override
//    void initState() {
//      _textController = TextEditingController();
//      super.initState();
//    }
//
//    @override
//    void dispose() {
//      _textController.dispose();
//      super.dispose();
//    }
//
//    void _submitMessage() async {
//      final text = _textController.text;
//      final myUserId = supabase.auth.currentUser!.id;
//      if (text.isEmpty) return;
//      _textController.clear();
//      try {
//        await supabase.from('messages').insert({
//          'profile_id': myUserId,
//          'content': text,
//        });
//      } on PostgrestException catch (error) {
//        // Обработка ошибки
//      } catch (_) {
//        // Обработка ошибки
//      }
//    }
//
//    @override
//    Widget build(BuildContext context) {
//      return Padding(
//        padding: const EdgeInsets.all(16.0),
//        child: Row(
//          children: [
//            Expanded(
//              child: TextField(
//                controller: _textController,
//                decoration: InputDecoration(
//                  hintText: "Type your message",
//                  filled: true,
//                  fillColor: Colors.grey[200],
//                  border: OutlineInputBorder(
//                    borderRadius: BorderRadius.circular(30.0),
//                    borderSide: BorderSide.none,
//                  ),
//                  contentPadding:
//                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                  suffixIcon: IconButton(
//                    icon: const Icon(Icons.attach_file),
//                    onPressed: () {},
//                  ),
//                ),
//              ),
//            ),
//            const SizedBox(width: 10),
//            CircleAvatar(
//              backgroundColor: Colors.blue,
//              radius: 25,
//              child: IconButton(
//                icon: const Icon(Icons.send, color: Colors.white),
//                onPressed: _submitMessage,
//              ),
//            ),
//          ],
//        ),
//      );
//    }
//  }
//
//  class _ChatBubble extends StatelessWidget {
//    const _ChatBubble({
//      Key? key,
//      required this.message,
//      required this.profile,
//    }) : super(key: key);
//
//    final Messages message;
//    final Profile? profile;
//
//    @override
//    Widget build(BuildContext context) {
//      List<Widget> chatContents = [
//        if (!message.isMine)
//          CircleAvatar(
//            child: profile == null
//                ? preloader
//                : Text(profile!.username.substring(0, 2)),
//          ),
//        const SizedBox(width: 12),
//        Flexible(
//          child: Container(
//            padding: const EdgeInsets.symmetric(
//              vertical: 10,
//              horizontal: 12,
//            ),
//            decoration: BoxDecoration(
//              color: message.isMine
//                  ? const Color(0xffe5f4ff)
//                  : const Color(0xfff7f7f9),
//              borderRadius: BorderRadius.circular(8),
//            ),
//            child: Text(
//              message.content,
//              style: TextStyle(
//                color: Theme.of(context).primaryColor,
//                fontSize: 20,
//                fontWeight: FontWeight.w400,
//              ),
//            ),
//          ),
//        ),
//        const SizedBox(width: 12),
//        Text(format(message.createdAt, locale: 'en_short')),
//        const SizedBox(width: 60),
//      ];
//
//      if (message.isMine) {
//        chatContents = chatContents.reversed.toList();
//      }
//
//      return Padding(
//        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
//        child: Row(
//          mainAxisAlignment:
//          message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
//          children: chatContents,
//        ),
//      );
//    }
//  }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Chat.dart';
import 'constants.dart';
import 'main.dart';
import 'message.dart';
import 'profile.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final Stream<List<Messages>> _messagesStream;
  final Map<String, Future<Profile>> _profileCache = {};

  @override
  void initState() {
    super.initState();
    final myUserId = supabase.auth.currentUser!.id;
    _messagesStream = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((maps) => maps
        .map((map) => Messages.fromMap(map: map, myUserId: myUserId))
        .toList());
  }

  Future<Profile> _fetchProfile(String profileId) {
    return _profileCache.putIfAbsent(profileId, () async {
      final data = await supabase.from('profiles').select().eq('id', profileId).single();
      return Profile.fromMap(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, title: const Text('Чаты')),
      body: StreamBuilder<List<Messages>>(
        stream: _messagesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return preloader;
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки сообщений'));
          }
          final messages = snapshot.data ?? [];

          return Column(
            children: [
              Expanded(
                child: messages.isEmpty
                    ? const Center(child: Text('Начните ваше общение здесь!'))
                    : ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return FutureBuilder<Profile>(
                      future: _fetchProfile(message.profileId),
                      builder: (context, profileSnapshot) {
                        return _ChatBubble(
                          message: message,
                          profile: profileSnapshot.data,
                        );
                      },
                    );
                  },
                ),
              ),
              const _MessageBar(),
            ],
          );
        },
      ),
    );
  }
}

class _MessageBar extends StatefulWidget {
  const _MessageBar({Key? key}) : super(key: key);

  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  final TextEditingController _textController = TextEditingController();

  void _submitMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    final myUserId = supabase.auth.currentUser!.id;

    try {
      await supabase.from('messages').insert({
        'profile_id': myUserId,
        'content': text,
      });
    } catch (error) {
      // Обработка ошибок
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "Введите сообщение...",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 25,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _submitMessage,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
    required this.profile,
  }) : super(key: key);

  final Messages message;
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    final bool isMine = message.isMine;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMine)
            CircleAvatar(
              child: profile == null
                  ? preloader
                  : Text(profile!.username.substring(0, 2)),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: isMine ? const Color(0xffe5f4ff) : const Color(0xfff7f7f9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message.content,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(format(message.createdAt, locale: 'en_short')),
        ],
      ),
    );
  }
}
