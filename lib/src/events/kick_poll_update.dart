import 'dart:convert';

import 'package:kick_chat/src/kick_event.dart';

class KickPollUpdate extends KickEvent {
  final Data data;

  KickPollUpdate({
    required super.event,
    required this.data,
    required super.channel,
  });

  factory KickPollUpdate.fromJson(Map<String, dynamic> map) {
    return KickPollUpdate(
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
  final Poll poll;

  Data({
    required this.poll,
  });

  factory Data.fromJson(Map<String, dynamic> map) {
    return Data(
      poll: Poll.fromJson(map['poll']),
    );
  }

  @override
  String toString() {
    return 'poll: $poll';
  }
}

class Poll {
  final String title;
  final List<Option> options;
  final int duration;
  final int remaining;
  final int resultDipslayDuration;

  Poll({
    required this.title,
    required this.options,
    required this.duration,
    required this.remaining,
    required this.resultDipslayDuration,
  });

  factory Poll.fromJson(Map<String, dynamic> map) {
    List<Option> options = [];
    for(dynamic option in map['options']) {
      options.add(Option.fromJson(option));
    }
    return Poll(
      title: map['title'],
      options: options,
      duration: map['duration'],
      remaining: map['remaining'],
      resultDipslayDuration: map['result_display_duration'],
    );
  }
}

class Option {
  final int id;
  final String label;
  final int votes;

  Option({
    required this.id,
    required this.label,
    required this.votes,
  });

  factory Option.fromJson(Map<String, dynamic> map) {
    return Option(
      id: map['id'],
      label: map['label'],
      votes: map['votes'],
    );
  }
}
