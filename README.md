# kick_chat
💬 Flutter Package for Kick Chat

## Usage

Initialize the chat 

```dart
KickChat kickChat = KickChat(
  kc.channel,
  onDone: () => {},
  onError: () => {},
);
```

Connect to the chat
```dart
kickChat.connect();
```

Listen to new chat events
```dart
kickChat.chatStream.listen((message) {
  final KickEvent? kickEvent = eventParser(message);
  if (kickEvent?.event == TypeEvent.message) {
    // your code
  }
})
```