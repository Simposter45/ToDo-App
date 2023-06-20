import 'package:flutter/material.dart';
import 'package:todo_list/models/task_model.dart';

class TaskList extends StatefulWidget {
  final List<TaskModel> taskList;

  TaskList({
    Key? key,
    required this.taskList,
  }) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<TaskModel> tasks = <TaskModel>[];
  bool _isTasksEmpty = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      tasks = widget.taskList;
      _isTasksEmpty = tasks.isEmpty;
    });
  }

  bool _isEmptyList() {
    setState(() {
      _isTasksEmpty = tasks.isEmpty;
    });
    return _isTasksEmpty;
  }

  void _openTaskListPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskListPage(taskList: tasks),
      ),
    );

    // if (updatedTaskList != null) {
    //   setState(() {
    //     tasks = updatedTaskList.map((task) => TaskModel(data: task)).toList();
    //     _isTasksEmpty = tasks.isEmpty;
    //   });
    // }
  }

  // void updateTaskList(List<TaskModel> updatedTaskList) {
  //   setState(() {
  //     tasks = updatedTaskList;
  //     _isTasksEmpty = tasks.isEmpty;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Tasks",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 22,
                ),
              ),
              TextButton(
                onPressed: _isEmptyList() ? null : _openTaskListPage,
                child: const Text(
                  "View All",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _isEmptyList()
                ? const Center(
                    child: Text(
                      "There are no tasks yet",
                      style: TextStyle(fontSize: 22),
                    ),
                  )
                : Hero(
                    tag: 'task-card',
                    child: SizedBox(
                      width: double.infinity,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final item = tasks[index].data;
                          return Dismissible(
                            direction: DismissDirection.startToEnd,
                            key: Key(item!),
                            onDismissed: (direction) {
                              setState(() {
                                tasks.removeAt(index);
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("$item dismissed"),
                                showCloseIcon: true,
                              ));
                            },
                            confirmDismiss: (DismissDirection direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    titleTextStyle:
                                        const TextStyle(fontSize: 24),
                                    contentTextStyle:
                                        const TextStyle(fontSize: 18),
                                    title: const Text("Confirm"),
                                    content: const Text(
                                        "Task Done? Great.. Or is it?"),
                                    actions: <Widget>[
                                      OutlinedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text("YES!"),
                                      ),
                                      OutlinedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("No Wait.."),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            background: Container(color: Colors.red.shade400),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: TaskCard(
                                taskData: tasks[index].data!,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class TaskListPage extends StatefulWidget {
  final List<TaskModel> taskList;
  // final Function(List<TaskModel>) onDeleteTask;

  const TaskListPage({
    Key? key,
    required this.taskList,
    // required this.onDeleteTask,
  }) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Tasks"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: widget.taskList.isEmpty
            ? const Center(
                child: Text(
                  "There are no tasks yet",
                  style: TextStyle(fontSize: 22),
                ),
              )
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: widget.taskList.length,
                itemBuilder: (context, index) {
                  final item = widget.taskList[index].data!;
                  return Dismissible(
                    key: Key(item),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      setState(() {
                        widget.taskList.removeAt(index);
                      });
                      // onDeleteTask(updatedTaskList);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("$item dismissed"),
                          showCloseIcon: true,
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'taskCard_${item}',
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: TaskCard(
                          taskData: item,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class TaskCard extends StatefulWidget {
  final String taskData;

  const TaskCard({
    Key? key,
    required this.taskData,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool isChecked = false;
  bool isStriked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
        MaterialState.selected,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.red;
      }

      return Colors.white;
    }

    return Container(
      padding: const EdgeInsets.all(30),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.3,
            child: Checkbox(
              checkColor: Colors.white,
              shape: const CircleBorder(side: BorderSide(width: 50)),
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                  isStriked = value;
                });
              },
            ),
          ),
          const SizedBox(width: 20),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: Text(
              widget.taskData,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                decoration: isStriked ? TextDecoration.lineThrough : null,
                decorationThickness: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
