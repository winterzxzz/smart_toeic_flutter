import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/ui_models/result_model.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/page/test/result_test/widgets/result_action_buttons.dart';
import 'package:toeic_desktop/ui/page/test/result_test/widgets/result_header_card.dart';
import 'package:toeic_desktop/ui/page/test/result_test/widgets/result_scrore_section.dart';

class ResultTestPage extends StatelessWidget {
  const ResultTestPage({super.key, required this.resultModel});

  final ResultModel resultModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const LeadingBackButton(),
        elevation: 0,
        title: Text(
          resultModel.testName,
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ResultHeaderCard(resultModel: resultModel),
            const SizedBox(height: 24),
            ResultScoreSection(resultModel: resultModel),
            const SizedBox(height: 24),
            ResultActionButtons(resultModel: resultModel),
          ],
        ),
      ),
    );
  }
}
