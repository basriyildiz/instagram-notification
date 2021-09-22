import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:instagram_notifacation/model/notifications.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<dynamic> notifications = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/json/nat.json');
    final data = await json.decode(response);

    setState(() {
      notifications = data['notifications']
          .map((data) => InstagramNotification.fromJson(data))
          .toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Activity",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Slidable(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    notifications[index].hasStory
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.red.shade600,
                                    Colors.orange.shade300,
                                  ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(1.0, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    notifications[index].profilePic),
                              ),
                            ),
                          )
                        : CircleAvatar(
                            backgroundImage:
                                NetworkImage(notifications[index].profilePic),
                          ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: notifications[index].name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: notifications[index].content,
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                text: notifications[index].timeAgo,
                                style: TextStyle(color: Colors.grey.shade500),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    notifications[index].postImage != ''
                        ? Expanded(
                            child: Container(
                              width: 50,
                              height: 50,
                              child: ClipRRect(
                                  child: Image.network(
                                      notifications[index].postImage)),
                            ),
                          )
                        : Expanded(
                            child: Container(
                                height: 35,
                                width: 50,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                    )
                                  ],
                                  color: Colors.blue[700],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                    child: Text('Follow',
                                        style:
                                            TextStyle(color: Colors.white)))),
                          ),
                  ],
                ),
              ),
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              secondaryActions: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          borderRadius: BorderRadius.circular(5)),
                      height: 60,
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5)),
                      child: Icon(
                        Icons.delete_outline_sharp,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
