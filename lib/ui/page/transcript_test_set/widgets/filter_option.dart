import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/ui/page/transcript_test_set/listen_copy_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_set/listen_copy_state.dart';

class FilterOptions extends StatefulWidget {
  const FilterOptions({super.key});

  @override
  State<FilterOptions> createState() => FilterOptionsState();
}

class FilterOptionsState extends State<FilterOptions> {
  late final ListenCopyCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = context.read<ListenCopyCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ListenCopyCubit, ListenCopyState, List<String>>(
      selector: (state) => state.filterParts,
      builder: (context, filterParts) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemBuilder: (context, index) {
            final partNumber = index + 1;
            return CheckboxListTile(
              key: ValueKey('part-$partNumber'),
              title: Text('Part $partNumber'),
              value: filterParts.contains('$partNumber'),
              onChanged: (value) {
                _cubit.setFilterPart('$partNumber');
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            );
          },
          itemCount: 4, // Assuming there are 4 parts
        );
      },
    );
  }
}
