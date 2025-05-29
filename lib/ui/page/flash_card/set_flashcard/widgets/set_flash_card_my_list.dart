// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/common/utils/utils.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
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
    return Scaffold(
      body: BlocListener<FlashCardCubit, FlashCardState>(
        listenWhen: (previous, current) =>
            previous.loadStatus != current.loadStatus ||
            previous.flashCards != current.flashCards,
        listener: (context, state) {
          if (state.loadStatus == LoadStatus.failure) {
            AppNavigator(context: context).error(state.message);
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => showCreateSetFlashCardBottomSheet(context),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            S.current.create_new_flashcard,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                } else if (state.loadStatus == LoadStatus.success) {
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
                return const SliverToBoxAdapter(child: SizedBox());
              },
            ),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 16),
            ),
          ],
        ),
      ),
    );
  }

  void showCreateSetFlashCardBottomSheet(BuildContext context) {
    Utils.showModalBottomSheetForm(
      context: context,
      title: S.current.create_new_flashcard_set,
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
