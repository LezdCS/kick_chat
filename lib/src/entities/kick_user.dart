import 'package:kick_chat/src/entities/kick_badge.dart';

class KickUser {
  final int id;
  final int userId;
  final String slug;
  final int followersCount;
  final List<KickBadge> subBadges;
  final ChatRoom chatRoom;

  KickUser({
    required this.id,
    required this.userId,
    required this.slug,
    required this.followersCount,
    required this.subBadges,
    required this.chatRoom,
  });

  factory KickUser.fromJson(Map<String, dynamic> map) {
    List<KickBadge> subBadges = [];
    for(Map<String, dynamic> kickBadge in map['subscriber_badges']) {
      subBadges.add(KickBadge.fromJson(kickBadge));
    }
    return KickUser(
      id: map['id'],
      userId: map['user_id'],
      slug: map['slug'],
      followersCount: map['followers_count'],
      subBadges: subBadges,
      chatRoom: ChatRoom.fromJson(map['chatroom'])
    );
  }

  @override
  String toString() {
    return 'id: $id, userId: $userId, slug: $slug, followersCount: $followersCount, subBadges: $subBadges, chatRoom: $chatRoom';
  }
}

class ChatRoom {
  final int id;

  ChatRoom({
    required this.id,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'],
    );
  }
}
