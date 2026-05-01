class InputValidator {
  const InputValidator._();

  static bool isEmailValid(String email) {
    return RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
