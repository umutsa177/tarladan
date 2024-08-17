import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:tarladan/utility/constants/color_constant.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import '../../../viewModel/auth_viewmodel.dart';
import '../../widgets/auth_texfield.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstant.signIn),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: context.padding.normal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AuthTextfield(
              controller: _emailController,
              labelText: StringConstant.mail,
              icon: const Icon(Icons.mail_outline_outlined),
            ),
            context.sized.emptySizedHeightBoxLow,
            AuthTextfield(
              controller: _passwordController,
              labelText: StringConstant.password,
              icon: const Icon(Icons.visibility),
            ),
            context.sized.emptySizedHeightBoxLow3x,
            _signinButton(authViewModel, context),
            context.sized.emptySizedHeightBoxLow,
            _isRegisterButton(context),
          ],
        ),
      ),
    );
  }

  TextButton _isRegisterButton(BuildContext context) {
    return TextButton(
      onPressed: () => context.route.navigateName("/register"),
      child: const Text(StringConstant.noLoginAccountText),
    );
  }

  ElevatedButton _signinButton(
      AuthViewModel authViewModel, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final success = await authViewModel.signIn(
          _emailController.text,
          _passwordController.text,
        );
        if (success) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
              StringConstant.signInFailed,
              style: TextStyle(
                color: ColorConstant.redAccent,
              ),
            )),
          );
        }
      },
      child: const Text(StringConstant.signIn),
    );
  }
}
