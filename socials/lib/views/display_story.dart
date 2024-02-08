import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socials/utils/constant.dart';
import 'package:socials/utils/video_app.dart';
import 'package:video_player/video_player.dart';

import '../models/story.dart';

class DisplayStory extends StatefulWidget {
  Story story;
  DisplayStory({super.key, required this.story});

  @override
  State<DisplayStory> createState() => _DisplayStoryState();
}

class _DisplayStoryState extends State<DisplayStory> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  double _maxTime = 8;
  double _currentTime = 0;
  VideoPlayerController? _videoPlayerController;
  @override
  void initState() {
    super.initState();
    if(widget.story.src_video != null) {
      // _videoPlayerController = VideoPlayerController.networkUrl(
      //     Uri.parse(widget.story.src_video!)
      // )..initialize().then((_) {
      //   _videoPlayerController!.play();
      //   _videoPlayerController!.addListener(() {
      //     if(_videoPlayerController!.value.position >= _videoPlayerController!.value.duration) {
      //       Get.back();
      //     }
      //   });
      // });
    }
    else {
      _animationController = AnimationController(
          vsync: this,
          duration: Duration(seconds: _maxTime.toInt())
      )
        ..addListener(() {
          setState(() {
            if(_animationController!.value == 1.0) {
              Get.back();
            }
          });
        });
      _animationController!.forward();
    }
  }

  Future<void> _loadVideo() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.story.src_video!)
    )..initialize().then((_) {
      _videoPlayerController!.play();
      _videoPlayerController!.addListener(() {
        if(_videoPlayerController!.value.position >= _videoPlayerController!.value.duration) {
          Get.back();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_animationController != null) {
      _currentTime = _animationController!.value * _maxTime;
    }
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              widget.story.src_image != null
              ? Column(
                children: [
                  Expanded(child: Container()),
                  Image.network(
                    widget.story.src_image!,
                    // width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: SliderComponentShape.noThumb,
                    ),
                    child: Slider(
                      activeColor: Colors.grey,
                      inactiveColor: Colors.white,
                      thumbColor: Colors.white,
                      value: _currentTime,
                      min: 0,
                      max: _maxTime,
                      onChanged: (value) {},
                    ),
                  ),
                  Expanded(child: Container())
                ],
              )
              : Positioned.fill(
                  child: Column(
                    children: [
                      Expanded(child: Container()),
                      FutureBuilder(
                        future: _loadVideo(),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          else if(snapshot.hasError) {
                            return const CircularProgressIndicator();
                          }
                          else {
                            return AspectRatio(
                              aspectRatio: _videoPlayerController!.value.aspectRatio,
                              child: VideoPlayer(_videoPlayerController!),
                            );
                          }
                        },
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                ),
              Positioned(
                left: 10,
                top: 15,
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.blueGrey, width: 2)
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Utils.user!.image! == null
                              ? Image.asset("images/user.jpg", width: 60, height: 60, fit: BoxFit.fill,)
                              : Image.network(Utils.user!.image!, width: 60, height: 60, fit: BoxFit.fill,)
                      ),
                    ),
                    const SizedBox(width: 16,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Utils.user!.name!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),),
                        const SizedBox(height: 10,),
                        Text(Utils.formatDateToddmmyy(widget.story.createdAt!), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black ,fontFamily: "Arizonia-Regular"),)
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 15,
                right: 10,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.close, size: 36, color: Colors.grey,),
                ),
              )
            ],
          ),
        ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    if(_animationController != null) {
      _animationController!.dispose();
    }
    if(_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }
  }
}
