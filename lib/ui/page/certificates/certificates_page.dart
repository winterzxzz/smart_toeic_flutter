import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/certificates/certificates_cubit.dart';
import 'package:toeic_desktop/ui/page/certificates/certificates_state.dart';
import 'package:toeic_desktop/ui/page/certificates/widgets/certificate_card.dart';

class CertificatesPage extends StatefulWidget {
  const CertificatesPage({super.key});

  @override
  State<CertificatesPage> createState() => _CertificatesPageState();
}

class _CertificatesPageState extends State<CertificatesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<CertificatesCubit>(),
      child: const Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({
    super.key,
  });

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late final CertificatesCubit _cubit;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CertificatesCubit>();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              S.current.certificates,
              style: theme.textTheme.titleMedium,
            ),
            floating: true,
            leading: const LeadingBackButton(),
            centerTitle: false,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: S.current.search_certificates_hint,
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 18,
                      ),
                      filled: true,
                      isDense: true,
                      fillColor: theme.cardColor,
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.gray1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                BlocSelector<CertificatesCubit, CertificatesState, LoadStatus>(
                  selector: (state) {
                    return state.loadStatus;
                  },
                  builder: (context, loadStatus) {
                    final isLoading = loadStatus == LoadStatus.loading;
                    return Container(
                      height: 50,
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      child: CustomButton(
                        isLoading: isLoading,
                        onPressed: isLoading
                            ? null
                            : () {
                                _cubit.getCertificates(
                                    searchQuery: _searchController.text);
                              },
                        child: isLoading
                            ? const LoadingCircle(
                                size: 14,
                              )
                            : Text(S.current.search_certificates),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          BlocBuilder<CertificatesCubit, CertificatesState>(
            builder: (context, state) {
              if (state.certificates.isEmpty) {
                return const SliverToBoxAdapter();
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final certificate = state.certificates[index];
                      return CertificateCard(certificate: certificate);
                    },
                    childCount: state.certificates.length,
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
