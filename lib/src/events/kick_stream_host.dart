import 'dart:convert';

import 'package:kick_chat/src/kick_event.dart';

class KickStreamHost extends KickEvent {
  final Data data;

  KickStreamHost({
    required super.event,
    required this.data,
    required super.channel,
  });

  factory KickStreamHost.fromJson(Map<String, dynamic> map) {
    return KickStreamHost(
      event: TypeEvent.followersUpdated,
      data: Data.fromJson(jsonDecode(map['data'])),
      channel: map['channel'],
    );
  }

  @override
  String toString() {
    return 'event: $event, data: $data, channel: $channel';
  }
}

class Data {
  final int chatroomId;
  final String optionalMessage;
  final int numberViewers;
  final String hostUsername;

  Data({
    required this.chatroomId,
    required this.optionalMessage,
    required this.numberViewers,
    required this.hostUsername,
  });

  factory Data.fromJson(Map<String, dynamic> map) {
    return Data(
      chatroomId: map['chatroom_id'],
      optionalMessage: map['optional_message'],
      numberViewers: map['number_viewers'],
      hostUsername: map['host_username'],
    );
  }

  @override
  String toString() {
    return 'chatroomId: $chatroomId, optionalMessage: $optionalMessage, numberViewers: $numberViewers, hostUsername: $hostUsername';
  }
}