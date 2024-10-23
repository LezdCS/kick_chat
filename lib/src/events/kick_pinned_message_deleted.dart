import 'package:kick_chat/kick_chat.dart';

class KickPinnedMessageDeleted extends KickEvent {
  final String data;

  KickPinnedMessageDeleted({
    required super.event,
    required this.data,
    required super.channel,
  });

  factory KickPinnedMessageDeleted.fromJson(Map<String, dynamic> map) {
    return KickPinnedMessageDeleted(
      event: TypeEvent.pinnedMessageDeletedEvent,
      data: map['data'],
      channel: map['channel'],
    );
  }

  @override
  String toString() {
    return 'event: $event, data: $data, channel: $channel';
  }
}