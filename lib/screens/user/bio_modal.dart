import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomodachi/components/button.dart';
import 'package:tomodachi/components/field/text_field.dart';
import 'package:tomodachi/components/icon_label.dart';
import 'package:tomodachi/components/loading.dart';
import 'package:tomodachi/components/snackbar.dart';
import 'package:tomodachi/providers/auth_provider.dart';
import 'package:tomodachi/providers/user_provider.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/palette.dart';

class BiographyModal extends StatefulWidget {
  BiographyModal({super.key, required this.biography});
  String biography;

  @override
  State<BiographyModal> createState() => _BiographyModalState();
}

class _BiographyModalState extends State<BiographyModal> {
  // * Properties
  final TextEditingController _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      clipBehavior: Clip.antiAlias,
      title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
          child: Center(
              child: Flexible(
                  child: IconLabel(
                      title: 'Edit Biography',
                      icon: Icons.edit,
                      color: Palette.DARK_GREY,
                      iconColor: Palette.ORANGE)))),
      content: Form(
          key: _formKey,
          child: InputField(
              controller: _bioController,
              hint: widget.biography == '' ? 'Biography' : widget.biography,
              horizMargin: 0,
              multiline: true)),
      actions: <Widget>[
        _buildAction(context, 'Edit', () async {
          // Validate the form before submitting.
          if (_formKey.currentState!.validate()) {
            // Save the state.
            _formKey.currentState?.save();
            showLoader(context);

            // Edit the biography.
            String uid = context.read<AuthProvider>().loggedUser!.uid;
            String res = await context
                .read<UserProvider>()
                .editBiography(uid, _bioController.text);

            if (!mounted) return;
            Navigator.pop(context);
            hideLoader(context);

            // Display an error or success message.
            if (res != SUCCESS_MESSAGE) {
              notify(ERROR_SNACK, res);
            } else {
              notify(SUCCESS_SNACK, 'You edited your biography successfully!');
            }
          }
        }, Palette.ORANGE, isPrimary: true),
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
}
