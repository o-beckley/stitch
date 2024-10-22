enum NotificationState{read, unread}

class StitchNotification{
  final String title;
  final String body;
  final NotificationState state;
  final DateTime timeStamp;

  StitchNotification({
    required this.title,
    required this.body,
    required this.state,
    required this.timeStamp,
  });

  static NotificationState _getNotificationState(String state){
    return switch (state){
      'read' => NotificationState.read,
      'unread' => NotificationState.unread,
      _ => NotificationState.unread,
    };
  }

  bool get isRead => state == NotificationState.read;

  static StitchNotification fromMap(Map<String, dynamic> data){
    return StitchNotification(
      title: data['title'],
      body: data['body'],
      state: _getNotificationState(data['state']),
      timeStamp: DateTime.parse(data['timeStamp'])
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'title': title,
      'body': body,
      'state': state.name,
      'timeStamp': timeStamp.toIso8601String(),
    };
  }
}