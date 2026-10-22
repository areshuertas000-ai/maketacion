import 'package:flutter_test/flutter_test.dart';
import 'package:login_registro/utils/validators.dart';

void main() {
  test(
    'Correo: rechaza vacíos, espacios, dobles arrobas y dominios incompletos',
    () {
      for (final email in [
        '',
        ' ',
        'persona',
        'p@@correo.com',
        'p@correo',
        'p @correo.com',
        'p@.com',
      ]) {
        expect(Validators.email(email), isNotNull, reason: email);
      }
      expect(Validators.email(' ana+clase@universidad.edu.co '), isNull);
    },
  );
  test('Nueva contraseña exige los tres requisitos a la vez', () {
    for (final password in ['', 'a', 'Abc1234', 'abcdefgh1', 'Abcdefgh']) {
      expect(Validators.password(password), isNotNull, reason: password);
    }
    expect(Validators.password('Abcdefg1'), isNull);
    expect(Validators.password('Ñbcdefg1'), isNull);
    expect(Validators.confirm('Abcdefg2', 'Abcdefg1'), isNotNull);
    expect(Validators.confirm('Abcdefg1', 'Abcdefg1'), isNull);
  });
}
