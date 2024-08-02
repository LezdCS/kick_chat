import 'dart:convert';

import 'package:kick_chat/src/kick_event.dart';

class KickUserBanned extends KickEvent {
  final Data data;

  KickUserBanned({
    required super.event,
    required this.data,
    required super.channel,
  });

  factory KickUserBanned.fromJson(Map<String, dynamic> map) {
    return KickUserBanned(
      event: TypeEvent.userBannedEvent,
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
  final User user;
  final User bannedBy;
  final String? expiresAt;

  Data({
    required this.id,
    required this.user,
    required this.bannedBy,
    required this.expiresAt,
  });

  factory Data.fromJson(Map<String, dynamic> map) {
    return Data(
      id: map['id'],
      user: User.fromJson(map['user']),
      bannedBy: User.fromJson(map['banned_by']),
      expiresAt: map['expires_at'],
    );
  }

  @override
  String toString() {
    return 'id: $id, user: $user, bannedBy: $bannedBy';
  }
}

class User {
  final int id;
  final String username;
  final String slug;

  User({
    required this.id,
    required this.username,
    required this.slug,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      slug: map['slug'],
    );
  }
}