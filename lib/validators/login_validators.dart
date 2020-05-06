import 'dart:async';

class LoginValidators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@') && email.contains(".com")) {
      sink.add(email);
    } else {
      sink.addError("Insira um e-mail valido!");
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 6) {
      sink.add(password);
    } else {
      sink.addError("Insira uma senha com no minimo 6 digitos!");
    }
  });
}
