import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:tarladan/utility/constants/color_constant.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import 'package:tarladan/utility/enums/icon_constant.dart';
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
  final TextEditingController _phoneController = TextEditingController();
  String selectedRole = StringConstant.customer;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: _appBar(),
      body: Stack(
        children: [
          Padding(
            padding: context.padding.normal,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthTextfield(
                      icon: const Icon(Icons.person),
                      labelText: StringConstant.nameSurname,
                      keyboardType: TextInputType.name,
                      controller: _nameController,
                    ),
                    context.sized.emptySizedHeightBoxLow,
                    AuthTextfield(
                      icon: const Icon(Icons.phone),
                      controller: _phoneController,
                      labelText: StringConstant.phoneNumber,
                      keyboardType: TextInputType.phone,
                    ),
                    context.sized.emptySizedHeightBoxLow,
                    AuthTextfield(
                      icon: const Icon(Icons.mail_outline_rounded),
                      controller: _emailController,
                      labelText: StringConstant.mail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    context.sized.emptySizedHeightBoxLow,
                    AuthTextfield(
                      icon: const Icon(Icons.visibility_off),
                      controller: _passwordController,
                      labelText: StringConstant.password,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                    ),
                    context.sized.emptySizedHeightBoxLow,
                    _selectRoleButton(),
                    context.sized.emptySizedHeightBoxLow,
                    _signupButton(authViewModel, context),
                    context.sized.emptySizedHeightBoxLow,
                    _isLoginButton(context),
                  ],
                ),
              ),
            ),
          ),
          if (authViewModel.isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: IconConstant.loadingBar.toLottie,
                ),
              ),
            ),
        ],
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
      style: const ButtonStyle(
        backgroundColor:
            WidgetStatePropertyAll<Color>(ColorConstant.indigoAccent),
      ),
      onPressed: authViewModel.isLoading
          ? null
          : () async {
              authViewModel.setLoading(true);
              final success = await authViewModel.register(
                _nameController.text,
                _emailController.text,
                _passwordController.text,
                selectedRole,
                _phoneController.text,
              );
              authViewModel.setLoading(false);
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
      child: Text(authViewModel.isLoading
          ? StringConstant.loading
          : StringConstant.signUp),
    );
  }
}
