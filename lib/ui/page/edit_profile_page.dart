import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/config/edit_profile_page_config.dart';
import 'package:instant_tale/features/user/user_provider.dart';
import '../../features/user/user_viewmodel.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _bioController; // 简介
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
    _bioController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialUser = ref.read(userViewModelProvider).user;
      if (initialUser != null) {
        _nameController.text = initialUser.name;
        _phoneController.text = initialUser.phone;
        _locationController.text = initialUser.location ?? '';
        _bioController.text = initialUser.personalProfile ?? '';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // --- 静态渐变色配置 ---
  static final _appBarGradient = EditProfilePageConfig.appBarGradient;
  static final _buttonGradient = EditProfilePageConfig.buttonGradient;
  static final _avatarBorderGradient = EditProfilePageConfig.avatarBorderGradient;
  static final _tipIconGradient = EditProfilePageConfig.tipIconGradient;

  @override
  Widget build(BuildContext context) {
    final userState = ref.read(userViewModelProvider);
    final user = userState.user!; // 这才是实时更新的 User 对象
    final userViewModel = ref.read(userViewModelProvider.notifier);
    AppGlobals().listenAndShowSnackBar(ref: ref, context: context, provider: userViewModelProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: false,
        backgroundColor: const Color(0xFFfaf2f8),
        appBar: AppBar(
          toolbarHeight: 50.0.h,
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: const Color(0xfffbfafd), size: 24.w),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            '个人资料',
            style: TextStyle(
              color: const Color(0xfffbfafd),
              fontWeight: FontWeight.w500,
              fontSize: 18.0.sp,
            ),
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor:Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: _appBarGradient),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 16.6.h),
          child: SafeArea(
            top: false,
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                gradient: _buttonGradient,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8A9EFC).withOpacity(0.4),
                    blurRadius: 10.w,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.r),
                  onTap: () {
                    ref
                        .read(userViewModelProvider.notifier)
                        .updateUserInfo(
                      user.copyWith(
                        name: _nameController.text,
                        location: _locationController.text,
                        personalProfile: _bioController.text,
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save_outlined, color: Colors.white, size: 22.w),
                      SizedBox(width: 8.w),
                      Text(
                        '保存修改',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.0.w),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    // 头像模块
                    GestureDetector(
                      onTap: () {
                        _pickImage(ref, userViewModel);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 30.0.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10.w,
                              offset: Offset(0, 5.h),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  Container(
                                    width: 110.w,
                                    height: 110.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFD1C4FF),
                                        width: 2.w,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      radius: 50.w,
                                      backgroundImage: NetworkImage(
                                        user.avatar,
                                      ),
                                      backgroundColor: Colors.grey,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        gradient: _avatarBorderGradient,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 4.w,
                                            offset: Offset(0, 2.h),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 20.w,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Text(
                              '点击图标更换头像',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    // 基本信息模块
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("基本信息"),
                        SizedBox(height: 15.h),
                        _buildInfoCard(
                          label: "昵称",
                          controller: _nameController,
                          icon: Icons.person_outline,
                          iconColor: const Color(0xFFE87AB5),
                        ),
                        SizedBox(height: 15.h),
                        _buildInfoCard(
                          label: "手机号",
                          controller: _phoneController,
                          icon: Icons.phone_outlined,
                          iconColor: const Color(0xFF6CA0DC),
                          isReadOnly: true,
                          suffixWidget: Container(
                            height: 28.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '修改',
                              style: TextStyle(
                                fontSize: 12.5.sp,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        _buildInfoCard(
                          label: "所在地",
                          controller: _locationController,
                          icon: Icons.location_on_outlined,
                          iconColor: const Color(0xFF9C27B0),
                        ),
                        SizedBox(height: 30.h),
                        _buildSectionHeader("个人简介"),
                        SizedBox(height: 15.h),
                        Container(
                          padding: EdgeInsets.all(17.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 0.8.w,
                            ),
                          ),
                          child: Stack(
                            children: [
                              // 【重要修改】：移除了内层装饰性 Container
                              // 直接使用 TextField，让它继承全局 Theme
                              TextField(
                                controller: _bioController,
                                maxLength: 80,
                                maxLines: 4,
                                minLines: 2,
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(
                                  fontSize: 15.4.sp,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                                // 移除样式覆盖，使用全局 Theme
                                decoration: const InputDecoration(
                                  isDense: true,
                                  counterText: "", // 隐藏自带计数器，使用自定义的
                                  hintText: "请输入个人简介...",
                                  hintStyle: TextStyle(color: Colors.black26),
                                ),
                              ),
                              Positioned(
                                bottom: 10.h,
                                right: 15.w,
                                child: Text(
                                  '${_bioController.text.length} / 80',
                                  style: TextStyle(
                                    fontSize: 12.5.sp,
                                    color: Colors.grey.withOpacity(0.6),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F5FE),
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: const Color(0xFFD1C4E9).withOpacity(0.5),
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50.w,
                            height: 68.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: _tipIconGradient,
                            ),
                            child: Text(
                              "💡",
                              style: TextStyle(fontSize: 22.sp),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "温馨提示",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  "完善个人资料可以让其他用户更好地了解你，也能获得更个性化的绘本推荐哦！",
                                  style: TextStyle(
                                    fontSize: 12.3.sp,
                                    color: Colors.grey,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 标题组件
  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 24.h,
          decoration: BoxDecoration(
            gradient: _buttonGradient,
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
        SizedBox(width: 8.w),
        ShaderMask(
          shaderCallback: (bounds) => _buttonGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.6.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // 通用信息卡片
  Widget _buildInfoCard({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Color iconColor,
    bool isReadOnly = false,
    Widget? suffixWidget,
  }) {
    return Container(
      // 这里保留白色的大卡片背景，因为这是布局层级
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 0.8.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.3.w, color: iconColor),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 26.h),
          // 【重要修改】：删除了之前包裹 TextField 的装饰性 Container
          // 直接放置 TextField，并移除了所有禁用边框的属性
          // 现在它会自动使用 AppTheme 中的背景色(0xFFFEF3F7)和边框样式
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: isReadOnly,
                  style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                  // 仅保留必要的布局属性，样式全走 Theme
                  decoration: const InputDecoration(
                    isDense: true,
                    // 移除了 filled: false, border: none 等
                    // 现在这里完全透明，Theme 会自动应用
                  ),
                ),
              ),
              if (suffixWidget != null) ...[
                SizedBox(width: 8.w),
                suffixWidget,
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(WidgetRef ref, UserViewModel userViewModel) async {
    final _imagePicker = ImagePicker();
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1080,
    );
    if (pickedImage == null) return;
    final File avatarFile = File(pickedImage.path);
    await userViewModel.updateUserAvatar(avatarFile);
  }
}
