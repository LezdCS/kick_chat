import 'dart:convert';

import 'package:kick_chat/src/kick_event.dart';

class KickMessage extends KickEvent {
  final Message data;

  KickMessage({
    required super.event,
    required this.data,
    required super.channel,
  });

  factory KickMessage.fromJson(Map<String, dynamic> map) {
    return KickMessage(
      event: TypeEvent.message,
      data: Message.fromJson(jsonDecode(map['data'])),
      channel: map['channel'],
    );
  }

  @override
  String toString() {
    return 'event: $event, data: $data, channel: $channel';
  }
}

class Message {
  final String id;
  final int chatroomId;
  final String content;
  final String type;
  final String createdAt;
  final Sender sender;

  Message({
    required this.id,
    required this.chatroomId,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.sender,
  });

  factory Message.fromJson(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      chatroomId: map['chatroom_id'],
      content: map['content'],
      type: map['type'],
      createdAt: map['created_at'],
      sender: Sender.fromJson(map['sender']),
    );
  }

  @override
  String toString() {
    return 'id: $id, chatroomId: $chatroomId, content: $content, type: $type, createdAt: $createdAt, sender: $sender';
  }
}

class Sender {
  final int id;
  final String username;
  final String slug;
  final Identity identity;

  Sender({
    required this.id,
    required this.username,
    required this.slug,
    required this.identity,
  });

  factory Sender.fromJson(Map<String, dynamic> map) {
    return Sender(
      id: map['id'],
      username: map['username'],
      slug: map['slug'],
      identity: Identity.fromJson(map['identity']),
    );
  }

  @override
  String toString() {
    return 'id: $id, username: $username, slug: $slug, identity: $identity';
  }
}

class Identity {
  final String color;
  final List<UserBadge> badges;

  Identity({
    required this.color,
    required this.badges,
  });

  factory Identity.fromJson(Map<String, dynamic> map) {
    List<UserBadge> badges = [];
    for (var badge in map['badges']) {
      badges.add(UserBadge.fromJson(badge));
    }
    return Identity(
      color: map['color'],
      badges: badges,
    );
  }

  @override
  String toString() {
    return 'color: $color, badges: $badges';
  }
}

class UserBadge {
  final String type;
  final String text;
  final int count;

  UserBadge({
    required this.type,
    required this.text,
    required this.count,
  });

  factory UserBadge.fromJson(Map<String, dynamic> map) {
    return UserBadge(
      type: map['type'],
      text: map['text'],
      count: map['count'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'type: $type, text: $text, count: $count';
  }
}
