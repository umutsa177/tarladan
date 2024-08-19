import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:tarladan/utility/constants/color_constant.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import '../../viewModel/auth_viewmodel.dart';
import '../../widgets/auth_texfield.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String selectedRole = StringConstant.customer;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: context.padding.normal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AuthTextfield(
                icon: const Icon(Icons.person),
                labelText: StringConstant.nameSurname,
                controller: _nameController),
            context.sized.emptySizedHeightBoxLow,
            AuthTextfield(
              icon: const Icon(Icons.mail_outline_rounded),
              controller: _emailController,
              labelText: StringConstant.mail,
            ),
            context.sized.emptySizedHeightBoxLow,
            AuthTextfield(
              icon: const Icon(Icons.visibility_outlined),
              controller: _passwordController,
              labelText: StringConstant.password,
            ),
            context.sized.emptySizedHeightBoxLow,
            _selectRoleButton(),
            context.sized.emptySizedHeightBoxLow3x,
            _signupButton(authViewModel, context),
            context.sized.emptySizedHeightBoxLow,
            _isLoginButton(context),
          ],
        ),
      ),
    );
  }

  DropdownButton<String> _selectRoleButton() {
    return DropdownButton<String>(
      value: selectedRole,
      items: [(StringConstant.customer), (StringConstant.seller)]
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value == StringConstant.customer
                ? StringConstant.customer
                : StringConstant.seller,
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            selectedRole = newValue;
          });
        }
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(StringConstant.signUp),
      automaticallyImplyLeading: false,
    );
  }

  TextButton _isLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () => context.route.navigateName("/login"),
      child: const Text(StringConstant.noSignAccountText),
    );
  }

  ElevatedButton _signupButton(
      AuthViewModel authViewModel, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final success = await authViewModel.register(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          selectedRole,
        );
        if (success) {
          context.route.navigateName("/login");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                StringConstant.loginFailed,
                style: TextStyle(color: ColorConstant.redAccent),
              ),
            ),
          );
        }
      },
      child: const Text(StringConstant.signUp),
    );
  }
}
