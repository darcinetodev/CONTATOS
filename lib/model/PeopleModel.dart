import 'dart:convert';

class PeopleModel {
  String id;
  String name;
  String email;
  String phone;

  PeopleModel({
    this.id,
    this.name,
    this.email,
    this.phone
  });

  factory PeopleModel.fromJson(Map<String, dynamic> map) {
    return PeopleModel(
    id: map["id"],
    name: map["name"],
    email: map["email"],
    phone: map["phone"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone
    };
  }

  toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = this.id;
    map['name'] = this.name;
    map['email'] = this.email;
    map['phone'] = this.phone;
    return map;
  }

  @override
  String toString() {
    return 'PeopleModel{"id": $id, "name": $name, "email": $email, "phone": $phone}';
  }
}

List<PeopleModel> peopleFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<PeopleModel>.from(data.map((item) =>
PeopleModel.fromJson(item)));
}

String peopleToJson(PeopleModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}