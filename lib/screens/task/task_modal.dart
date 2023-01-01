import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tomodachi/components/button.dart';
import 'package:tomodachi/components/field/date_picker.dart';
import 'package:tomodachi/components/field/text_field.dart';
import 'package:tomodachi/components/icon_label.dart';
import 'package:tomodachi/components/loading.dart';
import 'package:tomodachi/components/snackbar.dart';
import 'package:tomodachi/models/task_model.dart';
import 'package:tomodachi/models/user_model.dart';
import 'package:tomodachi/providers/auth_provider.dart';
import 'package:tomodachi/providers/notif_provider.dart';
import 'package:tomodachi/providers/task_provider.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/errors.dart';
import 'package:tomodachi/utility/palette.dart';

// ignore: must_be_immutable
class TaskModal extends StatefulWidget {
  TaskModal(
      {super.key,
      required this.action,
      required this.isOwner,
      this.id,
      this.task});

  /// **********************************************
  /// * Properties
  /// **********************************************

  // ignore: prefer_typing_uninitialized_variables
  final action;

  String? id = '';
  Task? task;
  String date = '';
  static final List<String> items = STATUS.keys.toList();
  bool isOwner;

  @override
  State<TaskModal> createState() => _TaskModalState();
}

class _TaskModalState extends State<TaskModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String selected = TaskModal.items.first;
  late final NotificationProvider service;

  @override
  void initState() {
    service = NotificationProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String label = '';
    String buttonLabel = '';
    Color buttonColor = Palette.ORANGE;
    Function() handler = () {};

    // Initialize properties (e.g. font, icon) based
    // on the action to be done.
    switch (widget.action) {
      case ADD_TASK:
        // Properties
        label = ADD_TASK;
        buttonLabel = 'Add';
        buttonColor = Palette.GREEN;

        // Handler
        handler = () {
          _submitForm();
        };
        break;
      case EDIT_TASK:
        // Properties
        label = EDIT_TASK;
        buttonLabel = 'Edit';
        buttonColor = Colors.blue;

        // Handler
        handler = () {
          _submitForm(isDisabled: !widget.isOwner);
        };
        break;
      case DELETE_TASK:
        // Properties
        label = DELETE_TASK;
        buttonLabel = 'Delete';
        buttonColor = Palette.RED;

        // Handler
        handler = () {
          _action(widget.action, id: widget.id);
        };

        break;
    }

    return AlertDialog(
      title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
          child: Center(
              child: Flexible(
                  child: IconLabel(
                      title: label,
                      icon: Icons.donut_large_rounded,
                      color: Palette.DARK_GREY,
                      iconColor: buttonColor)))),
      content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: widget.action == DELETE_TASK
              ? const Text(
                  'Are you sure you want to delete this task? You will not be able to recover its progress.')
              : Form(
                  key: _formKey,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    // Task Name
                    InputField(
                        controller: _titleController,
                        hint: widget.action == EDIT_TASK
                            ? widget.task!.title
                            : 'Task Name',
                        horizMargin: 0,
                        topMargin: 0),

                    // Task Description
                    InputField(
                        controller: _descriptionController,
                        hint: widget.action == EDIT_TASK
                            ? widget.task!.description
                            : 'Task Description',
                        multiline: true,
                        horizMargin: 0),

                    // Status
                    widget.isOwner
                        ? SizedBox(
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        border: Border.all(
                                            color: Palette.GREY,
                                            style: BorderStyle.solid,
                                            width: 1)),
                                    child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                      value: selected,
                                      items: TaskModal.items.map((String item) {
                                        return DropdownMenuItem(
                                            value: item,
                                            child: IconLabel(
                                                icon: Icons.circle,
                                                title: item,
                                                color: Palette.BLACK,
                                                iconColor: STATUS[item]));
                                      }).toList(),

                                      // Change Handler
                                      onChanged: (String? value) {
                                        setState(() {
                                          selected = value!;
                                        });
                                      },
                                    )))))
                        : const SizedBox(),

                    // Deadline
                    DatePicker(
                        hint: 'Deadline',
                        controller: _dateController,
                        startDate: DateTime.now(),
                        endDate: DateTime(2100),
                        onchange: (value) {
                          setState(() {
                            widget.date = value;
                          });
                        },
                        horizMargin: 0),

                    // Time Picker
                    SizedBox(
                        width: double.infinity,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 20),
                            child: TextFormField(
                                controller: _timeController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Time'),
                                onTap: () async {
                                  final timePicker = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now());
                                  // Set the state for the time picker.
                                  if (timePicker != null) {
                                    if (!mounted) return;
                                    final text = timePicker.format(context);
                                    setState(() {
                                      _timeController.text = text;
                                    });
                                  }
                                },
                                validator: (value) {
                                  // Required Field
                                  if (value == null || value.isEmpty) {
                                    return getRequiredError(
                                        'Time'.toLowerCase());
                                  }

                                  // Date should not be an empty first
                                  // before checking the deadline.
                                  if (_dateController.text.isEmpty) {
                                    return 'Fill out the date for the deadline.';
                                  }

                                  // Time should be an hour before.
                                  if (_getDeadline()
                                          .difference(DateTime.now())
                                          .inHours <
                                      1) {
                                    return 'Deadline should be an hour before.';
                                  }
                                })))
                  ]))),
      actions: <Widget>[
        _buildAction(context, buttonLabel, handler, buttonColor,
            isPrimary: true),
        _buildAction(context, 'Cancel',
            () => {Navigator.pop(context, 'Cancel')}, Palette.GREY),
        const SizedBox(height: HORIZONTAL_MARGIN)
      ],
    );
  }

  /// Build a [ElevatedButton] with full width.
  AppButton _buildAction(
      BuildContext context, String label, Function() onclick, Color color,
      {bool isPrimary = false}) {
    return AppButton(
        context: context,
        label: label,
        onclick: onclick,
        color: color,
        isPrimary: isPrimary);
  }

  /// Add or edit a task based on [Form].
  _submitForm({bool? isDisabled = false}) async {
    // Validate the form before submitting.
    if (_formKey.currentState!.validate()) {
      // Save the state.
      _formKey.currentState?.save();
      showLoader(context);

      // Create a new Task object.
      String uid = context.read<AuthProvider>().loggedUser!.uid;
      User owner = context.read<AuthProvider>().selectedUser!;
      String name = '${owner.firstName} ${owner.lastName}';

      Task task = Task(
          uid: uid,
          title: _titleController.text,
          description: _descriptionController.text,
          status: selected,
          deadline: Timestamp.fromDate(_getDeadline()),
          editor: {'name': name, 'timestamp': Timestamp.now()});

      // Check if the task should be added or edited.
      if (widget.action == ADD_TASK) {
        _action(widget.action, task: task);
      } else {
        _action(widget.action, id: widget.id, isDisabled: isDisabled);
      }
    }
  }

  /// Call the right action to [TaskProvider]
  /// to CUD a [Task] in Firebase.
  _action(String action, {Task? task, String? id, bool? isDisabled}) async {
    // Perform the desired operation.
    String res = '';
    if (action == ADD_TASK) {
      // Add the task.
      res = await context.read<TaskProvider>().addTask(task!);
    } else if (action == EDIT_TASK) {
      // Store the response in separate variables.
      String title = _titleController.text;
      String description = _descriptionController.text;
      DateTime deadline = _getDeadline();

      User owner = context.read<AuthProvider>().selectedUser!;
      String name = '${owner.firstName} ${owner.lastName}';

      // Edit the task depending on permissions.
      if (isDisabled!) {
        res = await context
            .read<TaskProvider>()
            .editFriendTask(id, title, description, deadline, name);
      } else {
        res = await context
            .read<TaskProvider>()
            .editTask(id, title, description, deadline, selected, name);
      }
    } else {
      // Delete the task.
      showLoader(context);
      res = await context.read<TaskProvider>().deleteTask(id!);
    }

    if (!mounted) return;
    Navigator.pop(context);
    hideLoader(context);

    // Display an error or success message.
    if (res != SUCCESS_MESSAGE) {
      notify(ERROR_SNACK, res);
    } else {
      // Display a success snackbar.
      notify(
          SUCCESS_SNACK,
          'You have ${action == ADD_TASK ? 'added' : action == EDIT_TASK ? 'edited' : 'deleted'} the task successfully!');

      // Set a scheduled notification after
      // adding the task.
      if (action == ADD_TASK) {
        await service.showNotification(
            id: 0,
            title: '⏰ 1 hour left!',
            body: '${_titleController.text} is due soon! Check it out?',
            deadline: _getDeadline(),
            payload: SUCCESS_MESSAGE);
      }
    }
  }

  /// Return the merged date and time for
  /// the task's deadline.
  DateTime _getDeadline() {
    return DateFormat('yyyy-MM-dd hh:mm aaa').parse(
        '${_dateController.text} ${_timeController.text}'
            .replaceAll('pm', 'PM')
            .replaceAll('am', 'AM'));
  }
}
