import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/features/login/login_provider.dart';

class ForgetPasswordPage extends ConsumerStatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends ConsumerState<ForgetPasswordPage> {
  String _inputPhone = "";
  String _inputCode = "";
  String _inputPassword = "";
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    final loginViewModel = ref.watch(loginViewModelProvider.notifier);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            [
              Text(
                "忘记密码",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              Text(
                "使用手机号找回密码需使用手机号完成登录，登陆后可修改对应账号密码",
                style: TextStyle(color: Colors.grey),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: TextField(
                  onChanged: (value) {
                    _inputPhone = value;
                  },
                  decoration: InputDecoration(hintText: "请输入手机号"),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        _inputCode = value;
                      },
                      decoration: InputDecoration(hintText: "请输入验证码"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        loginViewModel.sendMsg();
                      },
                      child: Text("获取验证码"),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    _inputPassword = value;
                  },
                  decoration: InputDecoration(
                    hintText: "请输入新密码",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isHidden ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isHidden = !_isHidden;
                        });
                      },
                    ),
                  ),
                  obscureText: _isHidden,
                ),
              ),
              Text("已阅读并同意服务协议和隐私保护指引", style: TextStyle(color: Colors.grey)),
              Container(
                width: double.infinity,
                child: ElevatedButton(onPressed: () {}, child: Text("找回密码")),
              ),
            ].map((child) {
              return Padding(
                padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                child: child,
              );
            }).toList(),
      ),
    );
  }
}
