import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:socials/api/api_posts.dart';

import '../models/post.dart';
import '../utils/constant.dart';
import 'creating_posts.dart';
import 'menu/dashboard.dart';

class EditingPost extends StatefulWidget {
  Post post;
  EditingPost({super.key, required this.post});

  @override
  State<EditingPost> createState() => _EditingPostState();
}

class _EditingPostState extends State<EditingPost> {
  final _controller = TextEditingController();
  final _locationController = TextEditingController();
  var data = false.obs;
  Future<void> savePost() async {
    Post post = widget.post;
    post.content = _controller.text;
    post.location = _locationController.text;
    post.modifiedAt = DateTime.now().toString();
    post.status = !data.value ? "Public" : "Private";
    await APIPosts.editingPost(post);
  }

  @override
  void initState() {
    super.initState();
    data.value = widget.post.status == "Public" ? false : true;
    _controller.text = widget.post!.content!;
    _locationController.text = widget.post!.location!;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar("Chỉnh sửa bài viết"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Utils.user!.image != null
                          ? Image.network(Utils.user!.image!, width: 60, height: 60, fit: BoxFit.fill,)
                          : Image.asset("images/user.jpg", width: 60, height: 60, fit: BoxFit.fill)
                  ),
                  const SizedBox(width: 20,),
                  Text(Utils.user!.title!, style: const TextStyle(fontSize: 18, color: Colors.white))
                ],
              ),
              const SizedBox(height: 20,),
              Obx(
                      () => Row(
                    children: [
                      InkWell(
                        onTap: () {
                          data.value = !data.value;
                        },
                        child: !data.value ? const Icon(Icons.circle_outlined, color: Colors.white, size: 24,) : const Icon(Icons.circle, color: Colors.white, size: 24,),
                      ),
                      const SizedBox(width: 10,),
                      InkWell(
                        onTap: () {
                          data.value = !data.value;
                        },
                        child: const Text("Không công khai", style: TextStyle(color: Colors.white, fontSize: 16),),
                      )
                    ],
                  )
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: _controller,
                maxLines: 6,
                minLines: 4,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Bạn đang nghĩ gì?",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  fillColor: const Color(0x77777C8A),
                  filled: true,
                ),
              ),
              const SizedBox(height: 20,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(widget.post.images!.length, (index) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(widget.post.images![index].image!, width: 200, height: 200, fit: BoxFit.fill,),
                          ),
                          Positioned(
                            right: 5,
                            top: 5,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  widget.post.images!.remove(widget.post.images![index]);
                                });
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: const Center(child: Icon(Icons.delete, size: 20, color: Colors.white,),),
                              ),
                            ),
                          )
                        ],
                      )
                  )
                  ),
                )
              ),
              const SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.white,),
                      SizedBox(width: 5,),
                      Text("Vị trí", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 16),),
                    ],
                  ),
                  TextFormField(
                    controller: _locationController,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(String text) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: Row(
        children: [
          Text(text, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              Fluttertoast.showToast(
                  msg: "Đang lưu bài viết của bạn",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16
              );
              Future.delayed(const Duration(seconds: 2)).then((_) => Get.offAll(() => const DashBoard()));
              savePost();
            },
            child: const Text("LƯU", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700, fontSize: 18),),
          )
        ],
      ),
    );
  }
}
