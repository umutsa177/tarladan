import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import '../../model/user.dart';
import '../../service/auth_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthService _authService = AuthService();
  AppUser? _user;

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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await _authService.signOut();
              context.route.navigateName("/login");
            },
          ),
        ],
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ad: ${_user?.name ?? "bilinmiyor"}',
                      style: const TextStyle(fontSize: 18)),
                  context.sized.emptySizedHeightBoxLow,
                  Text('E-posta: ${_user?.email ?? "bilinmiyor"}',
                      style: const TextStyle(fontSize: 18)),
                  context.sized.emptySizedHeightBoxLow,
                  Text('Rol: ${_user?.role ?? "bilinmiyor"}',
                      style: const TextStyle(fontSize: 18)),
                  context.sized.emptySizedHeightBoxLow3x,
                  ElevatedButton(
                    child: const Text('Profili Düzenle'),
                    onPressed: () {
                      // Profil düzenleme sayfasına yönlendirme yapılabilir
                      // Navigator.of(context).pushNamed('/edit-profile');
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
