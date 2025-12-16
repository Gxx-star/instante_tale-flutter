import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 新增导入
import 'package:instant_tale/features/login/login_provider.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginViewModel = ref.watch(loginViewModelProvider.notifier);
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
            style: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.bold), // 字体大小加sp
          ),
          Text("创建账号，开启绘本创作之旅", style: TextStyle(color: Colors.grey)),
          Padding(
            padding: EdgeInsets.only(top: 50.h), // 纵向间距加h
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
                padding: EdgeInsets.only(left: 20.w), // 横向间距加w
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
            // 横向/纵向间距分别加w/h
            padding: EdgeInsets.only(left: 30.w, right: 30.w, bottom: 30.h),
            child: child,
          );
        }).toList(),
      ),
    );
  }
}
