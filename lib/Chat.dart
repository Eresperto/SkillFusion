// import 'package:deeplink3/Likes.dart';
// import 'package:deeplink3/NewSkill.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'dart:async';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import 'MySkills.dart';
//
// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final _controller = TextEditingController();
//   final List<Message> _messages = [];
//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }
//
//   Future<void> _fetchMessages() async {
//     final response = await Supabase.instance.client.from('messages')
//         .select().order('created_at').execute();
//     if (response.error == null) {
//       setState(() {
//         _messages.addAll(List<Message>.from(response.data.map((msg) => Message.fromJson(msg))));
//       });
//     }
//   }
//
//   void _subscribeToMessages() {
//     Supabase.instance.client
//         .from('messages')
//         .on(SupabaseEventTypes.insert, (payload) {
//       final newMessage = Message.fromJson(payload.newRecord);
//       setState(() {
//         _messages.insert(0, newMessage); // Добавляем новое сообщение в начало списка
//       });
//     })
//         .subscribe();
//   }
//
//   Future<void> _sendMessage() async {
//     if (_controller.text.isEmpty) return;
//
//     final response = await Supabase.instance.client.from('messages').insert({
//       'user_id': 'your_user_id', // Укажите идентификатор пользователя
//       'content': _controller.text,
//     })._execute();
//
//     if (response.error == null) {
//       _controller.clear();
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_messages[index].content),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(labelText: 'Enter your message...'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: /*_sendMessage*/(){},
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class Message {
//   final String userId;
//   final String content;
//   final DateTime createdAt;
//
//   Message({required this.userId, required this.content, required this.createdAt});
//
//   factory Message.fromJson(Map<String, dynamic> json) {
//     return Message(
//       userId: json['user_id'],
//       content: json['content'],
//       createdAt: DateTime.parse(json['created_at']),
//     );
//   }
// }
