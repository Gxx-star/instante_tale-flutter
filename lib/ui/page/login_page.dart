import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_tale/features/login/login_viewmodel.dart';

import '../../features/login/login_provider.dart';

class LoginPage extends ConsumerWidget {
  var _inputPhone = "";
  var _inputPassword = "";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 100)),
          Image(
            image: AssetImage('assets/images/login_flag.png'),
            height: 200,
            width: 200,
          ),
          Text("欢迎使用即刻绘本"),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: TextField(
              decoration: InputDecoration(hintText: "请输入手机号"),
              onChanged: (value) {
                _inputPhone = value;
              },
            ),
          ),
          Text("密码"),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: TextField(
              decoration: InputDecoration(hintText: "请输入密码"),
              onChanged: (value) {
                _inputPassword = value;
              },
            ),
          ),
          ElevatedButton(onPressed: () {
            ref.read(loginViewModelProvider.notifier).login(
                _inputPhone, _inputPassword);
          }, child: Text("登录"))
        ],
      ),
    );
  }
}
