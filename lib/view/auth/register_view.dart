import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/auth_viewmodel.dart';

class RegisterView extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    String selectedRole = 'customer';

    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Ad Soyad'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-posta'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedRole,
              items: ['customer', 'seller'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value == 'customer' ? 'Müşteri' : 'Satıcı'),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  selectedRole = newValue;
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final success = await authViewModel.register(
                  _nameController.text,
                  _emailController.text,
                  _passwordController.text,
                  selectedRole,
                );
                if (success) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kayıt başarısız')),
                  );
                }
              },
              child: const Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}
