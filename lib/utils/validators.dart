abstract final class Validators {
  static String? required(String? value, [String label = 'Este campo']) =>
      value == null || value.trim().isEmpty
      ? '$label es un campo obligatorio.'
      : null;
  static String? email(String? value) {
    if (required(value, 'El correo') != null) {
      return 'Ingresa tu correo electrónico.';
    }
    if (!RegExp(r'^[^\s@]+@[^\s@.]+(?:\.[^\s@.]+)+$').hasMatch(value!.trim())) {
      return 'Ingresa un correo válido: usuario@dominio.com.';
    }
    return null;
  }

  static bool hasLength(String value) => value.length >= 8;
  static bool hasUppercase(String value) =>
      RegExp(r'[A-ZÁÉÍÓÚÜÑ]').hasMatch(value);
  static bool hasNumber(String value) => RegExp(r'[0-9]').hasMatch(value);
  static bool isStrong(String value) =>
      hasLength(value) && hasUppercase(value) && hasNumber(value);
  static String? password(String? value) {
    if (required(value, 'La contraseña') != null) {
      return 'Ingresa una contraseña.';
    }
    return isStrong(value!)
        ? null
        : 'Usa 8 caracteres o más, una mayúscula y un número.';
  }

  static String? confirm(String? value, String password) {
    if (required(value) != null) return 'Confirma tu contraseña.';
    return value == password ? null : 'Las contraseñas no coinciden.';
  }
}
