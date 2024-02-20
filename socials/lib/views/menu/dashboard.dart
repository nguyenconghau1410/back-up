import 'package:flutter/material.dart';
import 'package:socials/api/api_service.dart';
import 'package:socials/connect/connecting_websocket.dart';
import 'package:socials/shared_preferences/local_storage.dart';
import 'package:socials/utils/constant.dart';
import 'package:socials/views/menu/home_page.dart';
import 'package:socials/views/menu/looking_for.dart';
import 'package:socials/views/menu/profile.dart';
import 'package:socials/views/menu/short_cut.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with WidgetsBindingObserver {
  int _currentIndex = 0;
  final List<Widget> screens = [
    const HomePage(),
    const LookingFor(),
    const ShortCut(),
    const Profile()
  ];

  Future<void> getCurrentUser() async {
    String? email = await LocalStorage.getUser();
    if(email != null) {
      Utils.user = await APIService.getUserByEmail(email!);
      ConnectWebSocket.connectWS(Utils.user!.email);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getCurrentUser();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      ConnectWebSocket.onDisconnect(Utils.user!.email!);
    }
    else if(state == AppLifecycleState.resumed) {
      ConnectWebSocket.connectWS(Utils.user!.email!);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedFontSize: 14,
        unselectedFontSize: 14,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: '',
              backgroundColor: Colors.black
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
              backgroundColor: Colors.black
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_library_outlined),
              label: '',
              backgroundColor: Colors.black
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
              backgroundColor: Colors.black
          ),
        ],
      ),
    );
  }

}
