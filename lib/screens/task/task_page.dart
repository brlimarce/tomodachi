import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:tomodachi/models/task_model.dart';
import 'package:tomodachi/providers/auth_provider.dart';
import 'package:tomodachi/providers/task_provider.dart';
import 'package:tomodachi/screens/task/task_modal.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/helper.dart';
import 'package:tomodachi/utility/palette.dart';

class TaskPage extends StatefulWidget {
  final String uid; // Identifier of the user.
  const TaskPage({super.key, required this.uid});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> stream =
        context.watch<TaskProvider>().getAllTasks(widget.uid);
    bool isOwner = context.read<AuthProvider>().loggedUser!.uid == widget.uid;

    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return displayStreamError(snapshot);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return displaySmallLoader();
        } else if (!snapshot.hasData) {
          return displayNoStream(snapshot);
        }

        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
          itemBuilder: ((context, index) {
            // Create the task.
            Task task = Task.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>);

            // Render each task's information.
            return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Palette.ORANGE),
                    borderRadius: BorderRadius.circular(6)),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header and Toolbar
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
                                Flexible(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 4),
                                        child: Text(task.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w700))),
                                    Text(task.description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                color: Palette.GREY,
                                                fontWeight: FontWeight.w500))
                                  ],
                                )),

                                // Toolbar
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          // Edit the task.
                                          showDialog(
                                              context: context,
                                              builder: (context) => TaskModal(
                                                  action: EDIT_TASK,
                                                  isOwner: isOwner,
                                                  id: task.id,
                                                  task: task));
                                        },
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue)),
                                    isOwner
                                        ? IconButton(
                                            onPressed: () {
                                              // Delete the task.
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      TaskModal(
                                                          action: DELETE_TASK,
                                                          isOwner: isOwner,
                                                          id: task.id));
                                            },
                                            icon: const Icon(Icons.delete,
                                                color: Palette.RED))
                                        : const SizedBox()
                                  ],
                                ),
                              ]),

                          // Status and Deadline
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                              child: Expanded(
                                  child: Row(children: [
                                Row(children: [
                                  // Status
                                  _buildLabel(
                                      SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircleAvatar(
                                              backgroundColor:
                                                  STATUS[task.status])),
                                      task.status),

                                  // Deadline
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 0, 0),
                                      child: _buildLabel(
                                          const Icon(Icons.timer_outlined,
                                              color: Palette.ORANGE),
                                          formatTimestamp(task.deadline)))
                                ])
                              ]))),

                          // Last Editor
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                              child: Text(
                                  'Last edited by ${task.editor['name']} on ${formatTimestamp(task.editor['timestamp'])}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(color: Palette.GREY)))
                        ])));
          }),
        );
      },
    );
  }

  /// Build a mini version of a customized label based on
  /// [Task.icon] and [Task.title].
  Widget _buildLabel(Widget icon, String title) {
    return Row(children: [
      icon,
      Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child:
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)))
    ]);
  }
}
