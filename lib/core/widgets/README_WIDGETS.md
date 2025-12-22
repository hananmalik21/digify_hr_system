# Core Widgets Usage Guide

This document provides comprehensive guidelines for using the standardized core widgets across the entire app.

## Table of Contents
1. [CustomTextField - The Only Text Field Widget](#customtextfield)
2. [CustomButton - The Only Button Widget](#custombutton)
3. [Migration Guide](#migration-guide)

---

## CustomTextField

**Location:** `lib/core/widgets/custom_text_field.dart`

### Overview
`CustomTextField` is the **ONLY** text field widget that should be used throughout the entire app. It provides a consistent, theme-aware, and fully responsive text input solution.

### Features
- ✅ Full ScreenUtil support for responsive sizing
- ✅ Light & Dark theme support with proper color handling
- ✅ RTL (Arabic) support via EdgeInsetsDirectional
- ✅ Built-in validation support
- ✅ Password field with visibility toggle
- ✅ Label with required indicator and info icon
- ✅ Helper text and error text
- ✅ Search field factory
- ✅ Read-only/Date picker support
- ✅ Multi-line support
- ✅ Full customization options

### Basic Usage

```dart
// Standard text field
CustomTextField(
  controller: nameController,
  hintText: 'Enter your name',
)

// With label and validation
CustomTextField(
  controller: emailController,
  labelText: 'Email Address',
  isRequired: true,
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Email is required';
    return null;
  },
)

// Search field
CustomTextField.search(
  controller: searchController,
  hintText: 'Search employees...',
  onChanged: (value) => performSearch(value),
)

// Password field
CustomTextField(
  controller: passwordController,
  labelText: 'Password',
  obscureText: true,
  isRequired: true,
)

// Multi-line text area
CustomTextField(
  controller: descriptionController,
  labelText: 'Description',
  maxLines: 5,
  minLines: 3,
)

// Read-only/Date picker
CustomTextField(
  controller: dateController,
  labelText: 'Birth Date',
  readOnly: true,
  onTap: () => _selectDate(context),
  suffixIcon: Icon(Icons.calendar_today),
)

// With helper text
CustomTextField(
  controller: phoneController,
  labelText: 'Phone Number',
  helperText: 'Enter a valid 10-digit phone number',
  keyboardType: TextInputType.phone,
)
```

### All Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `controller` | TextEditingController? | null | Text field controller |
| `hintText` | String? | null | Placeholder text |
| `labelText` | String? | null | Label above the field |
| `obscureText` | bool | false | Hide text (for passwords) |
| `prefixIcon` | Widget? | null | Icon at the start |
| `suffixIcon` | Widget? | null | Icon at the end |
| `keyboardType` | TextInputType? | null | Keyboard type |
| `validator` | String? Function(String?)? | null | Validation function |
| `maxLines` | int? | 1 | Maximum lines |
| `minLines` | int? | null | Minimum lines |
| `height` | double? | null | Fixed height (optional) |
| `borderRadius` | double? | 8.r | Border radius |
| `fontSize` | double? | 13.7.sp | Font size |
| `fillColor` | Color? | Theme-based | Background color |
| `borderColor` | Color? | Theme-based | Border color |
| `focusedBorderColor` | Color? | AppColors.primary | Focused border color |
| `filled` | bool | true | Fill background |
| `textInputAction` | TextInputAction? | null | Keyboard action button |
| `showBorder` | bool | true | Show border |
| `onChanged` | ValueChanged<String>? | null | Called when text changes |
| `onSubmitted` | ValueChanged<String>? | null | Called on submit |
| `isRequired` | bool | false | Show asterisk on label |
| `hasInfoIcon` | bool | false | Show info icon on label |
| `helperText` | String? | null | Helper text below field |
| `errorText` | String? | null | Error text below field |
| `labelStyle` | TextStyle? | null | Custom label style |
| `helperTextStyle` | TextStyle? | null | Custom helper text style |
| `hintStyle` | TextStyle? | null | Custom hint text style |
| `textStyle` | TextStyle? | null | Custom text style |
| `expands` | bool | false | Expand to fill parent |
| `initialValue` | String? | null | Initial value |
| `readOnly` | bool | false | Read-only mode |
| `onTap` | VoidCallback? | null | Called on tap |
| `enabled` | bool | true | Enable/disable field |
| `contentPadding` | EdgeInsetsGeometry? | null | Custom padding |
| `maxLength` | int? | null | Maximum characters |
| `inputFormatters` | List<TextInputFormatter>? | null | Input formatters |
| `focusNode` | FocusNode? | null | Focus node |
| `autovalidateMode` | AutovalidateMode? | null | Auto validation mode |

---

## CustomButton

**Location:** `lib/core/widgets/custom_button.dart`

### Overview
`CustomButton` is the **ONLY** button widget that should be used throughout the entire app. It replaces all existing button widgets (ImportButton, ExportButton, GradientIconButton, etc.).

### Features
- ✅ Full ScreenUtil support for responsive sizing
- ✅ Light & Dark theme support
- ✅ 8 button variants (primary, secondary, outlined, text, danger, success, icon, gradient)
- ✅ 3 size options (small, medium, large)
- ✅ Icon support (Material Icons or SVG)
- ✅ Loading state with spinner
- ✅ Disabled state handling
- ✅ Optional shadow effects
- ✅ Full customization options
- ✅ Factory constructors for common use cases

### Button Variants

1. **Primary** - Main action buttons (blue)
2. **Secondary** - Secondary actions (grey)
3. **Outlined** - Bordered with transparent background
4. **Text** - Text-only buttons, no background
5. **Danger** - Destructive actions (red)
6. **Success** - Success/confirmation actions (green)
7. **Icon** - Icon-only buttons
8. **Gradient** - Custom gradient buttons

### Basic Usage

```dart
// Primary button
CustomButton(
  label: 'Save Changes',
  onPressed: () => save(),
)

// Or using factory
CustomButton.primary(
  label: 'Save Changes',
  onPressed: () => save(),
)

// Secondary button
CustomButton.secondary(
  label: 'Cancel',
  onPressed: () => Navigator.pop(context),
)

// Outlined button
CustomButton.outlined(
  label: 'Learn More',
  onPressed: () => showInfo(),
)

// Text button
CustomButton.text(
  label: 'Skip',
  onPressed: () => skip(),
)

// Danger button (destructive actions)
CustomButton.danger(
  label: 'Delete Account',
  icon: Icons.delete,
  onPressed: () => deleteAccount(),
)

// Success button
CustomButton.success(
  label: 'Approve',
  icon: Icons.check,
  onPressed: () => approve(),
)

// Icon-only button
CustomButton.icon(
  icon: Icons.edit,
  onPressed: () => edit(),
)

// Button with SVG icon
CustomButton(
  label: 'Import',
  svgIcon: 'assets/icons/bulk_upload_icon_figma.svg',
  onPressed: () => import(),
  backgroundColor: const Color(0xFFE7F2FF),
  foregroundColor: const Color(0xFF155DFC),
)

// Loading button
CustomButton(
  label: 'Submitting...',
  isLoading: true,
  onPressed: () {}, // Will be disabled during loading
)

// Disabled button
CustomButton(
  label: 'Submit',
  onPressed: null, // null = disabled
)

// Expanded button (full width)
CustomButton(
  label: 'Continue',
  isExpanded: true,
  onPressed: () => continue_(),
)

// Different sizes
CustomButton(
  label: 'Small',
  size: ButtonSize.small,
  onPressed: () {},
)

CustomButton(
  label: 'Medium (default)',
  size: ButtonSize.medium,
  onPressed: () {},
)

CustomButton(
  label: 'Large',
  size: ButtonSize.large,
  onPressed: () {},
)

// With shadow effect
CustomButton(
  label: 'Add New',
  showShadow: true,
  onPressed: () => addNew(),
)

// Icon on right side
CustomButton(
  label: 'Next',
  icon: Icons.arrow_forward,
  iconPosition: IconPosition.right,
  onPressed: () => next(),
)
```

### All Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `label` | String? | null | Button text |
| `onPressed` | VoidCallback? | **required** | Callback (null = disabled) |
| `variant` | ButtonVariant | primary | Button variant/style |
| `size` | ButtonSize | medium | Button size |
| `icon` | IconData? | null | Material icon |
| `svgIcon` | String? | null | SVG icon asset path |
| `isLoading` | bool | false | Show loading spinner |
| `isExpanded` | bool | false | Full width |
| `backgroundColor` | Color? | null | Custom background color |
| `foregroundColor` | Color? | null | Custom text/icon color |
| `borderColor` | Color? | null | Custom border color |
| `iconSize` | double? | null | Custom icon size |
| `fontSize` | double? | null | Custom font size |
| `padding` | EdgeInsetsGeometry? | null | Custom padding |
| `borderRadius` | double? | null | Custom border radius |
| `elevation` | double? | null | Elevation (not used yet) |
| `height` | double? | null | Custom height |
| `width` | double? | null | Custom width |
| `fontWeight` | FontWeight? | w400 | Font weight |
| `showShadow` | bool | false | Show shadow effect |
| `iconPosition` | IconPosition | left | Icon position (left/right) |

### Factory Constructors

```dart
CustomButton.primary()    // Primary button
CustomButton.secondary()  // Secondary button
CustomButton.outlined()   // Outlined button
CustomButton.text()       // Text button
CustomButton.icon()       // Icon-only button
CustomButton.danger()     // Danger/destructive button
CustomButton.success()    // Success/confirmation button
```

---

## Migration Guide

### Replacing Old Button Widgets

#### Before (ImportButton)
```dart
ImportButton(
  onTap: () => import(),
)
```

#### After (CustomButton)
```dart
CustomButton(
  label: localizations.import,
  svgIcon: 'assets/icons/bulk_upload_icon_figma.svg',
  onPressed: () => import(),
  backgroundColor: const Color(0xFFE7F2FF),
  foregroundColor: const Color(0xFF155DFC),
)
```

#### Before (ExportButton)
```dart
ExportButton(
  onTap: () => export(),
)
```

#### After (CustomButton)
```dart
CustomButton(
  label: localizations.export,
  svgIcon: 'assets/icons/download_icon.svg',
  onPressed: () => export(),
  backgroundColor: const Color(0xFF4A5565),
  foregroundColor: Colors.white,
)
```

#### Before (GradientIconButton)
```dart
GradientIconButton(
  label: 'Add Position',
  iconPath: 'assets/icons/add_icon.svg',
  onTap: () => addPosition(),
  backgroundColor: AppColors.primary,
)
```

#### After (CustomButton)
```dart
CustomButton(
  label: 'Add Position',
  svgIcon: 'assets/icons/add_icon.svg',
  onPressed: () => addPosition(),
  backgroundColor: AppColors.primary,
  showShadow: true,
)
```

### Replacing Old TextField Widgets

#### Before (Various implementations)
```dart
TextField(
  decoration: InputDecoration(
    hintText: 'Search...',
    border: OutlineInputBorder(),
  ),
)

TextFormField(
  decoration: InputDecoration(
    labelText: 'Name',
  ),
)
```

#### After (CustomTextField)
```dart
CustomTextField(
  controller: searchController,
  hintText: 'Search...',
)

CustomTextField(
  controller: nameController,
  labelText: 'Name',
)
```

---

## Best Practices

### TextField Best Practices

1. **Always use CustomTextField** - Never use TextField or TextFormField directly
2. **Use controllers** - Always provide a TextEditingController for managing state
3. **Validate inputs** - Use the validator parameter for form validation
4. **Provide labels** - Use labelText instead of just hintText for better UX
5. **Mark required fields** - Use isRequired: true for mandatory fields
6. **Theme-aware** - Don't override colors unless absolutely necessary
7. **Responsive** - The widget uses ScreenUtil by default, no need to add .sp/.w/.h

### Button Best Practices

1. **Always use CustomButton** - Never create custom button widgets
2. **Use factories** - Prefer factory constructors for common variants
3. **Choose correct variant** - Use the appropriate variant for the action
4. **Handle loading states** - Use isLoading: true during async operations
5. **Disable when needed** - Pass null to onPressed to disable
6. **Use icons wisely** - Icons enhance understanding, but don't overuse
7. **Consistent sizing** - Stick to the three size options (small, medium, large)
8. **Theme-aware** - Don't override colors unless required by design

---

## DO NOT Create New Widgets

Before creating any new text field or button widget:

1. ✅ Check if CustomTextField/CustomButton can handle your use case
2. ✅ Use the extensive customization options available
3. ✅ Use factory constructors for common patterns
4. ❌ DO NOT duplicate or copy-paste these widgets
5. ❌ DO NOT create variations like "SearchTextField", "PrimaryButton", etc.
6. ❌ DO NOT use TextField, TextFormField, ElevatedButton, TextButton, etc. directly

If you need a feature that doesn't exist, extend CustomTextField/CustomButton rather than creating a new widget.

---

## Questions?

If you're unsure about how to use these widgets for a specific use case, refer to this document or check the extensive inline documentation in the widget files.

Remember: **One TextField Widget, One Button Widget - Used Everywhere!** 🎯

