import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/data/models/task_model.dart';
import 'package:firebase/data/remote_data_source/firestore_helper.dart';
import 'package:firebase/presentation/pages/create_and_edit_page.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /* TextEditingController _usernameController = TextEditingController();
  TextEditingController _ageController = TextEditingController(); */

  @override
  void dispose() {
    /* _usernameController.dispose();
    _ageController.dispose(); */
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Align(
            child: Text("Tasks"),
            alignment: Alignment.center,
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateAndEditPage(
                    task: TaskModel(),
                    pageToShow: 'CreatePage',
                  ),
                ),
              );
            },
          ),
          /* actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
                size: 30,
              ),
              onPressed: () {},
            ),
          ], */
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              /* TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "username"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "age"),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  FirestoreHelper.create(TaskModel(
                      username: _usernameController.text,
                      age: _ageController.text));
                  // _create();
                },
                child: Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        "Create",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ), */
              StreamBuilder<List<TaskModel>>(
                  stream: FirestoreHelper.read(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("some error occured"),
                      );
                    }
                    if (snapshot.hasData) {
                      final taskData = snapshot.data;
                      return Expanded(
                        child: Material(
                          child: InkWell(
                            //overlayColor: MaterialStateProperty.all(Colors.red),
                            highlightColor: Colors.blue,
                            splashColor: Colors.green,
                            child: ListView.builder(
                                itemCount: taskData!.length,
                                itemBuilder: (context, index) {
                                  final singleTask = taskData[index];
                                  initializeDateFormatting();
                                  DateTime rememberDate = Intl.withLocale(
                                      'en',
                                      () => DateFormat("yyyy-MM-dd hh:mm:ss")
                                          .parse(singleTask.rememberDate
                                              .toString()));
                                  /*                                   DateFormat("yyyy-MM-dd hh:mm:ss").parse(
                                          '${singleTask.rememberDate.toString().split(' ')[0]} ${singleTask.rememberDate.toString().split(' ')[1]}'); */

                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: ListTile(
                                      minVerticalPadding: 10,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                      dense: true,
                                      onLongPress: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text("Delete"),
                                                content: const Text(
                                                    "Are you sure you want to delete?"),
                                                actions: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        FirestoreHelper.delete(
                                                                singleTask)
                                                            .then((value) {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child:
                                                          const Text("Delete")),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text("Cancel"))
                                                ],
                                              );
                                            });
                                      },
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: singleTask.completed == true
                                            ? const BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle)
                                            : const BoxDecoration(
                                                color: Colors.orange,
                                                shape: BoxShape.circle),
                                        child: singleTask.completed == true
                                            ? const Icon(
                                                Icons.done,
                                                color: Colors.white,
                                                size: 30,
                                              )
                                            : const Icon(
                                                Icons.pending_actions,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                      ),
                                      title: Text(
                                        "${singleTask.name}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        "${rememberDate.toString().compareTo('9999-12-31 00:00:00.000') == 0 ? 'Unassigned date' : rememberDate}\n${singleTask.completed! ? 'Completed' : 'Pending'}",
                                      ),
                                      trailing: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateAndEditPage(
                                                        task: TaskModel(
                                                            id: singleTask.id,
                                                            name:
                                                                singleTask.name,
                                                            description:
                                                                singleTask
                                                                    .description,
                                                            creationDate:
                                                                singleTask
                                                                    .creationDate,
                                                            rememberDate:
                                                                singleTask
                                                                    .rememberDate,
                                                            completed:
                                                                singleTask
                                                                    .completed),
                                                        pageToShow: 'EditPage',
                                                      )));
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

// Future _create() async {
//   final userCollection = FirebaseFirestore.instance.collection("users");
//
//   final docRef = userCollection.doc();
//
//   await docRef.set({
//     "username": _usernameController.text,
//     "age": _ageController.text
//   });
//
//
// }
}
