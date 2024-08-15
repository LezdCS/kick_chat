import 'dart:async';
import 'dart:io';

import 'package:api_7tv/api_7tv.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/foundation.dart';
import 'package:kick_chat/kick_chat.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class KickChat {
  String username;
  String pushKey;

  WebSocketChannel? _webSocketChannel;
  StreamSubscription? _streamSubscription;

  KickUser? userDetails;
  List seventvEmotes = [];

  Function()? onDone;
  final Function? onError;

  final StreamController _chatStreamController = StreamController.broadcast();
  Stream get chatStream => _chatStreamController.stream;

  KickChat(
    this.username,
    this.pushKey, {
    this.onDone,
    this.onError,
  });

  static Future init() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }
    await FkUserAgent.init();
  }

  Future<void> connect() async {
    userDetails = await KickApi.getUserDetails(username);
    if (userDetails == null) {
      return;
    }

    // get channel 7tv emotes
    List result =
        await SeventvApi.getKickChannelEmotes(userDetails!.userId.toString()) ??
            [];
    seventvEmotes.addAll(result);

    Uri url = Uri.parse(
      "wss://ws-us2.pusher.com/app/$pushKey?protocol=7&client=js&version=7.6.0&flash=false",
    );
    _webSocketChannel = WebSocketChannel.connect(
      url,
    );
    _webSocketChannel?.sink.add(
      '{"event":"pusher:subscribe","data":{"auth":"","channel":"channel.${userDetails!.id}"}}',
    );
    _webSocketChannel?.sink.add(
      '{"event":"pusher:subscribe","data":{"auth":"","channel":"chatrooms.${userDetails!.chatRoom.id}.v2"}}',
    );

    _streamSubscription = _webSocketChannel?.stream.listen(
      (data) => _chatListener(data),
      onDone: _onDone,
      onError: _onError,
    );
  }

  Future<void> close() async {
    await _webSocketChannel?.sink.close();
    await _streamSubscription?.cancel();
  }

  Future<void> _onDone() async {
    debugPrint(_webSocketChannel?.closeReason);
    debugPrint(_webSocketChannel?.closeCode.toString());

    debugPrint("Kick Chat: Connection closed");
    await close();
    if (onDone != null) {
      onDone!();
    }
  }

  void _onError(Object o, StackTrace s) {
    debugPrint(o.toString());
    debugPrint(s.toString());
    if (onError != null) {
      onError!();
    }
  }

  void _chatListener(String message) {
    _chatStreamController.add(message);
  }
}
