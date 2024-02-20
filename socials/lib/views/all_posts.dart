import 'dart:core';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:socials/api/api_posts.dart';
import 'package:socials/models/favorite.dart';
import 'package:socials/models/post_relation.dart';
import 'package:socials/views/comment_screen.dart';
import 'package:socials/views/view_image.dart';

import '../models/images.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_controller.dart';
import '../utils/constant.dart';

class AllPosts extends StatefulWidget {
  User user;
  AllPosts({super.key, required this.user});

  @override
  State<AllPosts> createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  List<PostController> posts = [];
  final _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadPosts() async {
    List<PostRelation> data = await APIPosts.getAllPosts(widget.user.id!);
    List<PostController> list = [];
    data.forEach((element) {
      PostController postController = PostController();
      postController.init(element, Utils.user!.id!);
      list.add(postController);
    });
    posts = list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: FutureBuilder(
              future: _loadPosts(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(),);
                }
                else if(snapshot.hasError) {
                  return const Center(child: CircularProgressIndicator(),);
                }
                else {
                  return Column(
                    children: List.generate(posts.length, (index) {
                      return _buildPost(posts[index]);
                    }),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: Row(
        children: [
          Text(widget.user.name!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
  Widget _buildPost(PostController post) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
                width: 1.0,
                color: Colors.grey
            ),
            bottom: BorderSide(
                width: 1.0,
                color: Colors.grey
            ),
          )
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 10,),
                ClipOval(
                  child: widget.user.image == null
                      ? Image.asset("images/user.jpg", width: 40, height: 40, fit: BoxFit.fill,)
                      : Image.network(widget.user.image!, width: 40, height: 40, fit: BoxFit.fill,),
                ),
                const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.user.name!, style: const TextStyle(color: Colors.white, fontSize: 16),),
                    Text(Utils.formatDateToddmmyy(post.postRelation!.post!.createdAt!), style: const TextStyle(color: Colors.grey),)
                  ],
                ),
                Expanded(child: Container()),
                const Icon(Icons.more_vert, color: Colors.white, size: 24,)
              ],
            ),
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                          text: post.postRelation!.post!.content!,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white
                          )
                      )
                    ]
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
                constraints: const BoxConstraints(
                    maxHeight: 450
                ),
                child: _buildListImages(post.postRelation!.post!.images!)
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  Obx(
                      () => InkWell(
                        onTap: () {
                          post.onChanged(Favorite(null, Utils.user!.id!, post.postRelation!.post!.id));
                        },
                        child: post.clicked.value
                          ? const Icon(Icons.favorite, color: Colors.red, size: 24,)
                          : const Icon(Icons.favorite_outline_rounded, color: Colors.white, size: 24,),
                      )
                  ),
                  const SizedBox(width: 20,),
                  InkWell(
                    onTap: () {
                      Get.to(() => CommentScreen(post: post.postRelation!.post!,));
                    },
                    child: const Icon(FontAwesomeIcons.commentDots, color: Colors.white, size: 24,),
                  ),
                  const SizedBox(width: 20,),
                  const Icon(Icons.share, color: Colors.white, size: 24,)
                ],
              ),
            ),
            Obx(
                () => Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text("${post.quantityLike.value} lượt thích", style: const TextStyle(color: Colors.white),)
                )
            )
          ],
        ),
      ),
    );
  }
  Widget _buildListImages(List<Images> list)
  {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, index) {
        int cnt = list.length;
        int i = index + 1;
        return InkWell(
          onTap: () {
            Get.to(() => ViewImage(images: list));
          },
          child: Stack(
            children: [
              _buildImage(list[index].image!),
              Positioned(
                top: 5,
                right: 10,
                child: Container(
                  width: 30,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(child: Text(cnt == 1 ? "" : "$i/$cnt", style: const TextStyle(color: Colors.white),),),
                ),
              )
            ],
          ),
        );
      },
    );
  }
  Widget _buildImage(String text) {
    return Image.network(text, width: MediaQuery.of(context).size.width, fit: BoxFit.fill,);
  }
}

