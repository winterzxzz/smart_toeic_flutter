// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:livekit_client/livekit_client.dart';
// import 'package:toeic_desktop/data/models/ui_models/participant_track.dart';

// class GridRemoteTrack extends StatelessWidget {
//   final List<ParticipantTrack> remoteParticipantTracks;
//   final bool isVisible;

//   const GridRemoteTrack({
//     super.key,
//     required this.remoteParticipantTracks,
//     required this.isVisible,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Debug print to track visibility
//     debugPrint(
//         'GridRemoteTrack - isVisible: $isVisible, participants: ${remoteParticipantTracks.length}');

//     if (!isVisible) {
//       return const SizedBox.shrink();
//     }

//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: Colors.black.withValues(alpha: 0.3),
//         borderRadius: BorderRadius.circular(12.0),
//         border: Border.all(
//           color: Colors.white.withValues(alpha: 0.2),
//           width: 1.0,
//         ),
//       ),
//       child: remoteParticipantTracks.isEmpty
//           ? _buildEmptyState()
//           : _buildGrid(context),
//     );
//   }

//   Widget _buildGrid(BuildContext context) {
//     final participantCount = remoteParticipantTracks.length;

//     // Determine grid layout based on participant count
//     final gridConfig = _getGridConfig(participantCount);

//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: gridConfig.crossAxisCount,
//         childAspectRatio: gridConfig.aspectRatio,
//         crossAxisSpacing: 8.0,
//         mainAxisSpacing: 8.0,
//       ),
//       itemCount: participantCount,
//       itemBuilder: (context, index) {
//         final participantTrack = remoteParticipantTracks[index];
//         return ParticipantVideoWidget(
//           participantTrack: participantTrack,
//         );
//       },
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.people_outline,
//               size: 64,
//               color: Colors.white.withValues(alpha: 0.6),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Grid View Active',
//               style: TextStyle(
//                 color: Colors.white.withValues(alpha: 0.9),
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'No participants yet',
//               style: TextStyle(
//                 color: Colors.white.withValues(alpha: 0.8),
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'Participants will appear here when they join',
//               style: TextStyle(
//                 color: Colors.white.withValues(alpha: 0.6),
//                 fontSize: 14,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   GridConfig _getGridConfig(int participantCount) {
//     if (participantCount == 1) {
//       return const GridConfig(crossAxisCount: 1, aspectRatio: 16 / 9);
//     } else if (participantCount <= 4) {
//       return const GridConfig(crossAxisCount: 2, aspectRatio: 16 / 9);
//     } else if (participantCount <= 9) {
//       return const GridConfig(crossAxisCount: 3, aspectRatio: 4 / 3);
//     } else {
//       return const GridConfig(crossAxisCount: 4, aspectRatio: 4 / 3);
//     }
//   }
// }

// class ParticipantVideoWidget extends StatelessWidget {
//   final ParticipantTrack participantTrack;

//   const ParticipantVideoWidget({
//     super.key,
//     required this.participantTrack,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(8.0),
//         border: Border.all(
//           color: Colors.white.withValues(alpha: 0.2),
//           width: 1.0,
//         ),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(8.0),
//         child: Stack(
//           children: [
//             // Video track renderer
//             Positioned.fill(
//               child: _buildVideoRenderer(),
//             ),
//             // Participant info overlay
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: _buildParticipantInfo(),
//             ),
//             // Microphone status indicator
//             Positioned(
//               top: 8,
//               left: 8,
//               child: _buildMicrophoneIndicator(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildVideoRenderer() {
//     final videoTrack = participantTrack.videoTrack;

//     if (videoTrack != null) {
//       return VideoTrackRenderer(
//         videoTrack,
//         fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//       );
//     }

//     // Show placeholder when no video track
//     return Container(
//       color: Colors.grey[900],
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.person,
//               size: 48,
//               color: Colors.white.withValues(alpha: 0.7),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               _getParticipantDisplayName(),
//               style: TextStyle(
//                 color: Colors.white.withValues(alpha: 0.7),
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildParticipantInfo() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.bottomCenter,
//           end: Alignment.topCenter,
//           colors: [
//             Colors.black.withValues(alpha: 0.7),
//             Colors.transparent,
//           ],
//         ),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               _getParticipantDisplayName(),
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMicrophoneIndicator() {
//     final isMuted = !participantTrack.participant.isMicrophoneEnabled();

//     if (!isMuted) {
//       return const SizedBox.shrink();
//     }

//     return Container(
//       padding: const EdgeInsets.all(4.0),
//       decoration: BoxDecoration(
//         color: Colors.red.withValues(alpha: 0.8),
//         borderRadius: BorderRadius.circular(4.0),
//       ),
//       child: const Icon(
//         Icons.mic_off,
//         size: 12,
//         color: Colors.white,
//       ),
//     );
//   }

//   String _getParticipantDisplayName() {
//     final identity = participantTrack.participant.identity;
//     final name = participantTrack.participant.name;

//     if (name.isNotEmpty) {
//       return name;
//     }

//     if (identity.isNotEmpty) {
//       return identity;
//     }

//     return 'Unknown User';
//   }
// }

// class GridConfig {
//   final int crossAxisCount;
//   final double aspectRatio;

//   const GridConfig({
//     required this.crossAxisCount,
//     required this.aspectRatio,
//   });
// }
