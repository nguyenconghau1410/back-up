import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:socials/services/story_controller.dart';

import '../models/story.dart';
import '../models/user.dart';
import '../utils/constant.dart';
import 'display_story.dart';

class AllStory extends StatefulWidget {
  User user;
  AllStory({super.key, required this.user});

  @override
  State<AllStory> createState() => _AllStoryState();
}

class _AllStoryState extends State<AllStory> {
  StoryController storyController = StoryController();
  @override
  void initState() {
    super.initState();
  }
  Future<void> _loadData() async {
    await storyController.init(widget.user.id!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: Column(
        children: [
          FutureBuilder(
            future: _loadData(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(),);
              }
              else if(snapshot.hasError) {
                return const Center(child: CircularProgressIndicator(),);
              }
              else {
                return Expanded(
                  child: Obx(
                          () => GridView.count(
                        crossAxisCount: 3,
                        children: List.generate(storyController.stories.length, (index) {
                          Story data = storyController.stories[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => DisplayStory(story: data, user: widget.user,));
                              },
                              onLongPress: () {
                                if(widget.user.id! == Utils.user!.id) {
                                  alert(data);
                                }
                              },
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(40),
                                            border: Border.all(color: Colors.grey)
                                        ),
                                      ),
                                      data.src_image != null
                                          ? Positioned(
                                        top: 5,
                                        left: 5,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(35),
                                            child: Image.network(data.src_image!, width: 70, height: 70, fit: BoxFit.fill,)
                                        ),
                                      )
                                          : const Positioned(
                                        top: 30,
                                        left: 30,
                                        child: Center(child: Icon(Icons.play_arrow, color: Colors.grey,),),
                                      ),
                                    ],
                                  ),
                                  Text(Utils.formatDateToddmmyy(data.createdAt!), style: const TextStyle(color: Colors.grey, fontFamily: "Arizonia-Regular"),),
                                ],
                              ),
                            ),
                          );
                        }),
                      )
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: const Row(
        children: [
          Text("Stories", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
  void alert(Story story) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.black,
          shape: Border.all(
              color: Colors.grey.withOpacity(0.5)
          ),
          actions: [
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.remove_red_eye_outlined, color: Colors.white,),
                  SizedBox(width: 20,),
                  Text("Xem tin", style: TextStyle(color: Colors.white),)
                ],
              ),
              onTap: () {
                Get.to(() => DisplayStory(story: story, user: widget.user,));
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.highlight_remove, color: Colors.white,),
                  SizedBox(width: 20,),
                  Text("Xóa tin", style: TextStyle(color: Colors.white),)
                ],
              ),
              onTap: () {
                storyController.deleteStory(story);
              },
            )
          ],
          title: const Center(child: Text("Lựa chọn", style: TextStyle(color: Colors.white),),),
          contentPadding: const EdgeInsets.all(20),
        )
    );
  }
}
