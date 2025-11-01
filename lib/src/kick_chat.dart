import 'dart:async';

import 'package:api_7tv/api_7tv.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:kick_chat/kick_chat.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef MessageDeletedCallback = void Function(String);
typedef ChatroomClearCallback = void Function(String);
typedef MessagePinnedCallback = void Function(KickPinnedMessageCreated);
typedef MessageUnpinnedCallback = void Function(KickPinnedMessageDeleted);

class KickChat {
  static final Logger _logger = Logger('KickChat');

  String username;
  String pushKey;

  WebSocketChannel? _webSocketChannel;
  StreamSubscription? _streamSubscription;

  KickUser? userDetails;
  List seventvEmotes = [];

  Function()? onDone;
  final Function? onError;

  final StreamController _chatStreamController = StreamController.broadcast();
  Stream<KickEvent> get chatStream => _chatStreamController.stream
      .where((event) => event is KickEvent)
      .cast<KickEvent>();

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

  static bool _handlerConfigured = false;

  /// Configures the logging level for the KickChat library.
  /// Users of this library can call this method to set their preferred logging level.
  /// This method automatically enables hierarchical logging if needed and sets up
  /// a default console output handler if one hasn't been configured.
  /// 
  /// To customize log output, configure Logger.root.onRecord before calling this method.
  /// 
  /// Example:
  /// ```dart
  /// KickChat.configureLogging(Level.WARNING);
  /// ```
  static void configureLogging(Level level, {bool setupConsoleOutput = true}) {
    // Enable hierarchical logging to allow setting levels on non-root loggers
    hierarchicalLoggingEnabled = true;
    
    // Set up a default console output handler if requested and not already configured
    if (setupConsoleOutput && !_handlerConfigured) {
      Logger.root.onRecord.listen((record) {
        final level = record.level.name.padRight(7);
        final logger = record.loggerName;
        final message = record.message;
        final error = record.error;
        final stackTrace = record.stackTrace;
        
        debugPrint('[KickChat] [$level] $logger: $message');
        if (error != null) {
          debugPrint('[KickChat] Error: $error');
        }
        if (stackTrace != null) {
          debugPrint('[KickChat] StackTrace: $stackTrace');
        }
      });
      _handlerConfigured = true;
    }
    
    // Set the root logger level and our specific logger level
    Logger.root.level = level;
    _logger.level = level;
  }

  static Future init() async {}

  Future<void> connect() async {
    _logger.info('Connecting to Kick chat for user: $username');
    userDetails = await KickApi.getUserDetails(username);
    if (userDetails == null) {
      _logger.severe('Failed to get user details for username: $username');
      return;
    }

    _logger.info('Successfully retrieved user details. User ID: ${userDetails!.userId}');

    // get channel 7tv emotes
    try {
      List result =
          await SeventvApi.getKickChannelEmotes(userDetails!.userId.toString()) ??
              [];
      seventvEmotes.addAll(result);
      _logger.fine('Loaded ${result.length} 7TV emotes for channel');
    } catch (e, stackTrace) {
      _logger.warning('Failed to load 7TV emotes', e, stackTrace);
    }

    Uri url = Uri.parse(
      "wss://ws-us2.pusher.com/app/$pushKey?protocol=7&client=js&version=7.6.0&flash=false",
    );
    
    try {
      _webSocketChannel = WebSocketChannel.connect(
        url,
      );
      _logger.info('WebSocket connection established');

      _webSocketChannel?.sink.add(
        '{"event":"pusher:subscribe","data":{"auth":"","channel":"channel.${userDetails!.id}"}}',
      );
      _webSocketChannel?.sink.add(
        '{"event":"pusher:subscribe","data":{"auth":"","channel":"chatrooms.${userDetails!.chatRoom.id}.v2"}}',
      );
      _logger.fine('Subscribed to Pusher channels');

      _streamSubscription = _webSocketChannel?.stream.listen(
        (data) => _chatListener(data),
        onDone: _onDone,
        onError: _onError,
      );
      _logger.info('Chat connection established successfully');
    } catch (e, stackTrace) {
      _logger.severe('Failed to establish WebSocket connection', e, stackTrace);
      rethrow;
    }
  }

  Future<void> close() async {
    _logger.info('Closing Kick chat connection');
    await _webSocketChannel?.sink.close();
    await _streamSubscription?.cancel();
    _logger.fine('Connection closed');
  }

  Future<void> _onDone() async {
    final closeReason = _webSocketChannel?.closeReason;
    final closeCode = _webSocketChannel?.closeCode;
    
    _logger.info('WebSocket connection closed. Code: $closeCode, Reason: $closeReason');

    await close();
    if (onDone != null) {
      onDone!();
    }
  }

  void _onError(Object o, StackTrace s) {
    _logger.severe('WebSocket error occurred', o, s);
    if (onError != null) {
      onError!();
    }
  }

  void _chatListener(String message) {
    try {
      final KickEvent? kickEvent = eventParser(message);
      if (kickEvent == null) {
        _logger.finest('Received unhandled event type or null event');
        return;
      }
      
      _logger.fine('Received event: ${kickEvent.event}');
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
        _chatStreamController.add(kickEvent as KickGiftedSubscriptions);
        break;
      case TypeEvent.pinnedMessageCreatedEvent:
        if (onMessagePinned != null) {
          onMessagePinned!(kickEvent as KickPinnedMessageCreated);
        }
        break;
      case TypeEvent.pinnedMessageDeletedEvent:
        if (onMessageUnpinned != null) {
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
    } catch (e, stackTrace) {
      _logger.severe('Error processing chat message', e, stackTrace);
    }
  }
}
