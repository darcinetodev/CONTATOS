import 'dart:async';
import 'package:email_validator/email_validator.dart';

class RegisterValidator {

  final validateName = StreamTransformer<String, String>.fromHandlers(
    handleData: (name, sink){
      if(name.length >= 3) {
        sink.add(name);
      } else {
        sink.addError('Seu nome deve ter mais que 3 digitos!');
      }
    }
  );

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){
      if(EmailValidator.validate(email)){
        sink.add(email);
      } else {
        sink.addError('E-mail inválido!');
      }
    }
  );
  
  final validatePhone = StreamTransformer<String, String>.fromHandlers(
    handleData: (phone, sink){
      if (phone.length >= 9){
        sink.add(phone);
      } else {
        sink.addError('Número de telefone inválido!');
      }
    }
  );

}