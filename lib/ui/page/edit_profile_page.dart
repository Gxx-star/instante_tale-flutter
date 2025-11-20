import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController(text: "小明妈妈");
  final TextEditingController _bioController = TextEditingController(text: "热爱阅读的妈妈，喜欢和孩子一起探索绘本的世界。");
  final TextEditingController _phoneController = TextEditingController(text: "13800138000");
  final TextEditingController _locationController = TextEditingController(text: "北京市朝阳区");
  // --- 静态渐变色配置 ---
  static const _appBarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFecaed5), Color(0xFFf0d0e7)],
  );

  static const _buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFE87AB5), Color(0xFF8A9EFC)],
  );

  static const _avatarBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFDE65BD), Color(0xFF8E70F5)],
  );

  static const _cameraIconGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFDE65BD), Color(0xFF8E70F5)],
  );

  static const _titleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE87AB5), Color(0xFF8A9EFC)],
  );

  static const _tipIconGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8FABFF), Color(0xFFC599FF)],
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFfaf2f8),
        appBar: AppBar(
          toolbarHeight: 40.0,
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xfffbfafd)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            '个人资料',
            style: TextStyle(
              color: Color(0xfffbfafd),
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: _appBarGradient,
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomSaveButton(context),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildAvatarSection(),
                    const SizedBox(height: 30),
                    _buildFormSection(),
                    const SizedBox(height: 30),
                    _buildTipsSection(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 1. 头像模块 (保持不变) ---
  Widget _buildAvatarSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.pinkAccent.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _avatarBorderGradient,
                  ),
                  alignment: Alignment.center,
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
                    backgroundColor: Colors.grey,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: _cameraIconGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            '点击图标更换头像',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. 表单模块 ---
  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("基本信息"),
        const SizedBox(height: 15),
        _buildInfoCard(
          label: "昵称",
          controller: _nameController,
          icon: Icons.person_outline,
          iconColor: const Color(0xFFE87AB5),
        ),
        const SizedBox(height: 15),
        _buildInfoCard(
          label: "手机号",
          controller: _phoneController,
          icon: Icons.phone_outlined,
          iconColor: const Color(0xFF6CA0DC),
          isReadOnly: true,
          suffixWidget: _buildModifyButton(),
        ),
        const SizedBox(height: 15),
        _buildInfoCard(
          label: "所在地",
          controller: _locationController,
          icon: Icons.location_on_outlined,
          iconColor: const Color(0xFF9C27B0),
        ),
        const SizedBox(height: 30),
        _buildSectionHeader("个人简介"),
        const SizedBox(height: 15),
        _buildBioCard(),
      ],
    );
  }

  // 标题组件
  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 24,
          decoration: BoxDecoration(
            gradient: _titleGradient,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 8),
        ShaderMask(
          shaderCallback: (bounds) => _titleGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18.6,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // --- 核心修改 1: 通用信息卡片 ---
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
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.3, color: iconColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          // 【重要修改】：删除了之前包裹 TextField 的装饰性 Container
          // 直接放置 TextField，并移除了所有禁用边框的属性
          // 现在它会自动使用 AppTheme 中的背景色(0xFFFEF3F7)和边框样式
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: isReadOnly,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  // 仅保留必要的布局属性，样式全走 Theme
                  decoration: const InputDecoration(
                    isDense: true,
                    // 移除了 filled: false, border: none 等
                    // 现在这里完全透明，Theme 会自动应用
                  ),
                ),
              ),
              if (suffixWidget != null) ...[
                const SizedBox(width: 8),
                suffixWidget,
              ]
            ],
          ),
        ],
      ),
    );
  }

  // --- 核心修改 2: 简介卡片 ---
  Widget _buildBioCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 0.8),
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
            style: const TextStyle(
              fontSize: 15.4,
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
            bottom: 10,
            right: 15,
            child: Text(
              '${_bioController.text.length} / 80',
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 修改按钮
  Widget _buildModifyButton() {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: const Text(
        '修改',
        style: TextStyle(
          fontSize: 12.5,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // --- 3. 提示模块 ---
  Widget _buildTipsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F5FE),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFD1C4E9).withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 68,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: _tipIconGradient,
            ),
            child: const Text("💡", style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "温馨提示",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "完善个人资料可以让其他用户更好地了解你，也能获得更个性化的绘本推荐哦！",
                  style: TextStyle(fontSize: 12.3, color: Colors.grey, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. 底部按钮 ---
  Widget _buildBottomSaveButton(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.6),
      child: SafeArea(
        top: false,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            gradient: _buttonGradient,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8A9EFC).withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save_outlined, color: Colors.white, size: 22),
                  SizedBox(width: 8),
                  Text(
                    '保存修改',
                    style: TextStyle(
                        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}