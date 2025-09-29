import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/facebook_colors.dart';
import '../../core/theme/facebook_sizes.dart';
import '../../core/theme/facebook_text_styles.dart';
import '../../core/di/service_locator.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nickname = TextEditingController();
  final _signature = TextEditingController();
  final _gender = ValueNotifier<String?>(null);
  DateTime? _birthday;
  final _region = TextEditingController();
  final _email = TextEditingController();
  // 使用 MemoryImage 的 bytes 类型，Uint8List 可由 flutter/services 暴露
  Uint8List? _avatar;
  bool _loading = false;

  final _repo = getIt<UserProfileRepository>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await _repo.getProfile();
    if (p == null) return;
    setState(() {
      _avatar = p.avatar;
      _nickname.text = p.nickname ?? '';
      _signature.text = p.signature ?? '';
      _gender.value = p.gender;
      _birthday = p.birthday;
      _region.text = p.region ?? '';
      _email.text = p.email ?? '';
    });
  }

  @override
  void dispose() {
    _nickname.dispose();
    _signature.dispose();
    _region.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FacebookColors.background,
      appBar: AppBar(
        backgroundColor: FacebookColors.primary,
        foregroundColor: Colors.white,
        title: const Text('编辑资料'),
        actions: [
          TextButton(
            onPressed: _loading ? null : _save,
            child: Text(
              '保存',
              style: FacebookTextStyles.bodyMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(FacebookSizes.spacing16),
          children: [
            _avatarSection(),
            SizedBox(height: FacebookSizes.spacing16),
            _textField(
              '昵称',
              _nickname,
              maxLen: 30,
              fieldKey: const ValueKey('profile_nickname_field'),
            ),
            SizedBox(height: FacebookSizes.spacing12),
            _textField('个性签名', _signature, maxLen: 80),
            SizedBox(height: FacebookSizes.spacing12),
            _genderField(),
            SizedBox(height: FacebookSizes.spacing12),
            _birthdayField(context),
            SizedBox(height: FacebookSizes.spacing12),
            _textField('地区', _region, maxLen: 60),
            SizedBox(height: FacebookSizes.spacing12),
            _emailField(),
          ],
        ),
      ),
    );
  }

  Widget _avatarSection() {
    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: FacebookColors.primary.withValues(alpha: 0.1),
          backgroundImage: _avatar != null ? MemoryImage(_avatar!) : null,
          child: _avatar == null
              ? const Icon(
                  Icons.person,
                  color: FacebookColors.primary,
                  size: 36,
                )
              : null,
        ),
        SizedBox(width: FacebookSizes.spacing12),
        Wrap(
          spacing: FacebookSizes.spacing8,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.photo),
              label: const Text('选择头像'),
              onPressed: _pickAvatar,
            ),
            if (_avatar != null)
              TextButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text('移除'),
                onPressed: () async {
                  await _repo.clearAvatar();
                  setState(() => _avatar = null);
                },
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickAvatar() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final bytes = result.files.first.bytes;
        if (bytes != null) {
          setState(() => _avatar = bytes);
        }
      }
    } catch (_) {}
  }

  Widget _textField(
    String label,
    TextEditingController c, {
    int? maxLen,
    Key? fieldKey,
  }) {
    return TextFormField(
      key: fieldKey,
      controller: c,
      maxLength: maxLen,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _genderField() {
    return ValueListenableBuilder<String?>(
      valueListenable: _gender,
      builder: (context, value, _) {
        return DropdownButtonFormField<String>(
          initialValue: value,
          items: const [
            DropdownMenuItem(value: 'male', child: Text('男')),
            DropdownMenuItem(value: 'female', child: Text('女')),
            DropdownMenuItem(value: 'other', child: Text('其他')),
          ],
          decoration: const InputDecoration(labelText: '性别'),
          onChanged: (v) => _gender.value = v,
        );
      },
    );
  }

  Widget _birthdayField(BuildContext context) {
    final text = _birthday == null
        ? '选择日期'
        : '${_birthday!.year}-${_birthday!.month.toString().padLeft(2, '0')}-${_birthday!.day.toString().padLeft(2, '0')}';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('生日'),
      subtitle: Text(text),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          lastDate: now,
          initialDate: _birthday ?? DateTime(now.year - 18, now.month, now.day),
        );
        if (picked != null) setState(() => _birthday = picked);
      },
    );
  }

  Widget _emailField() {
    return TextFormField(
      key: const ValueKey('profile_email_field'),
      controller: _email,
      decoration: const InputDecoration(labelText: '邮箱'),
      keyboardType: TextInputType.emailAddress,
      validator: (v) {
        final s = (v ?? '').trim();
        if (s.isEmpty) return null; // 可空
        final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s);
        if (!ok) return '邮箱格式不正确';
        return null;
      },
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    HapticFeedback.selectionClick();
    final profile = UserProfile(
      avatar: _avatar,
      nickname: _nickname.text.trim().isEmpty ? null : _nickname.text.trim(),
      signature: _signature.text.trim().isEmpty ? null : _signature.text.trim(),
      gender: _gender.value,
      birthday: _birthday,
      region: _region.text.trim().isEmpty ? null : _region.text.trim(),
      email: _email.text.trim().isEmpty ? null : _email.text.trim(),
      updatedAt: DateTime.now(),
    );
    final ok = await _repo.upsertProfile(profile);
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('保存成功'),
          backgroundColor: FacebookColors.success,
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('保存失败'),
          backgroundColor: FacebookColors.error,
        ),
      );
    }
  }
}
