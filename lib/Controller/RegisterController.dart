import 'package:bloc_base/bloc_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:contatos/Helper/Api.dart';
import 'package:contatos/model/PeopleModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:contatos/Helper/RegisterValidator.dart';

enum RegisterState {SUCCESS, FAIL}

class RegisterController extends BaseBloc with RegisterValidator {
  Api _api = Api();

  final _nameController = BehaviorSubject<String>();
  final nameTextController = TextEditingController();
  Stream<String> get outName => _nameController.stream.transform(validateName);
  Function(String) get changeName => _nameController.sink.add;

  final _emailController = BehaviorSubject<String>();
  final emailTextController = TextEditingController();
  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Function(String) get changeEmail => _emailController.sink.add;

  final _phoneController = BehaviorSubject<String>();
  final phoneTextController = TextEditingController();
  Stream<String> get outPhone => _phoneController.stream.transform(validatePhone);
  Function(String) get changePhone => _phoneController.sink.add;

  final _stateController = BehaviorSubject<RegisterState>();
  Stream<RegisterState> get outState => _stateController.stream;
  Function(RegisterState) get changeState => _stateController.sink.add;

  final _editController = BehaviorSubject<PeopleModel>();
  Stream<PeopleModel> get outEdit => _editController.stream;
  Function(PeopleModel) get changeEdit => _editController.sink.add;

  Stream<bool> get outRegisterValid => Observable.combineLatest3(
    outName, outEmail, outPhone, (a, b, c) => true
  );

  createPeople() {
    final _email = _emailController.value;
    final _name = _nameController.value;
    final _phone = _phoneController.value;

    PeopleModel _peopleModel =
      PeopleModel(email: _email, name: _name, phone: _phone);

    _api.createPeople(_peopleModel).then((success) {
      success ?
        _stateController.add(RegisterState.SUCCESS) :
        _stateController.add(RegisterState.FAIL);
      })
      .catchError((error) => _stateController.add(RegisterState.FAIL));
  }

  changePeople() {
    final _people = _editController.value;

    changeName(_people.name);
    changeEmail(_people.email);
    changePhone(_people.phone);

    nameTextController.text = _people.name;
    emailTextController.text = _people.email;
    phoneTextController.text = _people.phone;
  }

  updatePeople() {
    final _name = nameTextController.text;
    final _email = emailTextController.text;
    final _phone = phoneTextController.text;

    PeopleModel _peopleModel =
      PeopleModel(id: _editController.value.id, email: _email, name: _name, phone: _phone);

    _api.updatePeople(_peopleModel).then((success) {
      success ?
        _stateController.add(RegisterState.SUCCESS) :
        _stateController.add(RegisterState.FAIL);
      })
      .catchError((error) => _stateController.add(RegisterState.FAIL));
  }

  @override
  void dispose() {
    _nameController.close();
    _emailController.close();
    _phoneController.close();
    _stateController.close();
    _editController.close();
  }

}