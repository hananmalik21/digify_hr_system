import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_banking_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class BankingInfoModule extends ConsumerWidget {
  const BankingInfoModule({super.key});

  static Widget _prefixIcon(BuildContext context, String path, bool isDark) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: DigifyAsset(
        assetPath: path,
        width: 20,
        height: 20,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(addEmployeeBankingProvider);
    final notifier = ref.read(addEmployeeBankingProvider.notifier);
    final em = Assets.icons.employeeManagement;
    final bankIcon = _prefixIcon(context, em.banking.path, isDark);
    final cardIcon = _prefixIcon(context, em.card.path, isDark);

    final bankCodeField = DigifyTextField(
      labelText: localizations.bankName,
      isRequired: true,
      prefixIcon: bankIcon,
      hintText: localizations.hintBankName,
      initialValue: state.bankCode ?? '',
      onChanged: notifier.setBankCode,
    );
    final accountNumberField = DigifyTextField(
      labelText: localizations.accountNumber,
      isRequired: true,
      prefixIcon: cardIcon,
      hintText: localizations.hintAccountNumber,
      initialValue: state.accountNumber ?? '',
      onChanged: notifier.setAccountNumber,
    );
    final iban = DigifyTextField(labelText: localizations.iban, prefixIcon: cardIcon, hintText: localizations.hintIban);

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useTwoColumns = constraints.maxWidth > 500;
          if (useTwoColumns) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.h,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: bankCodeField),
                    Gap(14.w),
                    Expanded(child: accountNumberField),
                  ],
                ),
                iban,
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.h,
            children: [bankCodeField, accountNumberField, iban],
          );
        },
      ),
    );
  }
}
