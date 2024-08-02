import 'dart:convert';

import 'package:kick_chat/src/kick_event.dart';

class KickChatroomClear extends KickEvent {
  final Data data;

  KickChatroomClear({
    required super.event,
    required this.data,
    required super.channel,
  });

  factory KickChatroomClear.fromJson(Map<String, dynamic> map) {
    return KickChatroomClear(
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

  Data({
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> map) {
    return Data(
      id: map['id'],
    );
  }

  @override
  String toString() {
    return 'id: $id';
  }
}