// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/common/utils/utils.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/common/widgets/no_data_found_widget.dart';
import 'package:toeic_desktop/ui/page/flash_card/set_flashcard/set_flash_card_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card/set_flashcard/set_flash_card_state.dart';
import 'package:toeic_desktop/ui/page/flash_card/set_flashcard/widgets/form_set_flash_card_dia_log.dart';
import 'package:toeic_desktop/ui/page/flash_card/set_flashcard/widgets/set_flash_card_item.dart';

class SetFlashCardMyListPage extends StatefulWidget {
  const SetFlashCardMyListPage({super.key});

  @override
  State<SetFlashCardMyListPage> createState() => _SetFlashCardMyListPageState();
}

class _SetFlashCardMyListPageState extends State<SetFlashCardMyListPage> {
  late final FlashCardCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = context.read<FlashCardCubit>();
    _cubit.fetchFlashCardSets();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final theme = context.theme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                CustomButton(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(FontAwesomeIcons.plus, size: 16),
                      const SizedBox(width: 8),
                      Text(S.current.create_flashcard_sets),
                    ],
                  ),
                  onPressed: () => showCreateSetFlashCardBottomSheet(context),
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),
          BlocBuilder<FlashCardCubit, FlashCardState>(
            buildWhen: (previous, current) =>
                previous.loadStatus != current.loadStatus ||
                previous.flashCards != current.flashCards,
            builder: (context, state) {
              if (state.loadStatus == LoadStatus.loading) {
                return const SliverFillRemaining(
                  child: LoadingCircle(),
                );
              } else {
                if (state.flashCards.isEmpty) {
                  return const SliverFillRemaining(
                    child: NotDataFoundWidget(),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList.separated(
                    itemBuilder: (context, index) {
                      return SetFlashCardItem(
                        flashcard: state.flashCards[index],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 16);
                    },
                    itemCount: state.flashCards.length,
                  ),
                );
              }
            },
          ),
          const SliverPadding(
            padding: EdgeInsets.only(bottom: 16),
          ),
        ],
      ),
    );
  }

  void showCreateSetFlashCardBottomSheet(BuildContext context) {
    Utils.showModalBottomSheetForm(
      context: context,
      title: S.current.create_flashcard_sets,
      child: FormFlashCard(
        args: FormFlashCardArgs(
          type: FormFlashCardType.create,
          onSave: (title, description) {
            _cubit.createFlashCardSet(title, description);
          },
        ),
      ),
    );
  }
}
