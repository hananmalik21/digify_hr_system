# Quick Reference Guide - CustomTextField & CustomButton

## 🔍 Quick Lookup

### CustomTextField - Common Patterns

| Use Case | Code |
|----------|------|
| **Basic Input** | `CustomTextField(controller: ctrl, labelText: 'Name')` |
| **Required Field** | `CustomTextField(controller: ctrl, labelText: 'Email', isRequired: true)` |
| **Search Field** | `CustomTextField.search(controller: ctrl, hintText: 'Search...')` |
| **Password** | `CustomTextField(controller: ctrl, obscureText: true)` |
| **Multi-line** | `CustomTextField(controller: ctrl, maxLines: 5)` |
| **Read-only/Date** | `CustomTextField(controller: ctrl, readOnly: true, onTap: () => pickDate())` |
| **With Icon** | `CustomTextField(controller: ctrl, prefixIcon: Icon(Icons.email))` |
| **With Validation** | `CustomTextField(controller: ctrl, validator: (v) => v?.isEmpty ?? true ? 'Required' : null)` |
| **With Helper Text** | `CustomTextField(controller: ctrl, helperText: 'Enter valid email')` |

### CustomButton - Common Patterns

| Use Case | Code |
|----------|------|
| **Primary Action** | `CustomButton.primary(label: 'Save', onPressed: () => save())` |
| **Secondary Action** | `CustomButton.secondary(label: 'Cancel', onPressed: () => cancel())` |
| **Outlined** | `CustomButton.outlined(label: 'Learn More', onPressed: () {})` |
| **Text Button** | `CustomButton.text(label: 'Skip', onPressed: () {})` |
| **Danger/Delete** | `CustomButton.danger(label: 'Delete', onPressed: () => delete())` |
| **Success** | `CustomButton.success(label: 'Approve', onPressed: () => approve())` |
| **With Icon** | `CustomButton(label: 'Add', icon: Icons.add, onPressed: () {})` |
| **Icon Only** | `CustomButton.icon(icon: Icons.edit, onPressed: () => edit())` |
| **With SVG** | `CustomButton(label: 'Import', svgIcon: 'assets/icons/upload.svg', onPressed: () {})` |
| **Loading** | `CustomButton(label: 'Submit', isLoading: true, onPressed: () {})` |
| **Disabled** | `CustomButton(label: 'Submit', onPressed: null)` |
| **Full Width** | `CustomButton(label: 'Continue', isExpanded: true, onPressed: () {})` |
| **With Shadow** | `CustomButton(label: 'Add', showShadow: true, onPressed: () {})` |
| **Small Size** | `CustomButton(label: 'Small', size: ButtonSize.small, onPressed: () {})` |
| **Large Size** | `CustomButton(label: 'Large', size: ButtonSize.large, onPressed: () {})` |

---

## 🎨 Visual Button Variants

```dart
// PRIMARY - Blue background, white text
CustomButton.primary(label: 'Primary', onPressed: () {})

// SECONDARY - Grey background, dark text
CustomButton.secondary(label: 'Secondary', onPressed: () {})

// OUTLINED - Transparent background, blue border
CustomButton.outlined(label: 'Outlined', onPressed: () {})

// TEXT - No background, blue text
CustomButton.text(label: 'Text', onPressed: () {})

// DANGER - Red background, white text
CustomButton.danger(label: 'Delete', onPressed: () {})

// SUCCESS - Green background, white text
CustomButton.success(label: 'Approve', onPressed: () {})
```

---

## 📱 Responsive Sizing (Already Built-in!)

Both widgets automatically use ScreenUtil:
- ✅ No need to add `.sp`, `.w`, `.h`, `.r` manually
- ✅ All dimensions are responsive by default
- ✅ Works perfectly on all screen sizes

---

## 🌓 Theme Support (Already Built-in!)

Both widgets automatically support light/dark themes:
- ✅ Colors adapt to current theme
- ✅ Text colors adjust automatically
- ✅ Border colors change with theme
- ✅ No manual theme handling needed

---

## 🌍 RTL Support (Already Built-in!)

Both widgets support Right-to-Left (Arabic):
- ✅ EdgeInsetsDirectional used throughout
- ✅ Icon positions adjust automatically
- ✅ Layouts flip correctly
- ✅ No manual RTL handling needed

---

## 🔄 Migration Cheat Sheet

### TextField Migration

| ❌ Old | ✅ New |
|--------|--------|
| `TextField(...)` | `CustomTextField(...)` |
| `TextFormField(...)` | `CustomTextField(...)` |
| Any custom text field widget | `CustomTextField(...)` |

### Button Migration

| ❌ Old | ✅ New |
|--------|--------|
| `ElevatedButton(...)` | `CustomButton.primary(...)` |
| `TextButton(...)` | `CustomButton.text(...)` |
| `OutlinedButton(...)` | `CustomButton.outlined(...)` |
| `IconButton(...)` | `CustomButton.icon(...)` |
| `ImportButton(...)` | `CustomButton(..., svgIcon: 'assets/icons/bulk_upload_icon_figma.svg')` |
| `ExportButton(...)` | `CustomButton(..., svgIcon: 'assets/icons/download_icon.svg')` |
| `GradientIconButton(...)` | `CustomButton(..., showShadow: true)` |

---

## 🎯 Form Example

```dart
class MyForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _nameController,
            labelText: 'Full Name',
            isRequired: true,
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: _emailController,
            labelText: 'Email',
            isRequired: true,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v?.isEmpty ?? true) return 'Required';
              if (!v!.contains('@')) return 'Invalid email';
              return null;
            },
          ),
          SizedBox(height: 24.h),
          CustomButton.primary(
            label: 'Submit',
            isExpanded: true,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Submit form
              }
            },
          ),
        ],
      ),
    );
  }
}
```

---

## 🎨 Button Combinations

### Action Buttons (Side by Side)
```dart
Row(
  children: [
    Expanded(
      child: CustomButton.outlined(
        label: 'Cancel',
        onPressed: () => Navigator.pop(context),
      ),
    ),
    SizedBox(width: 12.w),
    Expanded(
      child: CustomButton.primary(
        label: 'Save',
        onPressed: () => save(),
      ),
    ),
  ],
)
```

### Icon Buttons Row
```dart
Row(
  children: [
    CustomButton.icon(icon: Icons.edit, onPressed: () => edit()),
    SizedBox(width: 8.w),
    CustomButton.icon(icon: Icons.delete, variant: ButtonVariant.danger, onPressed: () => delete()),
    SizedBox(width: 8.w),
    CustomButton.icon(icon: Icons.share, variant: ButtonVariant.secondary, onPressed: () => share()),
  ],
)
```

### Import/Export Buttons
```dart
Row(
  children: [
    CustomButton(
      label: 'Import',
      svgIcon: 'assets/icons/bulk_upload_icon_figma.svg',
      onPressed: () => import(),
      backgroundColor: const Color(0xFFE7F2FF),
      foregroundColor: const Color(0xFF155DFC),
    ),
    SizedBox(width: 12.w),
    CustomButton(
      label: 'Export',
      svgIcon: 'assets/icons/download_icon.svg',
      onPressed: () => export(),
      backgroundColor: const Color(0xFF4A5565),
      foregroundColor: Colors.white,
    ),
  ],
)
```

---

## 💡 Pro Tips

### CustomTextField
1. Always provide a controller for state management
2. Use `isRequired: true` for mandatory fields
3. Always add validation for user input
4. Use `helperText` to guide users
5. Use `.search()` factory for search fields
6. Set `readOnly: true` + `onTap` for date/time pickers

### CustomButton
1. Use factory constructors (`.primary()`, `.secondary()`, etc.)
2. Set `isLoading: true` during async operations
3. Pass `null` to `onPressed` to disable
4. Use `isExpanded: true` for full-width buttons
5. Use appropriate variants for action types:
   - Primary → Main actions (Save, Submit, Continue)
   - Secondary → Cancel, Back
   - Danger → Delete, Remove
   - Success → Approve, Confirm
   - Text → Skip, Learn More
   - Outlined → Alternative actions
6. Add icons to improve clarity
7. Use `showShadow: true` for floating action buttons

---

## 📚 Full Documentation

For complete documentation, see:
- **Comprehensive Guide:** `lib/core/widgets/README_WIDGETS.md`
- **Examples:** `lib/core/widgets/widgets_example.dart`
- **Summary:** `STANDARDIZED_WIDGETS_SUMMARY.md`

---

## ⚠️ Remember

**ONE TextField Widget, ONE Button Widget - Used Everywhere! 🎯**

- ❌ Don't create new text field or button widgets
- ❌ Don't use TextField, TextFormField, ElevatedButton, etc. directly
- ✅ Always use CustomTextField
- ✅ Always use CustomButton
- ✅ Customize using the extensive parameters available

---

*Quick Reference Guide - Print this for your desk! 📄*

