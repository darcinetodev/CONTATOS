import 'package:flutter/material.dart';
import 'package:contatos/Controller/RegisterController.dart';
import 'package:contatos/model/PeopleModel.dart';
import 'package:contatos/view/InputForm.dart';

class RegisterView extends StatefulWidget {
  final PeopleModel peopleModel;

  RegisterView({this.peopleModel});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  RegisterController _registerController = RegisterController();

  @override
  void initState() {
    super.initState();

    if(widget.peopleModel != null){
      _registerController.changeEdit(widget.peopleModel);
      _registerController.changePeople();
    }

    _registerController.outState.listen((state) {
      switch(state) {
        case RegisterState.SUCCESS:
          showDialog(
            context: context,
              builder: (context) => AlertDialog(
                title: Text('Sucesso'),
                content: Text('Contato salvo!'),
            )
          );
          break;
        case RegisterState.FAIL:
          showDialog(
            context: context,
              builder: (context) => AlertDialog(
                title: Text('Erro'),
                content: Text('Erro ao salvar contato!'),
            )
          );
          break;
        default:
      }
    });
  }

  @override
  void dispose() {
    _registerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<PeopleModel>(
          stream: _registerController.outEdit,
          builder: (context, snapshot) {
            return snapshot.hasData ? Text('Editar Contato') : Text('Cadastrar Contato');
          }
        )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.add_circle_outline, color: Colors.blue, size: 120),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputForm(icon: Icon(Icons.account_circle, color: Colors.blue),
                          hintText: 'Nome',
                          onChange: _registerController.changeName,
                          stream: _registerController.outName,
                          controller: _registerController.nameTextController),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputForm(icon: Icon(Icons.email, color: Colors.blue),
                          hintText: 'Email',
                          onChange: _registerController.changeEmail,
                          input: TextInputType.emailAddress,
                          stream: _registerController.outEmail,
                          controller: _registerController.emailTextController),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputForm(icon: Icon(Icons.phone, color: Colors.blue),
                          hintText: 'Telefone',
                          onChange: _registerController.changePhone,
                          input: TextInputType.phone,
                          stream: _registerController.outPhone,
                          controller: _registerController.phoneTextController),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<bool>(
                  stream: _registerController.outRegisterValid,
                  builder: (context, snapshot) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50)),
                        color: Colors.blue,
                        child: StreamBuilder<PeopleModel>(
                          stream: _registerController.outEdit,
                          builder: (context, snapshot) {
                            return Text((snapshot.hasData ? 'Editar' : 'Cadastrar'),
                                         style: TextStyle(color: Colors.white));
                          }
                        ),
                        onPressed: snapshot.hasData && snapshot.data ?
                                    widget.peopleModel == null ? 
                                      _registerController.createPeople :
                                      _registerController.updatePeople
                                    : () {}
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}