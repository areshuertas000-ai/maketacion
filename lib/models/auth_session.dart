/// Datos de demostración en memoria; no hay persistencia ni peticiones.
class AuthSession {
  const AuthSession({required this.email, this.fullName = ''});
  final String email;
  final String fullName;
  String get initials {
    final words = fullName.trim().split(RegExp(r'\s+'));
    if (fullName.trim().isEmpty) return email.substring(0, 1).toUpperCase();
    return words.take(2).map((word) => word[0]).join().toUpperCase();
  }
}
