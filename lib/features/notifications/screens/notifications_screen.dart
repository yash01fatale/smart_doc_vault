import 'package:flutter/material.dart';
import 'notification_detail_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController =
      ScrollController();

  List<Map<String, dynamic>> notifications = [
    {
      "title": "GST Certificate Expiring",
      "message":
          "Your GST certificate will expire in 15 days. Please renew to avoid penalties.",
      "date": DateTime.now()
          .subtract(const Duration(hours: 2)),
      "isRead": false,
      "type": "expiry",
    },
    {
      "title": "PAN Uploaded",
      "message":
          "PAN Card uploaded successfully.",
      "date": DateTime.now()
          .subtract(const Duration(days: 1)),
      "isRead": true,
      "type": "upload",
    },
    {
      "title": "AI Suggestion",
      "message":
          "Renew your Trade License soon.",
      "date": DateTime.now()
          .subtract(const Duration(days: 3)),
      "isRead": false,
      "type": "ai",
    },
  ];

  int get unreadCount =>
      notifications
          .where((n) =>
              n["isRead"] == false)
          .length;

  void _markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n["isRead"] = true;
      }
    });
  }

  String _groupTitle(DateTime date) {
    final now = DateTime.now();
    final diff =
        now.difference(date).inDays;

    if (diff == 0) return "Today";
    if (diff == 1) return "Yesterday";
    return "Earlier";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    notifications.sort(
        (a, b) =>
            b["date"].compareTo(
                a["date"]));

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration:
              const BoxDecoration(
            gradient:
                LinearGradient(
              colors: [
                Color(0xFF4A00E0),
                Color(0xFF8E2DE2)
              ],
            ),
          ),
        ),
        title: Row(
          children: [
            const Text(
              "Notifications",
              style: TextStyle(
                  fontWeight:
                      FontWeight.bold),
            ),
            const SizedBox(width: 8),
            if (unreadCount > 0)
              Container(
                padding:
                    const EdgeInsets
                        .symmetric(
                            horizontal: 8,
                            vertical: 2),
                decoration:
                    BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius
                          .circular(12),
                ),
                child: Text(
                  unreadCount
                      .toString(),
                  style:
                      const TextStyle(
                    color: Color(
                        0xFF4A00E0),
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed:
                  _markAllAsRead,
              child:
                  const Text(
                "Mark all",
                style:
                    TextStyle(
                  color:
                      Colors.white,
                ),
              ),
            ),
        ],
      ),

      body: ListView.builder(
        key: const PageStorageKey(
            "notifications_list"),
        controller:
            _scrollController,
        padding:
            const EdgeInsets.all(16),
        itemCount:
            notifications.length,
        itemBuilder:
            (context, index) {

          final notif =
              notifications[index];

          final group =
              _groupTitle(
                  notif["date"]);

          final showHeader =
              index == 0 ||
                  _groupTitle(
                          notifications[index -
                                  1]["date"]) !=
                      group;

          return Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [

              if (showHeader)
                Padding(
                  padding:
                      const EdgeInsets
                          .symmetric(
                              vertical:
                                  10),
                  child: Text(
                    group,
                    style:
                        const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),
                ),

              Dismissible(
                key: Key(notif[
                            "title"] +
                        index
                            .toString()),
                direction:
                    DismissDirection
                        .endToStart,
                background:
                    Container(
                  alignment:
                      Alignment
                          .centerRight,
                  padding:
                      const EdgeInsets
                          .only(
                              right:
                                  20),
                  decoration:
                      BoxDecoration(
                    color:
                        Colors.red,
                    borderRadius:
                        BorderRadius
                            .circular(
                                20),
                  ),
                  child:
                      const Icon(
                    Icons.delete,
                    color:
                        Colors.white,
                  ),
                ),
                onDismissed:
                    (_) {
                  setState(() {
                    notifications
                        .removeAt(
                            index);
                  });
                },
                child:
                    _notificationCard(
                        notif),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _notificationCard(
      Map<String, dynamic>
          notif) {

    final bool isUnread =
        notif["isRead"] ==
            false;

    return GestureDetector(
      onTap: () {
        setState(() {
          notif["isRead"] =
              true;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                NotificationDetailScreen(
                    notification:
                        notif),
          ),
        );
      },
      child: Container(
        margin:
            const EdgeInsets.only(
                bottom: 14),
        padding:
            const EdgeInsets.all(
                16),
        decoration:
            BoxDecoration(
          color: isUnread
              ? const Color(
                  0xFFEDE9FE)
              : Colors.white,
          borderRadius:
              BorderRadius.circular(
                  20),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(
                      0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [

            const CircleAvatar(
              backgroundColor:
                  Color(
                      0xFFEDE9FE),
              child: Icon(
                Icons
                    .notifications,
                color: Color(
                    0xFF4A00E0),
              ),
            ),

            const SizedBox(
                width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    notif["title"],
                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),
                  const SizedBox(
                      height: 4),
                  Text(
                    notif["message"],
                    maxLines: 2,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        TextStyle(
                      color: Colors
                          .grey
                          .shade700,
                    ),
                  ),
                ],
              ),
            ),

            if (isUnread)
              const Icon(
                Icons.circle,
                size: 8,
                color: Color(
                    0xFF4A00E0),
              ),
          ],
        ),
      ),
    );
  }
}
