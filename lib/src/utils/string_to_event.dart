import 'package:kick_chat/kick_chat.dart';

TypeEvent? stringToEvent(String s) {
  switch (s) {
    case 'App\\Events\\FollowersUpdated':
      return TypeEvent.followersUpdated;
    case 'App\\Events\\ChatMessageEvent':
      return TypeEvent.message;
    case 'App\\Events\\SubscriptionEvent':
      return TypeEvent.subscriptionEvent;
    case 'App\\Events\\ChatroomUpdatedEvent':
      return TypeEvent.chatroomUpdatedEvent;
    case 'App\\Events\\StreamHostEvent':
      return TypeEvent.streamHostEvent;
    case 'App\\Events\\UserBannedEvent':
      return TypeEvent.userBannedEvent;
    case 'App\\Events\\ChatroomClearEvent':
      return TypeEvent.chatroomClearEvent;
    case 'App\\Events\\GiftedSubscriptionsEvent':
      return TypeEvent.giftedSubscriptionsEvent;
    case 'App\\Events\\PinnedMessageCreatedEvent':
      return TypeEvent.pinnedMessageCreatedEvent;
    case 'App\\Events\\PollUpdateEvent':
      return TypeEvent.pollUpdateEvent;
    case 'App\\Events\\MessageDeletedEvent':
      return TypeEvent.messageDeletedEvent;
    default:
      return null;
  }
}
