import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:social/connect/connecting_websocket.dart';
import 'package:social/utils/constant.dart';
import 'package:social/views/messenger_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> images = ["111.jpg", "111.jpg"];
  List<String> list = ["myStory" ,"user1", "user2", "user3", "user4"];
  @override
  void initState() {
    super.initState();
    ConnectWebSocket.connectWS(Utils.user!.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(list.length, (index) {
                  if(index == 0) {
                    return _myStory("user.jpg");
                  }
                  else {
                    return _story(list[index], "login.jpg");
                  }
                }),
              ),
            ),
            const SizedBox(height: 20,),
            Column(
              children: List.generate(images.length, (index) => _buildPost(images)),
            )
            
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: Row(
        children: [
          const Text("ZNET", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, fontFamily: "Lato"),),
          Expanded(child: Container()),
          const Icon(Icons.favorite_outline_rounded, size: 30,),
          const SizedBox(width: 25,),
          InkWell(
            onTap: () {
              Get.to(const MessengerScreen());
            },
            child: const Icon(FontAwesomeIcons.facebookMessenger,),
          ),
          const SizedBox(width: 5,)
        ],
      ),
    );
  }

  Widget _buildPost(List<String> images) {
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
                  child: Image.asset(
                    "images/login.jpg",
                    width: 40,
                    height: 40,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(width: 10,),
                const Text("Barcelona FC", style: TextStyle(color: Colors.white),),
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
                    children: const [
                      TextSpan(
                          text: "This is a beautiful girl",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white
                          )
                      )
                    ]
                ),
              ),
            ),
            const SizedBox(height: 5,),
            Container(
                constraints: const BoxConstraints(
                    maxHeight: 450
                ),
                child: _buildListImages(images)
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, top: 30),
              child: Row(
                children: [
                  Icon(Icons.favorite_outline_rounded, color: Colors.white, size: 30,),
                  SizedBox(width: 20,),
                  Icon(FontAwesomeIcons.commentDots, color: Colors.white, size: 30,),
                  SizedBox(width: 20,),
                  Icon(Icons.share, color: Colors.white, size: 30,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListImages(List<String> list) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, index) {
        int cnt = list.length;
        int i = index + 1;
        return Stack(
          children: [
            _buildImage(list[index]),
            Positioned(
              top: 5,
              right: 10,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Text(cnt == 1 ? "" : "$i/$cnt", style: const TextStyle(color: Colors.white),),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildImage(String text) {
    return Image.asset(
      "images/$text",
      width: MediaQuery.of(context).size.width,
      height: 450,
      fit: BoxFit.cover,
    );
  }

  Widget _story(String name, String path) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(35),
        onTap: () {

        },
        child: Column(
          children: [
            ClipOval(
              child: Image.asset(
                "images/$path",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10,),
            Text(name, style: const TextStyle(fontSize: 16, color: Colors.white,),)
          ],
        ),
      ),
    );
  }
  Widget _myStory(String image) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 20),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(35),
            onTap: () {

            },
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        "images/$image",
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 8,
                      child: Image.asset(
                        "images/add.png",
                        width: 25,
                        height: 25,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                const Text("Tin của bạn", style: TextStyle(fontSize: 16, color: Colors.white,),)
              ],
            ),
          ),

        ],
      ),
    );
  }
}
