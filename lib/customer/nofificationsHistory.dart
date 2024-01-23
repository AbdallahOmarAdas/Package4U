import 'dart:convert';
import 'package:Package4U/Models/Notification.dart';
import 'package:Package4U/customer/track_package.dart';
import 'package:Package4U/style/common/theme_h.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class NotificationHistory extends StatefulWidget {
  final int newNotificationCount;
  const NotificationHistory({super.key, required this.newNotificationCount});

  @override
  State<NotificationHistory> createState() => _NotificationHistoryState();
}

class _NotificationHistoryState extends State<NotificationHistory> {
  late DateTime time = DateTime.now();
  bool isLoding = true;
  @override
  void initState() {
    super.initState();
    GetStorage().write("notificationCount", widget.newNotificationCount);
    time = DateTime.now();
    fetchData();
  }

  dynamic statusIcon = {
    "Under review": "assets/underReview.png",
    "Accepted": "assets/accepted.png",
    "Wait Driver": "assets/Wait_Driver.png",
    "In Warehouse": "assets/Warehouse.png",
    "Complete Receive": "assets/Warehouse.png",
    "With Driver": "assets/With_Driver.png",
    "Delivered": "assets/delivered.png",
    "Rejected": "assets/Rejected.png",
  };

  Future<void> fetchData() async {
    var url = urlStarter +
        "/customer/getMyNotifications?customerUserName=" +
        GetStorage().read("userName");
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      data = data['Notifications'];
      setState(() {
        notificationsList = (data as List)
            .map((data) => CustomerNotification.fromJson(data))
            .toList();
        notificationsList
            .sort((a, b) => b.Date.toString().compareTo(a.Date.toString()));
        if (!(notificationsList.length > 0 &&
            isSameTodayDay(notificationsList[0].Date))) {
          printedEarlier = true;
        }
        isLoding = false;
      });
    } else if (response.statusCode == 404) {
      setState(() {
        isLoding = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<CustomerNotification> notificationsList = [];
  bool printedEarlier = false;
  bool printedToday = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Packages Notifications"),
        backgroundColor: primarycolor,
      ),
      body: isLoding
          ? Center(
              child: CircularProgressIndicator(),
            )
          : notificationsList.length == 0
              ? Center(
                  child: Text(
                  "You don't have any notifications",
                  style: TextStyle(
                      color: primarycolor,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ))
              : SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        notificationsList.length > 0 &&
                                isSameTodayDay(notificationsList[0].Date)
                            ? Container(
                                padding: EdgeInsets.only(left: 5, top: 10),
                                child: Text('Today', style: TodayErlierStyle()),
                              )
                            //  : Container(),
                            : Container(
                                padding: EdgeInsets.only(left: 5, top: 10),
                                child: Text(
                                  'Earlier',
                                  style: TodayErlierStyle(),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                        notificationsList.length == 0
                            ? Container()
                            : ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: notificationsList.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  final current = notificationsList[index].Date;
                                  final previous =
                                      index + 1 <= notificationsList.length
                                          ? notificationsList[index + 1].Date
                                          : current;

                                  if (isSameDay(current, previous)) {
                                    return Container(); // No separator if notifications are on the same day
                                  } else if (!printedEarlier) {
                                    printedEarlier = true;
                                    return Container(
                                      padding: EdgeInsets.only(
                                          left: 5, top: 10, bottom: 5),
                                      child: Text(
                                        "Earlier",
                                        style: TodayErlierStyle(),
                                      ),
                                    ); // Add a separator if notifications are on different days
                                  } else {
                                    return Container();
                                  }
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  final notification = notificationsList[index];
                                  final timeAgo = getTimeAgo(notification.Date);
                                  final formattedDate = DateFormat.yMMMd()
                                      .format(notification.Date);

                                  return Container(
                                    //padding: EdgeInsets.only(bottom: 30),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.only(
                                          left: 3.0,
                                          right: 8.0,
                                          top: 0.0,
                                          bottom: 0.0),
                                      minVerticalPadding: 30,
                                      horizontalTitleGap: 1.5,
                                      leading: Container(
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: AssetImage(
                                              statusIcon[
                                                  notificationsList[index]
                                                      .Status]),
                                        ),
                                      ),
                                      title: Text(notification.Title),
                                      subtitle: Container(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(notification.Body),
                                            Text(notificationsList[index].Note)
                                          ],
                                        ),
                                      ),
                                      trailing: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(timeAgo),
                                          SizedBox(height: 4),
                                          Text(formattedDate,
                                              style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) => track_p(
                                                      isSearchBox: false,
                                                      packageId: notification
                                                          .PackageId,
                                                    ))));
                                      },
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
    );
  }

  TextStyle TodayErlierStyle() {
    return TextStyle(
        fontSize: 20, color: primarycolor, fontWeight: FontWeight.bold);
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool isSameTodayDay(DateTime date1) {
    DateTime date2 = DateTime.now();
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool isSameWeek(DateTime date1, DateTime date2) {
    final week1 = DateTime(
        date1.year, date1.month, date1.day - date1.weekday + DateTime.monday);
    final week2 = DateTime(
        date2.year, date2.month, date2.day - date2.weekday + DateTime.monday);
    return week1 == week2;
  }

  String getTimeAgo(DateTime dateTime) {
    DateTime now = DateTime.now();
    now = DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
        dateTime.hour, dateTime.minute, dateTime.second);
    final difference = now.difference(dateTime.toUtc()).abs();

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = difference.inDays ~/ 365;
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }
}
