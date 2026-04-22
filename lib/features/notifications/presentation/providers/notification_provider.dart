import 'package:flutter/material.dart';
import '../../data/models/notification_item.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Accident status updated',
      message: 'Officer assigned to your case #CR-2024-001',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Report submitted successfully',
      message: 'Your accident report has been received and is under review.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Insurance claim update',
      message: 'Your insurance provider has been notified of the incident.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'QR session joined',
      message: 'The other driver joined your accident report session.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'Report completed',
      message: 'Case #CR-2024-000 has been marked as completed.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications = List.of(_notifications);
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications = _notifications.where((n) => n.id != id).toList();
    notifyListeners();
  }
}
