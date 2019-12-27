import 'package:flutter/material.dart';
import 'package:contatos/Controller/RegisterController.dart';
import 'package:contatos/Helper/Api.dart';
import 'package:contatos/model/PeopleModel.dart';
import 'package:contatos/Controller/PeoplesController.dart';
import 'package:contatos/view/RegisterView.dart';

class PeoplesView extends StatefulWidget {
  @override
  _PeoplesViewState createState() => _PeoplesViewState();
}

class _PeoplesViewState extends State<PeoplesView> {
  Api _api = Api();
  PeoplesController _peoplesController = PeoplesController();
  RegisterController _registerController = RegisterController();

  @override
  void initState() {
    super.initState();

    _peoplesController.outState.listen((state) {
      switch(state) {
        case PeoplesState.SUCCESS:
          showDialog(
            context: context,
              builder: (context) => AlertDialog(
                title: Text('Sucesso'),
                content: Text('Contato deletado!'),
            )
          );
          break;
        case PeoplesState.FAIL:
          showDialog(
            context: context,
              builder: (context) => AlertDialog(
                title: Text('Erro'),
                content: Text('Falha ao deletar!'),
            )
          );
          break;
        default:
      }
    });
  }

  @override
  void dispose() {
    _peoplesController.dispose();
    _registerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda de Contatos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_box, color: Colors.white),
            onPressed: () {
              _showContactPage();
            },
          )
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _api.getPeoples(),
          builder: (BuildContext context, AsyncSnapshot<List<PeopleModel>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Ocorreu um erro ao carregar: ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<PeopleModel> people = snapshot.data;
              
              return people.length > 0 ? 
                _buildListView(people) :
                Center(
                  child: Text(
                    'Não há o que exibir!',
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildListView(List<PeopleModel> peoples) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemCount: peoples.length,
        itemBuilder: (context, index) {
          PeopleModel people = peoples[index];
          return Dismissible(
            key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
            background: Container(
              color: Colors.red,
              child: Align(
                alignment: Alignment(-0.9, 0.0),
                child: Icon(Icons.delete, color: Colors.white) 
              ),
            ),
            direction: DismissDirection.startToEnd,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Card(
                  color: Colors.white70,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          people.name,
                          style: Theme.of(context).textTheme.title,
                        ),
                        Text(people.email),
                        Text(people.phone),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                _showContactPage(peopleModel: peoples[index]);
                              },
                              child: Text(
                                "Edit",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                      ),
                    ),
                  ),
                ),
            onDismissed: (direction) {
              _peoplesController.changeKey(peoples[index].id);
              _peoplesController.deletePeople();
            },
          );
        }
      ),
    );
  }

  void _showContactPage({PeopleModel peopleModel}) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => RegisterView(peopleModel: peopleModel)));
  }
}