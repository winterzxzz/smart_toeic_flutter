import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';

import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/text_field_heading.dart';

class FormUpdateProfileArgs {
  final String? name;
  final String? bio;
  final Function(String, String) onSave;

  const FormUpdateProfileArgs({
    required this.name,
    required this.bio,
    required this.onSave,
  });
}

class FormUpdateProfileWidget extends StatefulWidget {
  const FormUpdateProfileWidget({
    super.key,
    required this.args,
  });

  final FormUpdateProfileArgs args;

  @override
  State<FormUpdateProfileWidget> createState() =>
      _FormUpdateProfileWidgetState();
}

class _FormUpdateProfileWidgetState extends State<FormUpdateProfileWidget> {
  late final TextEditingController nameController;
  late final TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.args.name);
    bioController = TextEditingController(text: widget.args.bio);
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldHeading(
              label: S.current.name_hint,
              hintText: S.current.name_hint,
              controller: nameController,
              icon: FontAwesomeIcons.user,
            ),
            const SizedBox(height: 16),
            TextFieldHeading(
              label: S.current.bio_label,
              hintText: S.current.bio_label,
              controller: bioController,
              maxLines: 5,
              icon: FontAwesomeIcons.addressCard,
            ),
            const SizedBox(height: 16),
            BlocBuilder<UserCubit, UserState>(
              bloc: context.read<UserCubit>(),
              builder: (context, state) {
                return CustomButton(
                  width: double.infinity,
                  onPressed: () {
                    if (state.updateStatus == LoadStatus.loading) return;
                    widget.args.onSave(
                      nameController.text,
                      bioController.text,
                    );
                  },
                  isLoading: state.updateStatus == LoadStatus.loading,
                  child: Text(S.current.save_button),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
