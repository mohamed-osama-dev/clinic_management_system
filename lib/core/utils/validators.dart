class Validators {
  const Validators._();

  static String? requiredField(String? value, {String fieldName = 'الحقل'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  static String? email(String? value) {
    final base = requiredField(value, fieldName: 'البريد الإلكتروني');
    if (base != null) return base;

    final valid = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(value!.trim());
    return valid ? null : 'صيغة البريد الإلكتروني غير صحيحة';
  }
}
