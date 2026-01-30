import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../../core/constants/app_routes.dart";
import "../../../core/constants/app_strings.dart";
import "../../../core/models/enums.dart";
import "../../../core/widgets/snackbars.dart";
import "../controllers/auth_controller.dart";

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _districtController = TextEditingController();

  UserRole _role = UserRole.worker;
  Province _province = Province.anGiang;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final message = await ref.read(authControllerProvider).register(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
          role: _role,
          province: _province,
          district: _districtController.text.trim(),
        );
    if (!mounted || message == null) {
      return;
    }
    showErrorSnackBar(context, message);
  }

  void _goToLogin() {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.registerTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: AppStrings.nameLabel),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: AppStrings.phoneLabel),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: AppStrings.passwordLabel),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration:
                const InputDecoration(labelText: AppStrings.confirmPasswordLabel),
          ),
          const SizedBox(height: 16),
          Text(AppStrings.roleLabel,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<UserRole>(
            segments: const [
              ButtonSegment(
                value: UserRole.worker,
                label: Text(AppStrings.workerRole),
              ),
              ButtonSegment(
                value: UserRole.poster,
                label: Text(AppStrings.posterRole),
              ),
            ],
            selected: {_role},
            onSelectionChanged: (roles) {
              setState(() {
                _role = roles.first;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Province>(
            value: _province,
            decoration: const InputDecoration(labelText: AppStrings.provinceLabel),
            items: const [
              DropdownMenuItem<Province>(
                value: Province.anGiang,
                child: Text(AppStrings.provinceAnGiang),
              ),
              DropdownMenuItem<Province>(
                value: Province.kienGiang,
                child: Text(AppStrings.provinceKienGiang),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _province = value;
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _districtController,
            decoration: const InputDecoration(labelText: AppStrings.districtLabel),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleRegister,
            child: const Text(AppStrings.registerButton),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _goToLogin,
            child: const Text(AppStrings.goToLogin),
          ),
        ],
      ),
    );
  }
}
