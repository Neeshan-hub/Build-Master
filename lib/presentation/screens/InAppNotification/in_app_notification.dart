import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static const Color primaryColor = Color(0xFF262262);

  Future<void> _confirmMarkAllAsRead(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark All as Read'),
        content: const Text(
            'Are you sure you want to mark all notifications as read?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('Mark All', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      try {
        final querySnapshot =
            await FirebaseFirestore.instance.collection('notifications').get();

        final batch = FirebaseFirestore.instance.batch();
        for (final doc in querySnapshot.docs) {
          batch.update(doc.reference, {'isRead': true});
        }

        await batch.commit();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notifications marked as read')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _confirmDeleteAllNotifications(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Notifications'),
        content: const Text(
            'Are you sure you want to delete all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('Delete All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      final notifications =
          await FirebaseFirestore.instance.collection('notifications').get();

      final batch = FirebaseFirestore.instance.batch();
      for (final doc in notifications.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All notifications deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
            onPressed: () => _confirmMarkAllAsRead(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Delete all notifications',
            onPressed: () => _confirmDeleteAllNotifications(context),
          ),
        ],
      ),
      body: NotificationList(),
    );
  }
}

class NotificationList extends StatelessWidget {
  NotificationList({super.key});

  final user = FirebaseAuth.instance.currentUser;
  late final Stream<QuerySnapshot> _notificationsStream = FirebaseFirestore.instance
      .collection('notifications')
      .where('recipients', arrayContains: user?.uid ?? '') // Filter by current user ID
      .orderBy('timestamp', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _notificationsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        return _buildNotificationList(snapshot.data!.docs, context);
      },
    );
  }

  Widget _buildNotificationList(
      List<QueryDocumentSnapshot> notifications, BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final doc = notifications[index];
        final notification = doc.data() as Map<String, dynamic>;
        final isRead = notification['isRead'] ?? false;

        return Dismissible(
          key: Key(doc.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Notification'),
                content: const Text(
                    'Are you sure you want to delete this notification?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            FirebaseFirestore.instance
                .collection('notifications')
                .doc(doc.id)
                .delete();
          },
          child: NotificationCard(
            documentId: doc.id,
            action: notification['action'] as String? ?? 'Unknown Action',
            details: notification['details'] as String? ?? 'No details',
            userName: notification['userName'] as String? ?? 'Unknown User',
            timestamp: (notification['timestamp'] as Timestamp?)?.toDate(),
            isRead: isRead,
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error) {
    print(error);
    return Center(
      child: Text(
        'Error: $error',
        style: const TextStyle(color: Colors.red, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No notifications found',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String documentId;
  final String action;
  final String details;
  final String userName;
  final DateTime? timestamp;
  final bool isRead;

  const NotificationCard({
    required this.documentId,
    required this.action,
    required this.details,
    required this.userName,
    required this.isRead,
    this.timestamp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isRead
              ? Colors.transparent
              : NotificationsPage.primaryColor.withOpacity(0.8),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context),
            const SizedBox(height: 12),
            _buildDetailsSection(context),
            const SizedBox(height: 12),
            _buildFooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          color: isRead ? Colors.green : Colors.grey.shade400,
          size: 28,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                action,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isRead ? Colors.grey.shade600 : Colors.black87,
                ),
              ),
              Text(
                'by $userName',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _confirmDelete(context),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 14,
      color: Colors.grey.shade800,
      height: 1.4,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(text: details, style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: 3,
          textDirection: Directionality.of(context),
        );
        textPainter.layout(maxWidth: constraints.maxWidth);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              details,
              style: textStyle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (textPainter.didExceedMaxLines)
              TextButton(
                onPressed: () => _showFullDetails(context),
                child: Text(
                  'Read More',
                  style: TextStyle(
                    color: NotificationsPage.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFooterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          timestamp != null ? timeago.format(timestamp!) : 'Unknown time',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        if (timestamp != null)
          Text(
            DateFormat('MMM d, yyyy').format(timestamp!),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notification'),
        content:
            const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete ?? false) {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(documentId)
          .delete();
    }
  }

  void _showFullDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(action),
        content: SingleChildScrollView(
          child: Text(details),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
