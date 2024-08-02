import 'dart:convert';

import 'package:kick_chat/kick_chat.dart';

class KickPinnedMessageCreated extends KickEvent {
  final Data data;

  KickPinnedMessageCreated({
    required super.event,
    required this.data,
    required super.channel,
  });

  factory KickPinnedMessageCreated.fromJson(Map<String, dynamic> map) {
    return KickPinnedMessageCreated(
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
  final Message message;
  final String duration;

  Data({
    required this.message,
    required this.duration,
  });

  factory Data.fromJson(Map<String, dynamic> map) {
    return Data(
      message: Message.fromJson(map['message']),
      duration: map['duration']
    );
  }

  @override
  String toString() {
    return 'message: $message, duration: $duration';
  }
}