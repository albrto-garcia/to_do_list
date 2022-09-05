import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? id;
  final String? name;
  final String? description;
  final String? creationDate;
  final String? rememberDate;
  final bool? completed;

  TaskModel(
      {this.id,
      this.name,
      this.description,
      this.creationDate,
      this.rememberDate,
      this.completed});

  factory TaskModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return TaskModel(
      id: snapshot['id'],
      name: snapshot['name'],
      description: snapshot['description'],
      creationDate: snapshot['creationDate'],
      rememberDate: snapshot['rememberDate'],
      completed: snapshot['completed'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "creationDate": creationDate,
        "rememberDate": rememberDate,
        "completed": completed,
      };
}
