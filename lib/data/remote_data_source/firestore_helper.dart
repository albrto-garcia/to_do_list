import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/data/models/task_model.dart';

class FirestoreHelper {
  static Stream<List<TaskModel>> read() {
    final taskCollection = FirebaseFirestore.instance
        .collection("tasks")
        .orderBy('creationDate', descending: false);

    return taskCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => TaskModel.fromSnapshot(e)).toList());
  }

  static Future create(TaskModel task) async {
    final taskCollection = FirebaseFirestore.instance.collection("tasks");
    //print('klk  $taskCollection');
    final uid = taskCollection.doc().id;
    final docRef = taskCollection.doc(uid);

    final newTask = TaskModel(
      id: uid,
      name: task.name,
      description: task.description,
      creationDate: task.creationDate,
      rememberDate: task.rememberDate,
      completed: task.completed,
    ).toJson();
    /* print('klk  $taskCollection | $uid | $docRef | $newTask'); */
    //try {
    docRef.set(newTask).whenComplete(() => print('Todo bien'));
    /* } catch (e) {
      print("some error occured $e");
    } */
  }

  static Future update(TaskModel task) async {
    final taskCollection = FirebaseFirestore.instance.collection("tasks");

    final docRef = taskCollection.doc(task.id);

    final newTask = TaskModel(
      id: task.id,
      name: task.name,
      description: task.description,
      creationDate: task.creationDate,
      rememberDate: task.rememberDate,
      completed: task.completed,
    ).toJson();

    //try {
    docRef.update(newTask);
    /* } catch (e) {
      print("some error occured $e");
    } */
  }

  static Future delete(TaskModel task) async {
    final taskCollection = FirebaseFirestore.instance.collection("tasks");

    final docRef = await taskCollection
        .doc(task.id)
        .delete()
        .whenComplete(() => print('Good'));
  }
}
