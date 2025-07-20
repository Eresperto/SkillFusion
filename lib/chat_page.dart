import 'dart:async';
import 'dart:collection';

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
  late final StreamSubscription<List<Map<String, dynamic>>> _messagesSubscription;
  final List<Messages> _messages = [];
  final Map<String, Profile> _profileCache = {};
  final Set<String> _loadingProfiles = HashSet<String>();
  bool _isLoading = true;
  bool _hasMore = true;
  String? _lastTimestamp;
  static const int _messageLimit = 20;

  @override
  void initState() {
    super.initState();
    _initializeMessages();
    _setupMessagesSubscription();
  }

  @override
  void dispose() {
    _messagesSubscription.cancel();
    super.dispose();
  }

  // Загрузка начальных сообщений с пагинацией
  Future<void> _initializeMessages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final myUserId = supabase.auth.currentUser!.id;
      
      final response = await supabase
          .from('messages')
          .select()
          .order('created_at', ascending: false)
          .limit(_messageLimit);
      
      final List<Messages> messages = response
          .map((map) => Messages.fromMap(map: map, myUserId: myUserId))
          .toList();
      
      if (messages.isNotEmpty) {
        _lastTimestamp = messages.last.createdAt.toIso8601String();
      }
      
      setState(() {
        _messages.clear();
        _messages.addAll(messages);
        _isLoading = false;
        _hasMore = messages.length >= _messageLimit;
      });
      
      // Пакетная загрузка профилей пользователей
      await _batchLoadProfiles(messages);
      
    } catch (e) {
      debugPrint('Ошибка загрузки сообщений: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Создаём подписку на новые сообщения
  void _setupMessagesSubscription() {
    final myUserId = supabase.auth.currentUser!.id;
    
    _messagesSubscription = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at') // Сортировка по дате создания
        .listen((List<Map<String, dynamic>> data) {
          final newMessages = data
              .map((map) => Messages.fromMap(map: map, myUserId: myUserId))
              .toList();
          
          if (newMessages.isNotEmpty) {
            setState(() {
              // Добавляем только сообщения, которых ещё нет в списке
              for (final message in newMessages) {
                if (!_messages.any((m) => m.id == message.id)) {
                  _messages.insert(0, message); // Вставляем новые сообщения в начало списка
                }
              }
            });
            
            // Загружаем профили для новых сообщений
            _batchLoadProfiles(newMessages);
          }
        });
  }

  // Загрузка старых сообщений при прокрутке списка
  Future<void> _loadMoreMessages() async {
    if (!_hasMore || _isLoading || _lastTimestamp == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final myUserId = supabase.auth.currentUser!.id;
      
      final response = await supabase
          .from('messages')
          .select()
          .lt('created_at', _lastTimestamp!)
          .order('created_at', ascending: false)
          .limit(_messageLimit);
      
      final List<Messages> messages = response
          .map((map) => Messages.fromMap(map: map, myUserId: myUserId))
          .toList();
      
      if (messages.isNotEmpty) {
        _lastTimestamp = messages.last.createdAt.toIso8601String();
      }
      
      setState(() {
        _messages.addAll(messages);
        _isLoading = false;
        _hasMore = messages.length >= _messageLimit;
      });
      
      // Пакетная загрузка профилей
      await _batchLoadProfiles(messages);
      
    } catch (e) {
      debugPrint('Ошибка загрузки предыдущих сообщений: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Пакетная загрузка профилей
  Future<void> _batchLoadProfiles(List<Messages> messages) async {
    final Set<String> profileIds = messages
        .map((m) => m.profileId)
        .where((id) => !_profileCache.containsKey(id) && !_loadingProfiles.contains(id))
        .toSet();
    
    if (profileIds.isEmpty) return;
    
    // Отмечаем профили как загружаемые
    for (final id in profileIds) {
      _loadingProfiles.add(id);
    }
    
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .inFilter('id', profileIds.toList());
      
      final profiles = response.map((data) => Profile.fromMap(data)).toList();
      
      if (mounted) {
        setState(() {
          for (final profile in profiles) {
            _profileCache[profile.id] = profile;
            _loadingProfiles.remove(profile.id);
          }
        });
      }
    } catch (e) {
      debugPrint('Ошибка пакетной загрузки профилей: $e');
      // Удаляем ID из загружаемых, чтобы можно было повторить попытку
      for (final id in profileIds) {
        _loadingProfiles.remove(id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Чаты')
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty && !_isLoading
                ? const Center(
                    child: Text('Начните ваше общение здесь!'),
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && _hasMore) {
                        _loadMoreMessages();
                      }
                      return true;
                    },
                    child: ListView.builder(
                      reverse: true,
                      itemCount: _messages.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length) {
                          return _isLoading 
                              ? const Center(child: CircularProgressIndicator(color: Colors.cyan,))
                              : const SizedBox();
                        }
                        
                        final message = _messages[index];
                        return _ChatBubble(
                          message: message,
                          profile: _profileCache[message.profileId],
                        );
                      },
                    ),
                  ),
          ),
          const _MessageBar(),
        ],
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends StatefulWidget {
  const _MessageBar({Key? key}) : super(key: key);
  
  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  late final TextEditingController _textController;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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
                hintText: "Напишите сообщение",
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
            child: _isSending
                ? const CircularProgressIndicator(color: Colors.white)
                : IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _submitMessage,
                  ),
          ),
        ],
      ),
    );
  }

  void _submitMessage() async {
    final text = _textController.text;
    if (text.isEmpty || _isSending) {
      return;
    }
    
    final myUserId = supabase.auth.currentUser!.id;
    _textController.clear();
    
    setState(() {
      _isSending = true;
    });
    
    try {
      await supabase.from('messages').insert({
        'profile_id': myUserId,
        'content': text,
      });
    } on PostgrestException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${error.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Произошла неожиданная ошибка')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
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
    final List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
          child: profile == null
              ? const Text("Gu")
              : Text(profile!.username.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: message.isMine
              ? const Color(0xffe5f4ff)
              : const Color(0xfff7f7f9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w400
          ),
        ),
      ),
      const SizedBox(width: 12),
      Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 10),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: message.isMine ? chatContents.reversed.toList() : chatContents,
      ),
    );
  }
}
