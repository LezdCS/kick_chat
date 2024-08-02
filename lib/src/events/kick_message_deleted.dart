import 'dart:convert';

import 'package:kick_chat/src/kick_event.dart';

class KickMessageDeleted extends KickEvent {
  final Data data;

  KickMessageDeleted({
    required super.event,
    required this.data,
    required super.channel,
  });

  factory KickMessageDeleted.fromJson(Map<String, dynamic> map) {
    return KickMessageDeleted(
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
  final String id;
  final Message message;

  Data({
    required this.id,
    required this.message,
  });

  factory Data.fromJson(Map<String, dynamic> map) {
    return Data(
      id: map['id'],
      message: Message.fromJson(map['message']),
    );
  }

  @override
  String toString() {
    return 'id: $id, message: $message';
  }
}

class Message {
  final String id;

  Message({
    required this.id,
  });

  factory Message.fromJson(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
    );
  }
}
