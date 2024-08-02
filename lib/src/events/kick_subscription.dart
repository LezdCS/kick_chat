import 'dart:convert';

import 'package:kick_chat/src/kick_event.dart';

class KickSubscription extends KickEvent {
  final Data data;

  KickSubscription({
    required super.event,
    required this.data,
    required super.channel,
  });

  factory KickSubscription.fromJson(Map<String, dynamic> map) {
    return KickSubscription(
      event: TypeEvent.subscriptionEvent,
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
  final int months;
  final String username;

  Data({
    required this.months,
    required this.username,
  });

  factory Data.fromJson(Map<String, dynamic> map) {
    return Data(
      months: map['months'],
      username: map['username'],
    );
  }

  @override
  String toString() {
    return 'months: $months, username: $username';
  }
}