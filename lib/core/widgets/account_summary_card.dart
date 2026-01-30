import "package:flutter/material.dart";

import "../constants/app_strings.dart";
import "../models/enums.dart";
import "../models/user_lite.dart";

class AccountSummaryCard extends StatelessWidget {
  const AccountSummaryCard({super.key, required this.user, this.onLogout});

  final UserLite? user;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final displayName = user?.name.isNotEmpty == true ? user!.name : "Chưa cập nhật";
    final phone = user?.phone.isNotEmpty == true ? user!.phone : "Chưa cập nhật";
    final role = user?.role ?? UserRole.worker;
    final province = user?.province ?? Province.anGiang;
    final district = user?.district.isNotEmpty == true ? user!.district : "Chưa cập nhật";

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tài khoản", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _InfoRow(label: "Họ tên", value: displayName),
            _InfoRow(label: "Số điện thoại", value: phone),
            _InfoRow(label: "Vai trò", value: _roleLabel(role)),
            _InfoRow(label: "Tỉnh", value: _provinceLabel(province)),
            _InfoRow(label: "Huyện/TP", value: district),
            if (onLogout != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout),
                  label: const Text(AppStrings.logoutButton),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _roleLabel(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AppStrings.adminRole;
      case UserRole.poster:
        return AppStrings.posterRole;
      case UserRole.worker:
        return AppStrings.workerRole;
    }
  }

  String _provinceLabel(Province province) {
    switch (province) {
      case Province.anGiang:
        return AppStrings.provinceAnGiang;
      case Province.kienGiang:
        return AppStrings.provinceKienGiang;
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
