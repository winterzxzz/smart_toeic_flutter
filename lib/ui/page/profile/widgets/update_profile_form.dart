import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/capitalize_first_letter_input.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';

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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.name_hint,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              inputFormatters: [CapitalizeFirstLetterFormatter()],
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.textGray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              S.current.bio_hint,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              inputFormatters: [CapitalizeFirstLetterFormatter()],
              controller: bioController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.textGray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => GoRouter.of(context).pop(),
                    child: Text(S.current.cancel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BlocConsumer<UserCubit, UserState>(
                    listenWhen: (pre, current) =>
                        pre.updateStatus != current.updateStatus,
                    listener: (context, state) {
                      if (state.updateStatus == LoadStatus.success) {
                        GoRouter.of(context).pop();
                      }
                    },
                    buildWhen: (pre, current) =>
                        pre.updateStatus != current.updateStatus,
                    builder: (context, state) {
                      return CustomButton(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
