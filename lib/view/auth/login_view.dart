import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:tarladan/utility/constants/color_constant.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import 'package:tarladan/utility/enums/icon_constant.dart';
import '../../../viewModel/auth_viewmodel.dart';
import '../../widgets/auth_texfield.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Consumer<AuthViewModel>(
        builder: (context, authViewModel, child) {
          return Stack(
            children: [
              Padding(
                padding: context.padding.normal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthTextfield(
                      controller: _emailController,
                      labelText: StringConstant.mail,
                      icon: const Icon(Icons.mail_outline_outlined),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    context.sized.emptySizedHeightBoxLow,
                    AuthTextfield(
                      controller: _passwordController,
                      labelText: StringConstant.password,
                      keyboardType: TextInputType.visiblePassword,
                      icon: const Icon(Icons.visibility_off),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                    ),
                    context.sized.emptySizedHeightBoxLow3x,
                    _signinButton(authViewModel, context),
                    context.sized.emptySizedHeightBoxLow,
                    _isRegisterButton(context),
                  ],
                ),
              ),
              if (authViewModel.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: IconConstant.loadingBar.toLottie,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(StringConstant.signIn),
      automaticallyImplyLeading: false,
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
      style: const ButtonStyle(
        backgroundColor:
            WidgetStatePropertyAll<Color>(ColorConstant.indigoAccent),
      ),
      onPressed: authViewModel.isLoading
          ? null
          : () async {
              final success = await authViewModel.signIn(
                _emailController.text,
                _passwordController.text,
              );
              if (success) {
                context.route.navigateName('/home');
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
