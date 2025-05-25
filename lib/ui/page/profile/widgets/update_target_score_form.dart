import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';

class UpdateTargetScoreForm extends StatefulWidget {
  const UpdateTargetScoreForm({
    super.key,
  });

  @override
  State<UpdateTargetScoreForm> createState() => _UpdateTargetScoreFormState();
}

class _UpdateTargetScoreFormState extends State<UpdateTargetScoreForm> {
  late final UserCubit userCubit;
  late int readingScore;
  late int listeningScore;

  @override
  void initState() {
    super.initState();
    userCubit = injector<UserCubit>();
    readingScore = userCubit.state.user?.targetScore?.reading ?? 0;
    listeningScore = userCubit.state.user?.targetScore?.listening ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Update Target Score',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  GoRouter.of(context).pop();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Reading target score', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  padding: const EdgeInsets.all(0),
                  value: readingScore.toDouble(),
                  min: 0,
                  max: 450,
                  inactiveColor: theme.primaryColor.withValues(alpha: 0.3),
                  activeColor: theme.primaryColor,
                  label: readingScore.toString(),
                  onChanged: (double value) {
                    setState(() {
                      readingScore = value.round();
                      readingScore = (readingScore / 5).round() * 5;
                    });
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                readingScore.toString(),
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Listening target score', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  padding: const EdgeInsets.all(0),
                  value: listeningScore.toDouble(),
                  min: 0,
                  max: 450,
                  inactiveColor: theme.primaryColor.withValues(alpha: 0.3),
                  activeColor: theme.primaryColor,
                  label: listeningScore.toString(),
                  onChanged: (double value) {
                    setState(() {
                      listeningScore = value.round();
                      listeningScore = (listeningScore / 5).round() * 5;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                listeningScore.toString(),
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 24),
          BlocSelector<UserCubit, UserState, LoadStatus>(
            selector: (state) {
              return state.updateTargetScoreStatus;
            },
            builder: (context, updateTargetScoreStatus) {
              return SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (updateTargetScoreStatus == LoadStatus.loading) {
                      return;
                    }

                    userCubit
                        .updateTargetScore(readingScore, listeningScore)
                        .then((value) {
                      if (context.mounted) {
                        GoRouter.of(context).pop();
                      }
                    });
                  },
                  child: updateTargetScoreStatus == LoadStatus.loading
                      ? const LoadingCircle(
                          size: 20,
                          color: Colors.white,
                        )
                      : Text(
                          'Update',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
