import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Task To Do App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController taskNameController = TextEditingController();
  String taskName = "";
  int taskIndex = 0;
  List<Map<String, dynamic>> taskList = [];

  // Adds the task name to the Task List
  void addTaskNameToTaskList() {
    getTaskNameFromField();
    if (taskName.isNotEmpty) {
      setState(() {
        taskList.add({
          "index": taskIndex,
          "taskName": taskName,
          "isChecked": false
        });
      });
    }
    taskIndex++;
    taskName = "";
  }

  // Gets the task name from the Text Field
  void getTaskNameFromField() {
    setState(() {
      if (taskNameController.text.isNotEmpty) {
        taskName = taskNameController.text;
      }
    });
    taskNameController.clear();
  }

  // Deletes the task from the table
  void deleteTask(final int index) {
    for (int i = 0; i < taskList.length; i++) {
      if (taskList[i]["index"] == index) {
        setState(() {
          taskList.removeAt(i);
        });
        break;
      }
    }
  }

  // Toggles the check box
  void toggleCheckbox(final int index, final bool? value) {
    for (int i = 0; i < taskList.length; i++) {
      if (taskList[i]["index"] == index) {
        setState(() {
          taskList[i]["isChecked"] = value ?? false;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Table of tasks: ",
            ),
            const SizedBox(height: 16.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Task Name")),
                  DataColumn(label: Text("Completed")),
                  DataColumn(label: Text("Delete")),
                ],
                rows: taskList
                    .asMap()
                    .entries
                    .map(
                      (task) => DataRow(cells: [
                        DataCell(Text(task.value["taskName"])),
                        DataCell(
                          Checkbox(
                            value: task.value["isChecked"],
                            onChanged: (value) =>
                                toggleCheckbox(task.value["index"], value),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteTask(task.value["index"]),
                          ),
                        ),
                  ]),
                )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: 500,
              child: TextField(
                controller: taskNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Task Name",
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTaskNameToTaskList,
        tooltip: "Add Task",
        child: const Icon(Icons.add),
      ),
    );
  }
}
