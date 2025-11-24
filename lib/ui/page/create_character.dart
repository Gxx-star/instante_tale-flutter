import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instant_tale/features/character/character_provider.dart';
import 'package:instant_tale/ui/component/my_snackbar.dart';

class CreateCharacterPage extends ConsumerStatefulWidget {
  const CreateCharacterPage({super.key});

  @override
  ConsumerState<CreateCharacterPage> createState() =>
      _CreateCharacterPageState();
}

class _CreateCharacterPageState extends ConsumerState<CreateCharacterPage> {
  // 四个输入
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String? _selectedGender;
  File? _selectedPhoto;

  @override
  void initState() {
    super.initState();
    // 监听输入框变化，以便实时更新按钮状态
    _nameController.addListener(_updateButtonState);
    _descController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateButtonState);
    _descController.removeListener(_updateButtonState);
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {});
  }

  // 辅助方法：检查所有创建人物的必填项是否满足
  bool get _canCreateCharacter {
    final bool hasName = _nameController.text.trim().isNotEmpty;
    final bool hasAge = _descController.text.trim().isNotEmpty;
    final bool hasGender = _selectedGender != null;
    final bool hasPhoto = _selectedPhoto != null;

    return hasName && hasAge && hasGender && hasPhoto;
  }

  Future<void> _pickImage(WidgetRef ref) async {
    final _imagePicker = ImagePicker();
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1080,
    );
    if (pickedImage == null) return;
    final File image = File(pickedImage.path);
    _selectedPhoto = image;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final characterViewModel = ref.watch(characterViewModelProvider.notifier);
    final characterState = ref.watch(characterViewModelProvider);
    ref.listen(characterViewModelProvider.select((state)=>state.message), (previous,next){
      if(next != null) {
        MySnackBar.show(context, next);
      }
    });
    const Color primaryColor = Color(0xFFfaf3f8);
    const Color accentColor = Colors.pinkAccent;

    const Color disabledBackgroundColor = Color(0xffeeadd1);
    const Color disabledForegroundColor = Color(0xfffdf6fa);

    const HeaderGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFedb3d8), Color(0xFFe8d4f6)],
    );

    // 确定按钮的颜色和点击事件
    final bool isButtonEnabled = _canCreateCharacter;
    final Color buttonColor = isButtonEnabled
        ? accentColor
        : disabledBackgroundColor;
    final Color buttonTextColor = isButtonEnabled
        ? const Color(0xfffceef6)
        : disabledForegroundColor;
    final VoidCallback? onPressed = isButtonEnabled
        ? () {
            characterViewModel.addCharacter(
              _selectedPhoto!,
              _nameController.text,
              _descController.text,
            );
            context.pop();
          }
        : null;
    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 40.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xfffbfafd)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '创建专属人物',
          style: TextStyle(
            color: Color(0xfffbfafd),
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0.0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: HeaderGradient),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(10.0, 3.0, 20.0, 15.5),
            decoration: const BoxDecoration(gradient: HeaderGradient),
            child: const Text(
              '上传宝宝照片，生成独一无二的绘本主角',
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildUploadCard(),
                  const SizedBox(height: 25.0),
                  _buildBasicInfoCard(),
                  const SizedBox(height: 25.0),
                  _buildTipsCard(),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
          // 底部 "创建人物" 按钮
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 12.0,
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed, // 根据 _canCreateCharacter 决定是否可点击
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    // 动态背景色
                    foregroundColor: buttonTextColor,
                    // 动态前景色
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: disabledBackgroundColor,
                    disabledForegroundColor: disabledForegroundColor,
                  ),
                  child: Text(
                    '创建人物',
                    style: TextStyle(
                      color: buttonTextColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 上传照片
  Widget _buildUploadCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(Icons.image_rounded, color: Colors.pinkAccent, size: 22.0),
                SizedBox(width: 5.0),
                Text(
                  '上传照片',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),

          GestureDetector(
            onTap: () {
              setState(() {
                // 选择图片
                _pickImage(ref);
              });
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                _selectedPhoto != null
                    ? _buildHasPhotoState() // 有图片：实线浅粉边框
                    : _buildNoPhotoState(), // 无图片：虚线粉红边框 + 照相机Icon
                // 右下角上传 Icon (始终显示)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15.0),

          Column(
            children: [
              Text(
                '建议上传清晰的正面照片',
                style: TextStyle(color: Colors.grey[600], fontSize: 13.0),
              ),
              const SizedBox(height: 4.0),
              Text(
                '支持 JPG、PNG 格式',
                style: TextStyle(color: Colors.grey[600], fontSize: 13.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 头像状态1: 无照片 (虚线边框 + 粉色背景 + 相机图标)
  Widget _buildNoPhotoState() {
    return CustomPaint(
      painter: DashedCirclePainter(
        color: Colors.pinkAccent.withOpacity(0.5), // 虚线颜色
        strokeWidth: 3.0,
        gap: 5.0,
        dash: 5.0,
      ),
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // 浅粉红色背景
          color: Colors.pinkAccent.withOpacity(0.15),
        ),
        child: const Icon(
          Icons.camera_alt_outlined, // 粉色照相机 Icon
          size: 45,
          color: Colors.pinkAccent,
        ),
      ),
    );
  }

  // 头像状态2: 有照片 (浅粉色实线边框)
  Widget _buildHasPhotoState() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF5F5F5),
        // 浅粉色实线边框
        border: Border.all(color: Colors.pink.shade100, width: 4.0),
      ),
      // 实际开发中这里应显示 Image.file 或 Image.network
      child: ClipOval(
        child: Image.file(
          _selectedPhoto!,
          fit: BoxFit.cover,
          width: 110,
          height: 110,
        ),
      ),
    );
  }

  // 基本信息卡
  Widget _buildBasicInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person_rounded, color: Color(0xFF9C27B0), size: 22.0),
              SizedBox(width: 5.0),
              Text(
                '基本信息',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30.0),

          _buildLabel('姓名 / 昵称'),
          const SizedBox(height: 9.0),
          _buildInputField(controller: _nameController, hintText: '请输入宝宝的名字'),
          const SizedBox(height: 16.0),

          _buildLabel('描述'),
          const SizedBox(height: 9.0),
          _buildInputField(
            controller: _descController,
            hintText: '描述一下你对角色的幻想',
          ),
          const SizedBox(height: 16.0),

          _buildLabel('性别'),
          const SizedBox(height: 9.0),
          Row(
            children: [
              _buildGenderCard(
                label: '男孩',
                emoji: '👦',
                baseColor: Colors.blueAccent,
                isSelected: _selectedGender == '男孩',
              ),
              const SizedBox(width: 12.0),
              _buildGenderCard(
                label: '女孩',
                emoji: '👧',
                baseColor: Colors.pinkAccent,
                isSelected: _selectedGender == '女孩',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    const Color tipBackgroundColor = Color(0xFFFDE7F2);
    const Color tipBorderColor = Color(0xFFE0B3C9);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: tipBackgroundColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: tipBorderColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                '💡 温馨提示',
                style: TextStyle(
                  color: Color(0xFFC71585),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18.0),
          _buildTipRow('照片越清晰，生成的角色效果越好'),
          const SizedBox(height: 3.0),
          _buildTipRow('建议使用正面照片，避免侧脸或背影'),
          const SizedBox(height: 3.0),
          _buildTipRow('创建后可在"我的人物"中管理和编辑'),
        ],
      ),
    );
  }

  Widget _buildTipRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8.0, top: 8.7),
          width: 4.0,
          height: 4.0,
          decoration: BoxDecoration(
            color: Colors.grey[600],
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14.0,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    bool isNumber = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumber
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
      ),
    );
  }

  Widget _buildGenderCard({
    required String label,
    required String emoji,
    required Color baseColor,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (_selectedGender == label) {
              _selectedGender = null;
            } else {
              _selectedGender = label;
            }
            // 每次选择性别后，更新按钮状态
            _updateButtonState();
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 98.0,
          decoration: BoxDecoration(
            color: isSelected ? baseColor.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isSelected ? baseColor : Colors.grey.withOpacity(0.3),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 30)),
                    const SizedBox(height: 4.0),
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? baseColor : Colors.black87,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Positioned(
                  left: 12,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: baseColor.withOpacity(0.85),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              if (isSelected)
                Positioned(
                  right: 10,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Icon(Icons.check, size: 20, color: baseColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// 绘制虚线圆的 Painter
class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dash;

  DashedCirclePainter({
    required this.color,
    this.strokeWidth = 3,
    this.gap = 5.0,
    this.dash = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    // 确保画布尺寸足够大
    if (size.width <= strokeWidth || size.height <= strokeWidth) return;

    final double circumference = 2 * math.pi * radius;

    double currentAngle = 0;
    final double dashAngle = (dash / circumference) * 2 * math.pi;
    final double gapAngle = (gap / circumference) * 2 * math.pi;

    // 调整 Rect 以适应 strokeWidth，避免被裁剪
    final Rect rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    while (currentAngle < 2 * math.pi) {
      canvas.drawArc(rect, currentAngle, dashAngle, false, paint);
      currentAngle += dashAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
