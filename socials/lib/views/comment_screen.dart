import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socials/models/comment.dart';
import 'package:socials/services/comment_controller.dart';

import '../models/post.dart';
import '../utils/constant.dart';

class CommentScreen extends StatefulWidget {
  Post post;
  CommentScreen({super.key, required this.post});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  CommentController _commentController = CommentController();
  String? commentId;
  int? idx;
  @override
  void initState() {
    super.initState();
  }
  Future<void> _loadData() async {
    await _commentController.init(widget.post.id!);
  }
  Future<List<Comment>> _loadData1(List<Comment> replies) async {
    return replies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar("Bình luận"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: FutureBuilder(
                    future: _loadData(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(),);
                      }
                      else if(snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator(),);
                      }
                      else {
                        return Obx(() => Column(
                            children: List.generate(_commentController.comments.length, (index) => _buildComment(_commentController.comments[index], index))
                        ));
                      }
                    },
                  )
              ),
            ),
          ),
          _messageTool()
        ],
      ),
    );
  }
  Widget _buildComment(Comment comment, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: comment.user!.image == null
                ? Image.asset("images/user.jpg", width: 40, height: 40, fit: BoxFit.fill,)
                : Image.network(comment.user!.image!, width: 40, height: 40, fit: BoxFit.fill),
            ),
            const SizedBox(width: 10,),
            Text(comment.user!.name!, style: const TextStyle(color: Colors.white, fontSize: 16),),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Text(
            comment.content!,
            style: const TextStyle(color: Colors.white),
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        InkWell(
          onTap: () {

          },
          child: Padding(
            padding: const EdgeInsets.only(left: 50, top: 8),
            child: InkWell(
              onTap: () {
                comment.clicked.value = true;
                commentId = comment.id;
                idx = index;
                _controller.text = "@${comment.user!.name} ";
                _focusNode.requestFocus();
                _focusNode.addListener(() {
                  if(!_focusNode.hasFocus) {
                    comment.clicked.value = false;
                    _controller.clear();
                  }
                });
              },
              child: Obx(
                  () => comment.clicked.value
                      ? const Text("Trả lời", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),)
                      : const Text("Trả lời", style: TextStyle(color: Colors.grey),)
              ),
            ),
          ),
        ),
        const SizedBox(height: 16,),
        comment.replies != null
            ? Padding(
                padding: const EdgeInsets.only(left: 50),
                child: _buildComment1(comment.replies!, widget.post.id!, comment.id!, index),
              )
            : Container()
      ],
    );
  }
  PreferredSizeWidget _appBar(String text) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: Row(
        children: [
          Obx(
              () => Text("$text (${_commentController.count()})", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
  Widget _messageTool() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        style: const TextStyle(fontSize: 18, color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: InkWell(
            onTap: () {

            },
            child: const Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Icon(Icons.circle, color: Colors.blue, size: 50,),
                Icon(Icons.camera_alt, color: Colors.white,)
              ],
            ),
          ),
          suffixIcon: InkWell(
            onTap: () {
              print(commentId); print(idx);
              if(commentId != null && idx != null) {
                if(_commentController.comments[idx!].replies == null) {
                  _commentController.comments[idx!].replies = [];
                }
                Comment comment = Comment(null, Utils.user!, widget.post.id,
                    _controller.text, null, DateTime.now().toString(), null);
                _commentController.comments[idx!].replies!.add(comment);
                _commentController.addFake(comment, widget.post.id!, commentId!);
                commentId = null; idx = null;
              }
              else if(_controller.text != "") {
                _commentController.addComment(Comment(null, Utils.user!, widget.post.id,
                    _controller.text, null, DateTime.now().toString(), null));
              }
              _controller.clear();
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.send, color: Colors.blue, size: 30,),
            ),
          ),
          hintText: "Bình luận",
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.black,
              )
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.black,
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.black,
              )
          ),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.black,
              )
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          fillColor: const Color(0x77777C8A),
          filled: true,
        ),
      ),
    );
  }
  Widget _buildComment1(List<Comment> replies, String postid, String commentid, int inde) {
    return FutureBuilder(
      future: _loadData1(replies),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }
        else if(snapshot.hasError) {
          print(_commentController.comments.length);
          return const Center(child: CircularProgressIndicator(),);
        }
        else {
          return Column(
            children: List.generate(replies.length, (index) {
              Comment comment = replies[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: comment.user!.image == null
                            ? Image.asset("images/user.jpg", width: 40, height: 40, fit: BoxFit.fill,)
                            : Image.network(comment.user!.image!, width: 40, height: 40, fit: BoxFit.fill),
                      ),
                      const SizedBox(width: 10,),
                      Text(comment.user!.name!, style: const TextStyle(color: Colors.white, fontSize: 16),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text(
                      comment.content!,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, top: 8),
                    child: InkWell(
                      onTap: () {
                        comment.clicked.value = true;
                        commentId = commentid;
                        idx = inde;
                        _controller.text = "@${comment.user!.name} ";
                        _focusNode.requestFocus();
                        _focusNode.addListener(() {
                          if(!_focusNode.hasFocus) {
                            comment.clicked.value = false;
                            commentId = null;
                            idx = null;
                            _controller.clear();
                          }
                        });
                      },
                      child: Obx(
                              () => comment.clicked.value
                              ? const Text("Trả lời", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),)
                              : const Text("Trả lời", style: TextStyle(color: Colors.grey),)
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
                ],
              );
            }),
          );
        }
      },
    );
  }
}
