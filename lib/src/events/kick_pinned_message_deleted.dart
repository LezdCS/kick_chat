import 'package:kick_chat/kick_chat.dart';

class KickPinnedMessageDeleted extends KickEvent {

  KickPinnedMessageDeleted({
    required super.event,
    required super.channel,
  });

  factory KickPinnedMessageDeleted.fromJson(Map<String, dynamic> map) {
    return KickPinnedMessageDeleted(
      event: TypeEvent.pinnedMessageDeletedEvent,
      channel: map['channel'],
    );
  }

  @override
  String toString() {
    return 'event: $event, channel: $channel';
  }
}