import 'dart:convert';

import 'package:kick_chat/src/kick_event.dart';

class KickChatroomUpdated extends KickEvent {
  final Data data;

  KickChatroomUpdated({
    required super.event,
    required this.data,
    required super.channel,
  });

  factory KickChatroomUpdated.fromJson(Map<String, dynamic> map) {
    return KickChatroomUpdated(
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
  final int id;
  final SlowMode slowMode;
  final SubscribersAndEmotesMode subscribersMode;
  final FollowersMode followersMode;
  final SubscribersAndEmotesMode emotesMode;
  final AdvancedBotProtection advancedBotProtection;

  Data({
    required this.id,
    required this.slowMode,
    required this.subscribersMode,
    required this.followersMode,
    required this.emotesMode,
    required this.advancedBotProtection,
  });

  factory Data.fromJson(Map<String, dynamic> map) {
    return Data(
      id: map['id'],
      slowMode: SlowMode.fromJson(map['slow_mode']),
      subscribersMode: SubscribersAndEmotesMode.fromJson(map['subscribers_mode']),
      followersMode: FollowersMode.fromJson(map['followers_mode']),
      emotesMode: SubscribersAndEmotesMode.fromJson(map['emotes_mode']),
      advancedBotProtection: AdvancedBotProtection.fromJson(map['advanced_bot_protection']),
    );
  }

  @override
  String toString() {
    return 'id: $id';
  }
}

class SlowMode {
  final bool enabled;
  final int messageInterval;

  SlowMode({
    required this.enabled,
    required this.messageInterval,
  });

  factory SlowMode.fromJson(Map<String, dynamic> map) {
    return SlowMode(
      enabled: map['enabled'],
      messageInterval: map['message_interval'],
    );
  }
}

class SubscribersAndEmotesMode {
  final bool enabled;

  SubscribersAndEmotesMode({
    required this.enabled,
  });

  factory SubscribersAndEmotesMode.fromJson(Map<String, dynamic> map) {
    return SubscribersAndEmotesMode(
      enabled: map['enabled'],
    );
  }
}

class FollowersMode {
  final bool enabled;
  final int minDuration;

  FollowersMode({
    required this.enabled,
    required this.minDuration,
  });

  factory FollowersMode.fromJson(Map<String, dynamic> map) {
    return FollowersMode(
      enabled: map['enabled'],
      minDuration: map['min_duration'],
    );
  }
}

class AdvancedBotProtection {
  final bool enabled;
  final int remainingTime;

  AdvancedBotProtection({
    required this.enabled,
    required this.remainingTime,
  });

  factory AdvancedBotProtection.fromJson(Map<String, dynamic> map) {
    return AdvancedBotProtection(
      enabled: map['enabled'],
      remainingTime: map['remaining_time'],
    );
  }
}