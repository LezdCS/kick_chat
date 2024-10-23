import 'dart:async';
import 'dart:io';

import 'package:api_7tv/api_7tv.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/foundation.dart';
import 'package:kick_chat/kick_chat.dart';
import 'package:kick_chat/src/events/kick_pinned_message_deleted.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef MessageDeletedCallback = void Function(String);
typedef ChatroomClearCallback = void Function(String);
typedef MessagePinnedCallback = void Function(KickPinnedMessageCreated);
typedef MessageUnpinnedCallback = void Function(KickPinnedMessageDeleted);

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
  Stream<KickEvent> get chatStream => _chatStreamController.stream.where((event) => event is KickEvent).cast<KickEvent>();

  final MessageDeletedCallback? onDeletedMessageByUserId;
  final MessageDeletedCallback? onDeletedMessageByMessageId;
  final ChatroomClearCallback? onChatroomClear;
  final MessagePinnedCallback? onMessagePinned;
  final MessageUnpinnedCallback? onMessageUnpinned;

  KickChat(
    this.username,
    this.pushKey, {
    this.onDone,
    this.onError,
    this.onDeletedMessageByUserId,
    this.onDeletedMessageByMessageId,
    this.onChatroomClear,
    this.onMessagePinned,
    this.onMessageUnpinned,
  });

  set onDeletedMessageByUserId(
    MessageDeletedCallback? onDeletedMessageByUserId,
  ) {
    this.onDeletedMessageByUserId = onDeletedMessageByUserId;
  }

  set onDeletedMessageByMessageId(
    MessageDeletedCallback? onDeletedMessageByMessageId,
  ) {
    this.onDeletedMessageByMessageId = onDeletedMessageByMessageId;
  }

  set onChatroomClear(
    ChatroomClearCallback? onChatroomClear,
  ) {
    this.onChatroomClear = onChatroomClear;
  }

  set onMessagePinned(
    MessagePinnedCallback? onMessagePinned,
  ) {
    this.onMessagePinned = onMessagePinned;
  }

  set onMessageUnpinned(
    MessageUnpinnedCallback? onMessageUnpinned,
  ) {
    this.onMessageUnpinned = onMessageUnpinned;
  }

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
    final KickEvent? kickEvent = eventParser(message);
    if (kickEvent == null) {
      return;
    }
    switch (kickEvent.event) {
      case TypeEvent.message:
        _chatStreamController.add(kickEvent as KickMessage);
        break;
      case TypeEvent.followersUpdated:
        // TODO: TBD
        break;
      case TypeEvent.streamHostEvent:
        _chatStreamController.add(kickEvent as KickStreamHost);
        break;
      case TypeEvent.subscriptionEvent:
        _chatStreamController.add(kickEvent as KickSubscription);
        break;
      case TypeEvent.chatroomUpdatedEvent:
        // TODO: TBD
        break;
      case TypeEvent.userBannedEvent:
        KickUserBanned event = kickEvent as KickUserBanned;
        if (onDeletedMessageByUserId != null) {
          onDeletedMessageByUserId!(event.data.user.id.toString());
        }
        break;
      case TypeEvent.chatroomClearEvent:
        // KickChatroomClear event = kickEvent as KickChatroomClear;
        onChatroomClear!(kickEvent.channel);
        break;
      case TypeEvent.giftedSubscriptionsEvent:
        _chatStreamController.add(message as KickGiftedSubscriptions);
        break;
      case TypeEvent.pinnedMessageCreatedEvent:
        if(onMessagePinned != null) {
          onMessagePinned!(kickEvent as KickPinnedMessageCreated);
        }
        break;
      case TypeEvent.pinnedMessageDeletedEvent:
        if(onMessageUnpinned != null) {
          onMessageUnpinned!(kickEvent as KickPinnedMessageDeleted);
        }
        break;
      case TypeEvent.pollUpdateEvent:
        // TODO
        break;
      case TypeEvent.messageDeletedEvent:
        KickMessageDeleted event = kickEvent as KickMessageDeleted;
        if (onDeletedMessageByMessageId != null) {
          onDeletedMessageByMessageId!(event.data.message.id);
        }
        break;
    }
  }
}
