import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/core/widgets/buttons/custom_button.dart';
import 'package:digify_hr_system/core/widgets/forms/custom_text_field.dart';

/// Example file demonstrating the usage of CustomTextField and CustomButton
///
/// This file is for reference only and should NOT be imported or used in the app.
/// Refer to README_WIDGETS.md for comprehensive documentation.
class WidgetsExampleScreen extends StatefulWidget {
  const WidgetsExampleScreen({super.key});

  @override
  State<WidgetsExampleScreen> createState() => _WidgetsExampleScreenState();
}

class _WidgetsExampleScreenState extends State<WidgetsExampleScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _searchController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _searchController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widgets Example')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========== CustomTextField Examples ==========
              Text(
                'CustomTextField Examples',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 24.h),

              // Standard text field
              CustomTextField(
                controller: _nameController,
                labelText: 'Full Name',
                isRequired: true,
                hintText: 'Enter your full name',
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Name is required';
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Email field
              CustomTextField(
                controller: _emailController,
                labelText: 'Email Address',
                isRequired: true,
                hintText: 'example@company.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Email is required';
                  if (!value!.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Password field
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                isRequired: true,
                obscureText: true,
                hintText: 'Enter your password',
                helperText: 'Must be at least 8 characters',
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Password is required';
                  if (value!.length < 8)
                    return 'Password must be at least 8 characters';
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Phone field with helper text
              CustomTextField(
                controller: _phoneController,
                labelText: 'Phone Number',
                hintText: '+1 (555) 123-4567',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
                helperText: 'Enter a valid phone number with country code',
              ),
              SizedBox(height: 16.h),

              // Search field
              CustomTextField.search(
                controller: _searchController,
                hintText: 'Search employees...',
                onChanged: (value) {
                  // Perform search
                  debugPrint('Searching for: $value');
                },
              ),
              SizedBox(height: 16.h),

              // Multi-line description
              CustomTextField(
                controller: _descriptionController,
                labelText: 'Description',
                hintText: 'Enter description...',
                maxLines: 5,
                minLines: 3,
              ),
              SizedBox(height: 16.h),

              // Read-only date picker field
              CustomTextField(
                controller: _dateController,
                labelText: 'Birth Date',
                isRequired: true,
                readOnly: true,
                hintText: 'Select date',
                suffixIcon: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(),
              ),
              SizedBox(height: 32.h),

              // ========== CustomButton Examples ==========
              Text(
                'CustomButton Examples',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 24.h),

              // Primary button
              CustomButton.primary(
                label: 'Save Changes',
                icon: Icons.save,
                onPressed: _isLoading ? null : () => _handleSave(),
                isLoading: _isLoading,
              ),
              SizedBox(height: 12.h),

              // Secondary button
              CustomButton.secondary(
                label: 'Cancel',
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(height: 12.h),

              // Outlined button
              CustomButton.outlined(
                label: 'Learn More',
                icon: Icons.info_outline,
                onPressed: () => _showInfo(),
              ),
              SizedBox(height: 12.h),

              // Text button
              CustomButton.text(
                label: 'Skip for now',
                onPressed: () => _skip(),
              ),
              SizedBox(height: 12.h),

              // Success button
              CustomButton.success(
                label: 'Approve',
                icon: Icons.check_circle,
                onPressed: () => _approve(),
              ),
              SizedBox(height: 12.h),

              // Danger button
              CustomButton.danger(
                label: 'Delete Account',
                icon: Icons.delete_forever,
                onPressed: () => _deleteAccount(),
              ),
              SizedBox(height: 12.h),

              // Button with SVG icon
              CustomButton(
                label: 'Import Data',
                svgIcon: 'assets/icons/bulk_upload_icon_figma.svg',
                onPressed: () => _import(),
                backgroundColor: const Color(0xFFE7F2FF),
                foregroundColor: const Color(0xFF155DFC),
              ),
              SizedBox(height: 12.h),

              // Row of buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton.outlined(
                      label: 'Cancel',
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomButton.primary(
                      label: 'Continue',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Icon-only buttons
              Row(
                children: [
                  CustomButton.icon(icon: Icons.edit, onPressed: () => _edit()),
                  SizedBox(width: 12.w),
                  CustomButton.icon(
                    icon: Icons.delete,
                    onPressed: () => _delete(),
                    variant: ButtonVariant.danger,
                  ),
                  SizedBox(width: 12.w),
                  CustomButton.icon(
                    icon: Icons.share,
                    onPressed: () => _share(),
                    variant: ButtonVariant.secondary,
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Different sizes
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomButton(
                    label: 'Small Button',
                    size: ButtonSize.small,
                    onPressed: () {},
                  ),
                  SizedBox(height: 8.h),
                  CustomButton(
                    label: 'Medium Button (Default)',
                    size: ButtonSize.medium,
                    onPressed: () {},
                  ),
                  SizedBox(height: 8.h),
                  CustomButton(
                    label: 'Large Button',
                    size: ButtonSize.large,
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Expanded button (full width)
              CustomButton(
                label: 'Submit Form',
                icon: Icons.send,
                isExpanded: true,
                showShadow: true,
                onPressed: () => _submitForm(),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  // Example methods
  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Saved successfully!')));
      }
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      _dateController.text = '${date.day}/${date.month}/${date.year}';
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Form submitted!')));
    }
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Information'),
        content: const Text('This is an example of CustomButton usage.'),
        actions: [
          CustomButton.text(
            label: 'Close',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _skip() => debugPrint('Skipped');
  void _approve() => debugPrint('Approved');
  void _deleteAccount() => debugPrint('Delete account');
  void _import() => debugPrint('Import data');
  void _edit() => debugPrint('Edit');
  void _delete() => debugPrint('Delete');
  void _share() => debugPrint('Share');
}
