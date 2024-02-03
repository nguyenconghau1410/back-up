import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:social/api/api_service.dart';
import 'package:social/utils/constant.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditingProfile extends StatefulWidget {
  const EditingProfile({super.key});

  @override
  State<EditingProfile> createState() => _EditingProfileState();
}

class _EditingProfileState extends State<EditingProfile> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _titleControler = TextEditingController();
  final _genderController = TextEditingController();

  @override
  void initState() {
    _nameController.text = Utils.user!.name ?? "";
    _emailController.text = Utils.user!.email ?? "";
    if(Utils.user!.dob != null) {
      _dobController.text = Utils.user!.dob!;
    }
    if(Utils.user!.title != null) {
      _titleControler.text = Utils.user!.title!;
    }
    if(Utils.user!.gender != null) {
      _genderController.text = Utils.user!.gender == true ? "Nam" : "Nữ";
    }
  }

  void saveUser() async {
    Utils.user!.email = _emailController.text;
    Utils.user!.name = _nameController.text;
    Utils.user!.title = _titleControler.text;
    Utils.user!.dob = _dobController.text;
    Utils.user!.gender = _genderController.text == "Nam" ? true : false;
    await APIService.updateUser(Utils.user!);
    Fluttertoast.showToast(
        msg: "Lưu thành công",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
    await Future.delayed(const Duration(seconds: 2), () {
      Get.back();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar("Chỉnh sửa trang cá nhân"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _itemInput("Email", _emailController),
            _itemInput("Tên", _titleControler),
            _itemInput("Tên người dùng", _nameController),
            _itemInput("Ngày sinh   #dd-mm-yyyy", _dobController),
            _itemInput("Giới tính", _genderController),
            const SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () {
                saveUser();
              },
              child: const Text("Lưu thay đổi", style: TextStyle(color: Colors.white),),
            )
          ],
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
          Expanded(child: Container()),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
          Expanded(child: Container()),
          const Icon(Icons.add, color: Colors.black, size: 30,)
        ],
      ),
    );
  }
  Widget _itemInput(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 14),),
          TextFormField(
            controller: controller,
            style: const TextStyle(fontSize: 18, color: Colors.white),
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
      ),
    );
  }
}
