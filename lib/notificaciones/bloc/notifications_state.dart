part of 'notifications_bloc.dart';

class NotificationsState {
  final AuthorizationStatus status;
  final List<dynamic> notifications;

  NotificationsState({
    this.status = AuthorizationStatus.notDetermined, 
    this.notifications = const[]
  }); 

  NotificationsState copyWith({
    AuthorizationStatus? status,
    List<dynamic>? notifications
  }) => NotificationsState(
    notifications: notifications ?? this.notifications,
    status: status ?? this.status
  );
  
  List<Object> get props => [status, notifications];
}

