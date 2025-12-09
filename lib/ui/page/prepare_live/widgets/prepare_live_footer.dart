// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:toeic_desktop/data/models/enums/load_status.dart';
// import 'package:toeic_desktop/ui/common/app_context.dart';
// import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
// import 'package:toeic_desktop/ui/page/prepare_live/prepare_live_cubit.dart';
// import 'package:toeic_desktop/ui/page/prepare_live/prepare_live_state.dart';
// import 'package:toeic_desktop/ui/page/prepare_live/widgets/enter_title_model.dart';

// class PrepareLiveFooter extends StatefulWidget {
//   const PrepareLiveFooter({super.key});

//   @override
//   State<PrepareLiveFooter> createState() => _PrepareLiveFooterState();
// }

// class _PrepareLiveFooterState extends State<PrepareLiveFooter> {
//   late final PrepareLiveCubit _prepareLiveCubit;

//   @override
//   void initState() {
//     super.initState();
//     _prepareLiveCubit = BlocProvider.of<PrepareLiveCubit>(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = context.sizze.width;
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: width * 0.7,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const SizedBox(height: 12),
//                 BlocSelector<PrepareLiveCubit, PrepareLiveState, String>(
//                   selector: (state) {
//                     return state.liveName;
//                   },
//                   builder: (context, liveName) {
//                     return _buildActionButton(
//                       icon: Icons.edit,
//                       label: liveName.isEmpty ? 'Enter Title' : liveName,
//                       isHaveData: liveName.isNotEmpty,
//                       isThumbnail: false,
//                       onTap: () => _showTitleDialog(liveName),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 12),
//                 BlocSelector<PrepareLiveCubit, PrepareLiveState, File?>(
//                   selector: (state) {
//                     return state.thumbnail;
//                   },
//                   builder: (context, thumbnail) {
//                     return _buildActionButton(
//                       icon: Icons.image,
//                       label: thumbnail != null
//                           ? 'Change Thumbnail'
//                           : 'Set Thumbnail',
//                       isHaveData: thumbnail != null,
//                       isThumbnail: true,
//                       thumbnail: thumbnail,
//                       onTap: () => _setThumbnail(),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               BlocBuilder<PrepareLiveCubit, PrepareLiveState>(
//                 builder: (context, state) {
//                   final isEnabled =
//                       state.liveName.isNotEmpty && state.thumbnail != null;
//                   return CustomButton(
//                     isLoading: state.loadStatus == LoadStatus.loading,
//                     onPressed: isEnabled
//                         ? () {
//                             _prepareLiveCubit.startCountDownTimer();
//                           }
//                         : null,
//                     child: const Text('Start Live'),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required bool isHaveData,
//     required bool isThumbnail,
//     File? thumbnail,
//     required VoidCallback onTap,
//   }) {
//     final colorScheme = context.colorScheme;
//     final color = isHaveData ? colorScheme.primary : Colors.white;
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(25),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         decoration: BoxDecoration(
//           color: color.withValues(alpha: 0.1),
//           borderRadius: BorderRadius.circular(25),
//           border: Border.all(
//             color: color.withValues(alpha: 0.2),
//             width: 1,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             if (isThumbnail && thumbnail != null)
//               Image.file(
//                 thumbnail,
//                 width: 20,
//                 height: 20,
//               )
//             else
//               Icon(
//                 icon,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: context.textTheme.bodyMedium?.copyWith(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             if (!isHaveData) ...[
//               const SizedBox(width: 8),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   'Required',
//                   style: context.textTheme.labelSmall?.copyWith(
//                     color: Colors.white,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   void _setThumbnail() async {
//     final textTheme = context.textTheme;
//     // allow user to select image from gallery or capture from camera
//     showCupertinoModalPopup(
//         context: context,
//         builder: (context) {
//           return CupertinoActionSheet(
//             title: Text('Select Image', style: textTheme.bodyMedium),
//             actions: [
//               CupertinoActionSheetAction(
//                 onPressed: () {
//                   _prepareLiveCubit.selectImageFrom(ImageSource.gallery);
//                   GoRouter.of(context).pop();
//                 },
//                 child: Text('Gallery', style: textTheme.bodyMedium),
//               ),
//               CupertinoActionSheetAction(
//                 onPressed: () {
//                   _prepareLiveCubit.selectImageFrom(ImageSource.camera);
//                   GoRouter.of(context).pop();
//                 },
//                 child: Text('Camera', style: textTheme.bodyMedium),
//               ),
//             ],
//             cancelButton: CupertinoActionSheetAction(
//               onPressed: () {
//                 GoRouter.of(context).pop();
//               },
//               child: Text('Cancel', style: textTheme.bodyMedium),
//             ),
//           );
//         });
//   }

//   void _showTitleDialog(String liveName) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return EnterTitleModel(
//             onEnterTitle: _prepareLiveCubit.updateTitle, liveName: liveName);
//       },
//     );
//   }
// }
