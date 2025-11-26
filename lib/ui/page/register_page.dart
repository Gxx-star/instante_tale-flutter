import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/features/login/login_provider.dart';

class RegisterPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginViewModel = ref.watch(loginViewModelProvider.notifier);
    final loginState = ref.read(loginViewModelProvider);
    return Scaffold(
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
                "注册账户",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              Text("创建账号，开启绘本创作之旅", style: TextStyle(color: Colors.grey)),
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: TextField(
                  onChanged: (value) {
                    loginViewModel.updatePhone(value);
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
                        loginViewModel.updateSmsCode(value);
                      },
                      decoration: InputDecoration(hintText: "请输入验证码"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        // 发送验证码
                        loginViewModel.sendMsg();
                      },
                      child: Text("获取验证码"),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(onPressed: () {
                }, child: Text("注册")),
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
