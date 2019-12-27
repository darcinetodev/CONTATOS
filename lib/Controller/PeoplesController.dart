import 'package:bloc_base/bloc_base.dart';
import 'package:contatos/Helper/Api.dart';
import 'package:rxdart/rxdart.dart';

enum PeoplesState {SUCCESS, FAIL}

class PeoplesController implements BaseBloc{
  Api _api = Api();

  final _keyController = BehaviorSubject<String>();
  Stream<String> get outKey => _keyController.stream;
  Function(String) get changeKey => _keyController.sink.add;

  final _stateController = BehaviorSubject<PeoplesState>();
  Stream<PeoplesState> get outState => _stateController.stream;
  Function(PeoplesState) get changeState => _stateController.sink.add;

  deletePeople() {
    final _key = _keyController.value;

    _api.deletePeople(_key).then((success) {
      success ?
        _stateController.add(PeoplesState.SUCCESS) :
        _stateController.add(PeoplesState.FAIL);
      })
      .catchError((error) => _stateController.add(PeoplesState.FAIL));
  }
  
  @override
  void dispose() {
    _keyController.close();
    _stateController.close();
  }

}