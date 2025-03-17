import 'dart:async';

import 'package:deeplink3/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart';

import 'Chat.dart';
import 'constants.dart';
import 'main.dart';
import 'message.dart';

/// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const ChatPage(),
    );
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final Stream<List<Messages>> _messagesStream;
  final Map<String, Profile> _profileCache = {};

  @override
  void initState() {
    final myUserId = supabase.auth.currentUser!.id;
    _messagesStream = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((maps) => maps
        .map((map) => Messages.fromMap(map: map, myUserId: myUserId))
        .toList());
    super.initState();
  }

  Future<void> _loadProfileCache(String profileId) async {
    if (_profileCache[profileId] != null) {
      return;
    }
    final data =
    await supabase.from('profiles').select().eq('id', profileId).single();
    final profile = Profile.fromMap(data);
    setState(() {
      _profileCache[profileId] = profile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,title: const Text('Чаты')),
      body: StreamBuilder<List<Messages>>(
        stream: _messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                    child: Text('Начните ваше общение здесь!'),
                  )
                      : ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      /// I know it's not good to include code that is not related
                      /// to rendering the widget inside build method, but for
                      /// creating an app quick and dirty, it's fine 😂
                      _loadProfileCache(message.profileId);

                      return _ChatBubble(
                        message: message,
                        profile: _profileCache[message.profileId],
                      );
                    },
                  ),
                ),
                const _MessageBar(),
              ],
            );
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends StatefulWidget {
  const _MessageBar({
    Key? key,
  }) : super(key: key);
  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  late final TextEditingController _textController;

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
                hintText: "Type your message",
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
                onPressed: () => _submitMessage()
            ),
          ),
        ],
      ),
    );
    //   Material(
    //   color:CustomTheme.lightTheme.secondaryHeaderColor /*Colors.grey[200]*/,
    //   child: SafeArea(
    //     child: Padding(
    //       padding: const EdgeInsets.all(10.0),
    //       child: Row(
    //         children: [
    //           Expanded(
    //             child: TextFormField(
    //               keyboardType: TextInputType.text,
    //               maxLines: null,
    //               autofocus: true,
    //               controller: _textController,
    //               decoration: const InputDecoration(
    //                 hintText: 'Напишите сообщение',
    //                 border: InputBorder.none,
    //                 focusedBorder: InputBorder.none,
    //                 contentPadding: EdgeInsets.all(8),
    //               ),
    //             ),
    //           ),
    //           IconButton(onPressed:()=>_submitMessage() , icon: SvgPicture.asset('assets/icons/send.svg',color: const Color(0xff2382ff)/*CustomTheme.lightTheme.primaryColor,*/))
    //           // TextButton(
    //           //   onPressed: () => _submitMessage(),
    //           //   child:  Text('Send',style: TextStyle(color: CustomTheme.lightTheme.primaryColor),),
    //           // ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  void _submitMessage() async {
    final text = _textController.text;
    final myUserId = supabase.auth.currentUser!.id;
    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    try {
      await supabase.from('messages').insert({
        'profile_id': myUserId,
        'content': text,
      });
    } on PostgrestException catch (error) {
      //context.showErrorSnackBar(message: error.message);
    } catch (_) {
     // context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
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
    List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
          child: profile == null
              ? preloader
              : Text(profile!.username.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: message.isMine
                ? const Color(0xffe5f4ff)

                // ? const Color(0xff2D435D)
                : const Color(0xfff7f7f9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
              message.content,
            style: TextStyle(
              color: Theme.of(context).primaryColor, /*message.isMine
                  ? Colors.white
                  : Theme.of(context).primaryColor,*/
              fontSize: 20,
              fontWeight: FontWeight.w400
            ),

          ),
        ),
      ),
      const SizedBox(width: 12),
      Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
        message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
