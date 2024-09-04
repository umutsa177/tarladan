import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:tarladan/utility/enums/double_constant.dart';
import 'package:tarladan/utility/enums/fontsize_constant.dart';
import 'package:tarladan/utility/enums/fontweight_constant.dart';
import 'package:tarladan/utility/enums/icon_constant.dart';
import '../../model/user.dart';
import '../../service/auth_service.dart';
import '../../utility/constants/string_constant.dart';
import '../../utility/constants/color_constant.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthService _authService = AuthService();
  AppUser? _user;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var firebaseUser = await _authService.getCurrentUser();
    if (firebaseUser != null) {
      var appUser = await _authService.getAppUser(firebaseUser.uid);
      setState(() {
        _user = appUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _user == null
          ? Center(child: IconConstant.loadingBar.toLottie)
          : RefreshIndicator(
              onRefresh: _loadUserData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    _buildProfileInfo(),
                    _buildProfileActions(),
                  ],
                ),
              ),
            ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text(StringConstant.profile),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () => _showLogoutDialog(context),
        ),
      ],
      leading: IconButton(
          onPressed: () => context.route.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded)),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: context.padding.verticalMedium,
      decoration: BoxDecoration(
        borderRadius: context.border.normalBorderRadius,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ColorConstant.black, ColorConstant.black.withOpacity(0.8)],
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: DoubleConstant.verticalOffset.value,
            backgroundColor: ColorConstant.white,
            child: Text(
              _user?.name
                      .substring(DoubleConstant.offsetdy.value.toInt(),
                          DoubleConstant.one.value.toInt())
                      .toUpperCase() ??
                  '?',
              style: TextStyle(
                fontSize: FontSizeConstant.forty.value,
                color: ColorConstant.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _user?.name ?? StringConstant.unknown,
            style: TextStyle(
              fontSize: FontSizeConstant.twentyFour.value,
              color: ColorConstant.white,
              fontWeight: FontWeightConstant.bold.value,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _user?.email ?? StringConstant.unknown,
            style: TextStyle(
              fontSize: FontSizeConstant.sixteen.value,
              color: ColorConstant.greyBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: context.padding.normal,
      child: Column(
        children: [
          _buildInfoTile(Icons.person, StringConstant.nameSurname,
              _user?.name ?? StringConstant.unknown),
          _buildInfoTile(Icons.email, StringConstant.mail,
              _user?.email ?? StringConstant.unknown),
          _buildInfoTile(Icons.phone, StringConstant.phone,
              _user?.phoneNumber ?? StringConstant.unknown),
          _buildInfoTile(Icons.badge, StringConstant.role,
              _user?.role ?? StringConstant.unknown),
          _buildPasswordTile(),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: ColorConstant.grey),
      title: Text(
        title,
        style: TextStyle(
          fontSize: FontSizeConstant.sixteen.value,
          fontWeight: FontWeightConstant.bold.value,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(fontSize: FontSizeConstant.sixteen.value),
      ),
    );
  }

  Widget _buildPasswordTile() {
    return ListTile(
      leading: Icon(
        _isPasswordVisible ? Icons.lock_open : Icons.lock,
        color: ColorConstant.grey,
      ),
      title: Text(
        StringConstant.password,
        style: TextStyle(
          fontSize: FontSizeConstant.sixteen.value,
          fontWeight: FontWeightConstant.bold.value,
        ),
      ),
      subtitle: Text(
        _isPasswordVisible ? (_user?.password ?? '******') : '******',
        style: TextStyle(fontSize: FontSizeConstant.sixteen.value),
      ),
      trailing: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          color: ColorConstant.grey,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      ),
    );
  }

  Widget _buildProfileActions() {
    return Padding(
      padding: context.padding.normal,
      child: Column(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text(StringConstant.editProfile),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.black,
              minimumSize: Size(context.sized.width,
                  context.sized.width / DoubleConstant.seven.value),
            ),
            onPressed: () => _navigateToEditProfile(context),
          ),
          SizedBox(height: context.sized.normalValue),
        ],
      ),
    );
  }

  Future<void> _navigateToEditProfile(BuildContext context) async {
    final result = await context.route.navigateName('/edit_profile');
    if (result == true) {
      await _loadUserData();
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(StringConstant.exit),
          content: const Text(StringConstant.areYouSureToExit),
          actions: [
            TextButton(
              child: const Text(StringConstant.cancel),
              onPressed: () => context.route.pop(),
            ),
            TextButton(
              child: const Text(StringConstant.exit),
              onPressed: () async {
                await _authService.signOut();
                context.route.pop();
                context.route.navigateName("/login");
              },
            ),
          ],
        );
      },
    );
  }
}
