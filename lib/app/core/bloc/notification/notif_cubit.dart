import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class NotificationCubit extends Cubit<List<NotificationItem>> {
  NotificationCubit() : super([]);

  void addNotification(NotificationItem notification) {
    final updatedNotifications = List<NotificationItem>.from(state)
      ..add(notification);
    emit(updatedNotifications);
  }
}

class NotificationItem extends Equatable {
  final String title;
  final String body;

  const NotificationItem({required this.title, required this.body});

  @override
  List<Object> get props => [title, body];
}
