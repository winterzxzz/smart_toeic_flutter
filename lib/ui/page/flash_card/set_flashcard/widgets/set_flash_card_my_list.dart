// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
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
   late final ImageLabeler _labeler = ImageLabeler(
    options: ImageLabelerOptions(confidenceThreshold: 0.6),
  );
  @override
  void initState() {
    super.initState();
    _cubit = context.read<FlashCardCubit>();
    _cubit.fetchFlashCardSets();
  }

  @override
  void dispose() {
    _labeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final theme = context.theme;
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        shape: const CircleBorder(),
        onPressed: () {
          showModalSelectSource();
        },
        child: const Icon(Icons.camera_enhance),
      ),
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

  void showModalSelectSource() {
    showCupertinoModalPopup(context: context, builder: (context) {
      return CupertinoActionSheet(
        title: const Text('Select source'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => _pickImage(ImageSource.camera),
            child: const Text('Camera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => _pickImage(ImageSource.gallery),
            child: const Text('Gallery'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      );
    });
  }

  void _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: source);
    if (image == null) return;
    final file = File(image.path);
    await _labelImage(file);
  }

  Future<void> _labelImage(File file) async {
    try {
      final input = InputImage.fromFile(file);
      final List<ImageLabel> labels = await _labeler.processImage(input);

      // get max confidence label
      final maxConfidenceLabel = labels.reduce((a, b) => a.confidence > b.confidence ? a : b);

      debugPrint('labels: ${labels.map((e) => e.label).join(', ')} - ${maxConfidenceLabel.label}');
    } catch (e) {
      debugPrint(e.toString());
    } 
  }
}
