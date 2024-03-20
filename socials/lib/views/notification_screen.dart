import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socials/api/api_notification.dart';
import 'package:socials/utils/constant.dart';

import '../models/notification_be.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  
  Future<List<NotificationBE>> getData() async {
    return APINotification.getListNotification(Utils.user!.id!);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            }
            else if(snapshot.hasError) {
              return const Center(child: CircularProgressIndicator(),);
            }
            else {
              final data = snapshot.data;
              return Column(
                children: List.generate(data!.length, (index) => itemNotification(data[index])),
              );
            }
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: const Row(
        children: [
          Text("Thông báo", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
        ],
      ),
    );
  }
  Widget itemNotification(NotificationBE notification) {
    return InkWell(
      onTap: () {

      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 18,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: notification.user!.image == null
                    ? Image.asset("images/user.jpg", width: 40, height: 40, fit: BoxFit.fill,)
                    : Image.network(notification.user!.image!, width: 40, height: 40, fit: BoxFit.fill,),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: Text(
                  notification.content!,
                  style: const TextStyle(color: Colors.white),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.only(left: 68),
            child: Text("${Utils.formatDateToddmmyy(notification.timestamp!)} ${Utils.formatDateTohhss(notification.timestamp!)}", style: const TextStyle(color: Colors.grey),),
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
}
