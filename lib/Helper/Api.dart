import 'package:http/http.dart';
import 'package:contatos/model/PeopleModel.dart';
import 'Global.dart';

class Api {
  Client client = Client();

  Future<List<PeopleModel>> getPeoples() async {
    final response = await client.get(URL + BASEPEOPLES);
    return response.statusCode == 200 ? peopleFromJson(response.body) : null;
  }

  Future<bool> createPeople(PeopleModel data) async {
  final response = await client.post(
    URL + BASEPEOPLES,
    headers: {"content-type": "application/json"},
    body: peopleToJson(data),
  );
  return response.statusCode == 200 ? true : false;
  }

  Future<bool> deletePeople(String id) async {
  final response = await client.delete(
    URL + BASEPEOPLES + "/$id",
    headers: {"content-type": "application/json"},
  );
  return response.statusCode == 200 ? true : false;
  }

  Future<bool> updatePeople(PeopleModel data) async {
  final response = await client.put(
    URL + BASEPEOPLES + "/" + data.id,
    headers: {"content-type": "application/json"},
    body: peopleToJson(data),
  );
  return response.statusCode == 200 ? true : false;
}

}