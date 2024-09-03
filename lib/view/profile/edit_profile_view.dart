import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import '../../service/auth_service.dart';
import '../../utility/constants/string_constant.dart';
import '../../utility/constants/color_constant.dart';
import '../../viewModel/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  late TextEditingController _nameController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthViewModel>(context, listen: false).currentUser;
    _nameController = TextEditingController(text: user?.name);
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        padding: context.padding.normal,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildNameField(),
              const SizedBox(height: 20),
              _buildCurrentPasswordField(),
              const SizedBox(height: 20),
              _buildNewPasswordField(),
              const SizedBox(height: 20),
              _buildConfirmPasswordField(),
              const SizedBox(height: 30),
              _saveChangesButton(),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _saveChangesButton() {
    return ElevatedButton(
      onPressed: _updateProfile,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstant.black,
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: const Text(StringConstant.saveChanges),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text(StringConstant.editProfile),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => context.route.pop(),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: StringConstant.nameSurname,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen isminizi giriniz';
        }
        return null;
      },
    );
  }

  Widget _buildCurrentPasswordField() {
    return TextFormField(
      controller: _currentPasswordController,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Mevcut Şifre',
        border: OutlineInputBorder(),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen mevcut şifrenizi giriniz';
        }
        return null;
      },
    );
  }

  Widget _buildNewPasswordField() {
    return TextFormField(
      controller: _newPasswordController,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Yeni Şifre',
        border: OutlineInputBorder(),
      ),
      obscureText: true,
      validator: (value) {
        if (value != null && value.isNotEmpty && value.length < 6) {
          return 'Şifre en az 6 karakter olmalıdır';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        labelText: 'Yeni Şifre (Tekrar)',
        border: OutlineInputBorder(),
      ),
      obscureText: true,
      validator: (value) {
        if (value != _newPasswordController.text) {
          return 'Şifreler eşleşmiyor';
        }
        return null;
      },
    );
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final authViewModel =
            Provider.of<AuthViewModel>(context, listen: false);
        final user = authViewModel.currentUser;

        if (user != null) {
          if (_nameController.text != user.name) {
            await _authService.updateUserProfile(user.id, _nameController.text);
          }

          if (_newPasswordController.text.isNotEmpty) {
            await _authService.changePassword(
              _currentPasswordController.text,
              _newPasswordController.text,
            );
          }

          await authViewModel.refreshUser();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil başarıyla güncellendi')),
          );
          context.route.pop(true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: ${e.toString()}')),
        );
      }
    }
  }
}
